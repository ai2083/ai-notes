# AI笔记APP 开发指导

## 项目概述

这是一个基于Flutter开发的AI驱动笔记应用，支持iOS、Android和Web平台。应用具备多格式文件处理、AI内容生成、智能学习工具等核心功能。

## 快速开始

### 环境准备

1. **安装Flutter SDK**
   ```bash
   # 下载Flutter SDK并添加到PATH
   export PATH="$PATH:[PATH_TO_FLUTTER_GIT_DIRECTORY]/flutter/bin"
   
   # 验证安装
   flutter doctor
   ```

2. **安装依赖**
   ```bash
   cd ai_notes_flutter
   flutter pub get
   ```

3. **配置Firebase**
   ```bash
   # 安装Firebase CLI
   npm install -g firebase-tools
   
   # 登录Firebase
   firebase login
   
   # 配置项目
   flutterfire configure
   ```

### 运行应用

```bash
# 运行在调试模式
flutter run

# 运行在Web
flutter run -d chrome

# 构建发布版本
flutter build apk --release  # Android
flutter build ios --release  # iOS
flutter build web --release  # Web
```

## 项目结构

```
lib/
├── core/                     # 核心模块
│   ├── constants/           # 常量定义
│   ├── error/              # 错误处理
│   ├── network/            # 网络配置
│   ├── storage/            # 存储配置
│   ├── utils/              # 工具类
│   └── di/                 # 依赖注入
├── features/               # 功能模块
│   ├── auth/               # 身份认证
│   ├── notes/              # 笔记管理
│   ├── upload/             # 文件上传
│   ├── ai_generation/      # AI生成
│   ├── flashcards/         # 闪卡系统
│   ├── quiz/               # 测验系统
│   ├── chat/               # AI聊天
│   ├── audio/              # 音频功能
│   ├── sync/               # 数据同步
│   └── sharing/            # 分享功能
├── shared/                 # 共享组件
│   ├── widgets/            # UI组件
│   ├── models/             # 数据模型
│   ├── services/           # 服务类
│   ├── theme/              # 主题配置
│   ├── routes/             # 路由配置
│   └── extensions/         # 扩展方法
└── main.dart              # 应用入口
```

## 功能模块开发

### 1. 身份认证模块 (Auth)

**位置**: `lib/features/auth/`

**主要文件**:
- `domain/entities/user.dart` - 用户实体
- `domain/repositories/auth_repository.dart` - 认证仓库接口
- `data/repositories/auth_repository_impl.dart` - 认证仓库实现
- `presentation/screens/login_screen.dart` - 登录页面
- `presentation/providers/auth_provider.dart` - 认证状态管理

**开发步骤**:
1. 定义用户实体和认证接口
2. 实现Firebase认证服务
3. 创建登录/注册UI
4. 集成状态管理

### 2. 笔记管理模块 (Notes)

**位置**: `lib/features/notes/`

**主要功能**:
- 笔记CRUD操作
- 本地存储和云同步
- 搜索和分类
- 导出功能

**开发重点**:
- 设计灵活的笔记数据模型
- 实现离线优先的存储策略
- 优化大量笔记的性能

### 3. 文件上传模块 (Upload)

**位置**: `lib/features/upload/`

**支持格式**:
- 音频: MP3, WAV, M4A
- 视频: MP4, AVI, MOV
- 文档: PDF, DOC, PPT
- 图片: JPG, PNG, GIF

**技术要点**:
- 文件格式验证
- 上传进度显示
- 错误处理和重试机制
- 文件压缩优化

### 4. AI生成模块 (AI Generation)

**位置**: `lib/features/ai_generation/`

**核心服务**:
- 语音转文字 (Speech-to-Text)
- 内容结构化处理
- 笔记美化排版
- 多语言支持

**集成AI服务**:
- OpenAI GPT API
- Google Cloud Speech API
- 百度AI开放平台
- 科大讯飞语音API

### 5. 学习工具模块

**闪卡系统** (`lib/features/flashcards/`):
- 间隔重复算法
- 学习进度追踪
- 自定义卡片模板

