# 🤖 AI Notes - 智能笔记应用

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-039BE5?style=for-the-badge&logo=Firebase&logoColor=white)
![AI](https://img.shields.io/badge/AI-Powered-green?style=for-the-badge)

</div>

## 🌟 项目概述

AI Notes是一款基于人工智能技术的多平台笔记应用，支持iOS、Android和Web平台。应用集成了先进的AI技术，能够将各种格式的内容（音频、视频、PDF、网页等）智能转换为结构化笔记，并提供闪卡、测验、AI聊天等智能学习工具。

## ✨ 核心功能

### 🎯 多格式输入处理
- **音频文件**: MP3, WAV, M4A等格式支持
- **视频文件**: MP4, AVI, MOV等格式支持  
- **文档文件**: PDF, DOC, PPT, TXT等格式支持
- **网络资源**: YouTube链接、网页URL智能抓取
- **实时录音**: 设备麦克风录制功能
- **图片识别**: OCR文字识别技术

### 🧠 AI智能生成
- **内容提取**: 从音视频中智能提取文字内容
- **结构化整理**: 自动生成标题、段落、要点
- **格式美化**: 包含表格、图示、表情符号、数学公式
- **摘要生成**: 智能生成内容摘要和关键词
- **多语言支持**: 中文、英文等主要语言处理

### 🎴 智能学习工具
- **闪卡系统**: 基于内容自动生成复习卡片，支持间隔重复算法
- **智能测验**: 多种题型（单选、多选、填空、问答）自动生成
- **AI聊天助手**: 每份笔记专属AI助手，支持问答和概念解释
- **播客音频**: 将笔记转换为播客风格音频，支持离线播放

### 🔄 跨平台同步
- **实时同步**: 多设备间数据实时同步
- **离线支持**: 离线编辑，联网后自动同步
- **冲突解决**: 智能版本控制和合并机制
- **云端备份**: 安全的数据备份和恢复

### 📁 组织管理
- **文件夹管理**: 支持多级文件夹分类组织
- **标签系统**: 灵活的多标签分类管理
- **全文搜索**: 强大的搜索功能，支持内容和标签搜索
- **智能排序**: 按时间、名称、重要性等多维度排序

### 🤝 分享协作
- **多种分享方式**: 链接分享、文件导出、二维码分享
- **权限控制**: 只读、编辑、评论等不同权限设置
- **团队协作**: 创建学习小组，支持团队协作
- **评论系统**: 支持笔记评论和讨论功能

## 🛠️ 技术栈

- **前端框架**: Flutter 3.10+
- **编程语言**: Dart 3.0+
- **状态管理**: Riverpod 2.4+
- **本地存储**: Hive数据库
- **云端服务**: Firebase (Firestore, Storage, Auth)
- **AI服务**: OpenAI GPT、百度AI、科大讯飞
- **网络请求**: Dio + Retrofit
- **音视频处理**: FFmpeg集成

## 📱 支持平台

- **iOS**: iPhone/iPad (iOS 12.0+)
- **Android**: 手机/平板 (Android 8.0+)
- **Web**: 现代浏览器 (Chrome 80+, Safari 13+, Firefox 75+)

## 🚀 快速开始

### 环境要求

- Flutter SDK 3.10.0+
- Dart SDK 3.0.0+
- Android Studio / VS Code
- Xcode (iOS开发)

### 安装步骤

1. **进入Flutter项目目录**
   ```bash
   cd ai_notes_flutter
   ```

2. **运行初始化脚本**
   ```bash
   ../setup.sh
   ```

3. **运行应用**
   ```bash
   # 移动端
   flutter run
   
   # Web端
   flutter run -d chrome
   ```

## 📖 项目结构

```
ai_notes_flutter/
├── lib/
│   ├── core/                     # 核心模块
│   │   ├── constants/           # 常量定义
│   │   ├── error/              # 错误处理
│   │   ├── network/            # 网络配置
│   │   ├── storage/            # 存储配置
│   │   ├── utils/              # 工具类
│   │   └── di/                 # 依赖注入
│   ├── features/               # 功能模块
│   │   ├── auth/               # 身份认证
│   │   ├── notes/              # 笔记管理
│   │   ├── upload/             # 文件上传
│   │   ├── ai_generation/      # AI生成
│   │   ├── flashcards/         # 闪卡系统
│   │   ├── quiz/               # 测验系统
│   │   ├── chat/               # AI聊天
│   │   ├── audio/              # 音频功能
│   │   ├── sync/               # 数据同步
│   │   └── sharing/            # 分享功能
│   ├── shared/                 # 共享组件
│   │   ├── widgets/            # UI组件
│   │   ├── models/             # 数据模型
│   │   ├── services/           # 服务类
│   │   ├── theme/              # 主题配置
│   │   ├── routes/             # 路由配置
│   │   └── extensions/         # 扩展方法
│   └── main.dart              # 应用入口
├── docs/                      # 项目文档
├── pubspec.yaml              # 依赖配置
└── README.md                 # 项目说明
```

## 📚 文档

- [需求文档](docs/requirements.md) - 详细的功能需求说明
- [技术架构](docs/technical_architecture.md) - 技术架构设计文档
- [开发指南](docs/development_guide.md) - 开发环境搭建和编码规范

## 🛣️ 开发路线图

### 🎯 Phase 1: 基础功能 (已完成)
- [x] 项目架构搭建
- [x] 基础UI框架
- [x] 项目文档完善

### 🎯 Phase 2: 核心功能 (进行中)
- [ ] 用户认证系统
- [ ] 基础笔记管理
- [ ] 文件上传功能
- [ ] AI笔记生成

### 🎯 Phase 3: 学习工具 (计划中)
- [ ] 闪卡系统开发
- [ ] 智能测验功能
- [ ] AI聊天助手
- [ ] 音频生成服务

### 🎯 Phase 4: 高级功能 (计划中)
- [ ] 跨平台同步优化
- [ ] 分享协作功能
- [ ] 高级搜索功能
- [ ] 数据分析报告

### 🎯 Phase 5: 发布优化 (计划中)
- [ ] 性能优化和测试
- [ ] 应用商店发布
- [ ] 用户反馈收集
- [ ] 持续优化迭代

## 🤝 贡献指南

我们欢迎所有形式的贡献！请查看 [CONTRIBUTING.md](CONTRIBUTING.md) 了解详细信息。

### 如何贡献

1. **Fork 项目**
2. **创建功能分支** (`git checkout -b feature/AmazingFeature`)
3. **提交更改** (`git commit -m 'Add some AmazingFeature'`)
4. **推送到分支** (`git push origin feature/AmazingFeature`)
5. **创建 Pull Request**

### 代码规范

- 遵循 [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- 使用 `flutter analyze` 检查代码质量
- 确保所有测试通过 `flutter test`
- 提交前运行 `flutter format .` 格式化代码

## 📄 许可证

本项目采用 MIT 许可证。详细信息请查看 [LICENSE](LICENSE) 文件。

## 📞 联系我们

- **项目地址**: [GitHub Repository](https://github.com/your-username/ai-notes)
- **问题反馈**: [Issues](https://github.com/your-username/ai-notes/issues)
- **邮箱联系**: your-email@example.com

## 🙏 致谢

感谢以下开源项目和服务：

- [Flutter](https://flutter.dev/) - 跨平台UI框架
- [Firebase](https://firebase.google.com/) - 后端服务
- [OpenAI](https://openai.com/) - AI服务
- [Material Design](https://material.io/) - 设计系统

---

<div align="center">

**⭐ 如果这个项目对你有帮助，请给我们一个Star！⭐**

Made with ❤️ by AI Notes Team

</div>
