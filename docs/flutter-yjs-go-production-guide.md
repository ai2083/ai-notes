# Flutter + Yjs + Go：跨 App、Desktop、Web 的生产级协作编辑方案

> 结论：**可以生产落地**。推荐采用 **Flutter（壳/原生能力） + Web 编辑器（Yjs + TipTap/ProseMirror 等） + Go 同步服务** 的分层方案；必要时先用 Node `y-websocket` 快速跑通，再以 Go 等价协议替换。可实现跨 iOS/Android/macOS/Windows/Web 的一致编辑体验、离线能力与强最终一致性（CRDT）。

---

## 架构分层（生产可用）

### 1) 前端编辑器（Web 技术栈）
- 富文本：TipTap/ProseMirror、Quill、CodeMirror … + **Yjs 适配器**（`y-prosemirror`、`y-quill`、`y-codemirror`）
- **Yjs**：块级 CRDT（`Y.Text`）+ `awareness`（光标/选区）+ `y-indexeddb`（离线持久化）
- 运行位置：
  - **Flutter Web**：直接同域加载编辑器页面
  - **Flutter iOS/Android/macOS/Windows**：在 WebView（WKWebView/WebView2/Android WebView）中运行
- 优势：生态成熟、IME（中文输入法）处理良好、与 Yjs 适配器配套完善

### 2) Flutter 宿主 App（Dart）
- 负责：路由/导航、登录、文档列表、本地缓存、系统能力（相机/分享/推送）
- 与 Web 编辑器通信：`postMessage` / `JavaScriptChannel`
  - 能力：`open(docId)`、`exportHTML()`、`insertImage(url)`、`saveSnapshot()` 等

### 3) Go 同步后端
- **WebSocket 房间** + **append-only 存储**（Badger/BoltDB/SQLite/Postgres）
- 对外接口：
  - **WS**：广播/落库 Yjs **update（二进制 diff）** 与 `awareness` 心跳
  - **HTTP**：鉴权、文档元数据、**快照（snapshot）**、历史增量拉取、审计
- 前置：Nginx/Traefik；鉴权：JWT/OIDC

> 注：Yjs 常用 Node `y-websocket`。为快速启动可先用 Node；稳定后再以 **Go 等价协议** 替换。关键在于遵循 **y-protocols**（sync/awareness）的帧格式与房间广播/落库/快照恢复语义。

---

## 跨端可行性与注意点

- **Web**：Yjs + IndexedDB 天然离线，重连自动合并
- **iOS/Android**（WebView）：iOS 14+ 的 WKWebView、Android WebView 支持 IndexedDB，离线无阻
- **macOS/Windows/Linux**：Flutter + WebView2/WKWebView 一致
- **性能**：块级 CRDT（每段为独立 `Y.Text`）+ 节流 UI 更新 + update 压缩/快照 ⇒ 百万字可控
- **中文/IME**：Web 编辑器层更成熟，优于原生 Flutter TextField 的 CRDT 粒度处理

---

## 从 0 到上线：实施步骤

### 阶段 A：最快闭环（2–5 天）
1. **Web 编辑器**：TipTap + `y-prosemirror` + `y-websocket` + `y-indexeddb`
2. **Flutter 外壳**：
   - Web：直接路由到编辑器
   - 移动/桌面：`flutter_inappwebview` / `webview_flutter` 加载 `editor/index.html`
   - 建立双向桥：`open(docId)`, `exportHTML()`, `insertImage(url)`…
3. **后端（先快）**：Node `y-websocket` 提供同步；Go 提供鉴权/文档列表/权限
4. **离线验证**：断网编辑 → 重连 → 合并一致

### 阶段 B：替换为 Go 同步服务（1–2 周）
1. **Go 实现 y-websocket 等价协议**（gorilla/websocket）
   - 房间管理：`map[docId]set[*conn]`
   - 帧协议：支持 `sync` / `awareness` 二进制帧；或自定义 provider 透传 update
   - 存储：`docId:y:seq → []byte(update)`；每 N 条生成 **快照**（`stateAsUpdate`）
   - 恢复：新会话先发快照、再发快照之后的增量
2. **鉴权**：WS 握手携带 JWT，校验 doc ACL
3. **可观测性**：Prometheus 指标（连接数、房间数、update 大小/秒、广播时延）、结构化日志
4. **压缩/GC**：快照与 tombstone 清理（所有副本 ack 后）