**测验系统** (`lib/features/quiz/`):
- 多种题型支持
- 智能出题算法
- 错题分析

## 数据架构

### 本地存储 (Hive)

```dart
// 笔记模型
@HiveType(typeId: 0)
class Note extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String title;
  
  @HiveField(2)
  String content;
  
  @HiveField(3)
  DateTime createdAt;
  
  @HiveField(4)
  DateTime updatedAt;
  
  @HiveField(5)
  List<String> tags;
  
  @HiveField(6)
  bool isSynced;
}
```

### 云端存储 (Firestore)

```javascript
// 用户文档结构
users/{userId} {
  profile: {
    email: string,
    displayName: string,
    avatar: string,
    subscription: string,
    createdAt: timestamp
  }
}

// 笔记集合结构
users/{userId}/notes/{noteId} {
  title: string,
  content: string,
  tags: array,
  folderId: string,
  createdAt: timestamp,
  updatedAt: timestamp,
  metadata: {
    wordCount: number,
    readTime: number,
    language: string
  }
}
```

## UI/UX 设计原则

### 1. 设计系统

- **颜色方案**: 基于Material Design 3
- **字体系统**: Roboto字体家族
- **间距系统**: 8px网格系统
- **圆角规范**: 8px/12px/16px

### 2. 响应式设计

```dart
// 断点定义
class Breakpoints {
  static const double mobile = 480;
  static const double tablet = 768;
  static const double desktop = 1024;
}

// 响应式组件示例
class ResponsiveWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < Breakpoints.tablet) {
          return MobileLayout();
        } else if (constraints.maxWidth < Breakpoints.desktop) {
          return TabletLayout();
        } else {
          return DesktopLayout();
        }
      },
    );
  }
}
```

### 3. 动画设计

- **微动画**: 200ms快速反馈
- **页面转场**: 400ms流畅过渡
- **加载动画**: 骨架屏和进度指示

## 性能优化

### 1. 内存管理

```dart
// 图片缓存优化
class ImageCacheManager {
  static const int maxCacheSize = 100;
  static final LRUCache<String, ui.Image> _cache = 
      LRUCache<String, ui.Image>(maxCacheSize);
}

// 列表性能优化
ListView.builder(
  itemCount: items.length,
  cacheExtent: 1000, // 预加载范围
  itemBuilder: (context, index) {
    return ListTile(
      title: Text(items[index].title),
    );
  },
)
```

### 2. 网络优化

```dart
// HTTP缓存配置
final dio = Dio();
dio.interceptors.add(DioCacheInterceptor(
  options: CacheOptions(
    store: HiveCacheStore(Hive.box('dio_cache')),
    maxStale: Duration(days: 7),
  ),
));

// 文件上传优化
class FileUploadService {
  static Future<String> uploadWithCompression(File file) async {
    // 图片压缩
    if (isImageFile(file)) {
      file = await compressImage(file);
    }
    
    // 分片上传大文件
    if (file.lengthSync() > 10 * 1024 * 1024) {
      return await multipartUpload(file);
    }
    
    return await simpleUpload(file);
  }
}
```

## 测试策略

### 1. 单元测试

```dart
// 测试示例
group('NotesRepository', () {
  late NotesRepository repository;
  late MockApiService mockApiService;
  
  setUp(() {
    mockApiService = MockApiService();
    repository = NotesRepositoryImpl(mockApiService);
  });
  
  test('should return notes when API call is successful', () async {
    // Arrange
    final expectedNotes = [Note(id: '1', title: 'Test')];
    when(mockApiService.getNotes())
        .thenAnswer((_) async => expectedNotes);
    
    // Act
    final result = await repository.getNotes();
    
    // Assert
    expect(result, equals(expectedNotes));
  });
});
```

### 2. 集成测试

```dart
// 端到端测试
testWidgets('complete note creation flow', (tester) async {
  await tester.pumpWidget(MyApp());
  
  // 点击创建按钮
  await tester.tap(find.byKey(Key('create_note_fab')));
  await tester.pumpAndSettle();
  
  // 输入标题和内容
  await tester.enterText(find.byKey(Key('title_field')), 'Test Note');
  await tester.enterText(find.byKey(Key('content_field')), 'Test Content');
  
  // 保存笔记
  await tester.tap(find.byKey(Key('save_button')));
  await tester.pumpAndSettle();
  
  // 验证笔记已创建
  expect(find.text('Test Note'), findsOneWidget);
});
```

## 部署和发布

### 1. Android发布

```bash
# 生成签名密钥
keytool -genkey -v -keystore ~/key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias key

# 配置签名
# android/app/build.gradle

# 构建发布版本
flutter build apk --release
flutter build appbundle --release
```

### 2. iOS发布

```bash
# 配置证书和描述文件
# 在Xcode中配置Team和Bundle Identifier

# 构建发布版本
flutter build ios --release

# 创建IPA文件
cd ios && xcodebuild -workspace Runner.xcworkspace -scheme Runner -configuration Release archive -archivePath build/Runner.xcarchive
```

### 3. Web发布

```bash
# 构建Web版本
flutter build web --release

# 部署到Firebase Hosting
firebase deploy --only hosting
```

## 持续集成/持续部署 (CI/CD)

### GitHub Actions配置

```yaml
name: Flutter CI/CD

on:
  push:
    branches: [ main, develop ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.10.0'
      - run: flutter pub get
      - run: flutter test
      - run: flutter analyze

  build-android:
    needs: test
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter build apk --release
      - uses: actions/upload-artifact@v3
        with:
          name: android-apk
          path: build/app/outputs/flutter-apk/app-release.apk
```

## 代码规范

### 1. 命名规范

- **文件名**: 使用snake_case (例: `user_profile_screen.dart`)
- **类名**: 使用PascalCase (例: `UserProfileScreen`)
- **变量名**: 使用camelCase (例: `userProfile`)
- **常量**: 使用lowerCamelCase (例: `defaultTimeout`)

### 2. 目录结构规范

```
feature_name/
├── data/
│   ├── datasources/
│   ├── models/
│   └── repositories/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── usecases/
└── presentation/
    ├── providers/
    ├── screens/
    └── widgets/
```

### 3. 提交规范

```
type(scope): description

feat(auth): add user registration functionality
fix(notes): resolve sync issue with large files
docs(readme): update installation instructions
style(ui): improve button hover states
refactor(api): extract common request logic
test(notes): add unit tests for note repository
```

## 问题排查

### 常见问题

1. **Flutter版本兼容性**
   ```bash
   flutter --version
   flutter upgrade
   ```

2. **依赖冲突**
   ```bash
   flutter pub deps
   flutter pub upgrade
   ```

3. **平台特定问题**
   ```bash
   flutter doctor
   flutter clean && flutter pub get
   ```

### 调试技巧

1. **使用Flutter Inspector**
2. **启用详细日志**: `flutter run --verbose`
3. **性能分析**: `flutter run --profile`
4. **内存分析**: `flutter run --trace-startup`

## 下一步开发计划

### Phase 1: 基础功能 (4周)
- [ ] 用户认证系统
- [ ] 基础笔记CRUD
- [ ] 文件上传功能
- [ ] 基础UI框架

### Phase 2: AI功能 (6周)
- [ ] 语音转文字
- [ ] AI笔记生成
- [ ] 内容结构化
- [ ] 多语言支持

### Phase 3: 学习工具 (4周)
- [ ] 闪卡系统
- [ ] 测验功能
- [ ] AI聊天助手
- [ ] 音频生成

### Phase 4: 高级功能 (4周)
- [ ] 跨平台同步
- [ ] 分享协作
- [ ] 高级搜索
- [ ] 数据分析

### Phase 5: 优化发布 (2周)
- [ ] 性能优化
- [ ] 测试完善
- [ ] 应用商店发布
- [ ] 用户反馈收集

---

欢迎贡献代码和反馈问题！更多详细信息请参考项目文档。