### 阶段 C：工程化增强
- 文档分片：按 `blockId` 订阅/同步，仅加载可见块
- 富文本样式：mark-CRDT 或 LWW 范围属性；图片/附件→对象存储（S3/OSS/MinIO）
- 审计/回滚：append-only log + 周期快照
- 多活扩展：按 `docId` 一致性哈希分片；Sticky 会话或 Redis Pub/Sub 共享房间
- 端到端加密（可选）：对 update 做会话层加密，服务端仅中转

---

## 关键代码骨架

### 1) Flutter ↔ Web 编辑器通信（示例，`flutter_inappwebview`）
```dart
final controller = ValueNotifier<InAppWebViewController?>(null);

InAppWebView(
  initialFile: 'assets/editor/index.html',
  onWebViewCreated: (c) => controller.value = c,
  onLoadStop: (c, _) async {
    await c.evaluateJavascript(source: "window.editor.openDoc('doc-123');");
  },
  onConsoleMessage: (_, msg) => debugPrint('[editor] ${msg.message}'),
  initialUserScripts: UnmodifiableListView([
    UserScript(
      source: """
        window.flutterBridge = {
          export: (payload) => window.flutter_inappwebview.callHandler('onExport', payload)
        };
      """,
      injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
    )
  ]),
);

c.addJavaScriptHandler(handlerName: 'onExport', callback: (args) {
  final json = args.first as Map<String, dynamic>;
  // 处理导出的 HTML/Markdown
});
```

### 2) Go：最小 Yjs update 中转（方向/伪代码）
```go
type Conn struct{ ws *websocket.Conn; docId string }
var rooms = map[string]map[*Conn]bool{}
var store Store // append-only: Put(docId, seq, update []byte), GetFrom(docId, from int)

func handleWS(w http.ResponseWriter, r *http.Request) {
  ws, _ := upgrader.Upgrade(w, r, nil)
  c := &Conn{ws: ws}

  // 1) 接收 join(docId) 控制帧（文本或 JSON）
  t, msg, _ := ws.ReadMessage()
  if t != websocket.TextMessage { ws.Close(); return }
  c.docId = parseDocId(msg)
  joinRoom(c)

  // 2) 下发历史（先快照，再增量）
  snap, from := store.GetLatestSnapshot(c.docId)
  if len(snap) > 0 { ws.WriteMessage(websocket.BinaryMessage, snap) }
  for _, u := range store.GetFrom(c.docId, from) {
    ws.WriteMessage(websocket.BinaryMessage, u)
  }

  // 3) 接收增量并广播/落库
  for {
    mt, data, err := ws.ReadMessage(); if err != nil { break }
    if mt == websocket.BinaryMessage {
      store.Append(c.docId, data)
      broadcast(c.docId, c, data)
    } else {
      // awareness / 心跳等
    }
  }
  leaveRoom(c)
}
```

### 3) Web 编辑器：Yjs 自定义 Provider（透传模式）
```js
import * as Y from 'yjs'
const doc = new Y.Doc()
const ws = new WebSocket('wss://your-go/ws')

ws.onopen = () => ws.send(JSON.stringify({ type: 'join', docId }))
ws.onmessage = async (ev) => {
  if (typeof ev.data !== 'string') {
    const buf = new Uint8Array(await ev.data.arrayBuffer())
    Y.applyUpdate(doc, buf, 'remote')
  }
}
doc.on('update', (update, origin) => {
  if (origin !== 'remote') ws.send(update) // 避免回环
})
```

---

## 生产级 Checklist

- **离线**：IndexedDB（Web/WebView），提供导出/恢复备份
- **快照**：每 N 条 update 生成 `encodeStateAsUpdate`；新会话“快照→增量”
- **分片**：按块订阅，只渲染可见块
- **样式冲突**：范围属性用 mark-CRDT 或 LWW
- **鉴权/ACL**：JWT + 文档级权限；WS 握手校验
- **可观测性**：连接数、房间数、update 吞吐、广播时延、错误率
- **压测**：100 并发编辑、弱网/断网重连、移动端内存与耗电
- **多活**：分片路由/Sticky 会话/Redis 广播
- **备份/审计**：append-only log + 周期快照（回滚/时间穿梭）
- **合规/加密**（可选）：端到端加密或租户级密钥

---

## 结论

- **Flutter + Yjs + Go** 是 **Production Ready** 的跨端协作编辑组合。  
- **最佳路径**：先用 Node `y-websocket` 起步 → 稳定后用 Go 实现等价同步协议。  
- 长期演进可加入：块级分片、快照压缩、分布式房间、端到端加密、审计与回滚等工程化能力。
