# 贡献指南

感谢您对AI Notes项目的关注！我们欢迎所有形式的贡献，无论是代码、文档、设计还是建议。

## 🤝 如何贡献

### 报告Bug

如果您发现了Bug，请创建一个Issue并包含以下信息：

1. **Bug描述**：清晰描述遇到的问题
2. **复现步骤**：详细的复现步骤
3. **预期行为**：说明您期望的正确行为
4. **实际行为**：描述实际发生的情况
5. **环境信息**：
   - 操作系统和版本
   - Flutter版本
   - 设备信息（如果是移动端）
   - 浏览器版本（如果是Web端）
6. **截图或日志**：如果适用，请提供相关截图或错误日志

### 功能建议

我们欢迎新功能的建议！请创建一个Issue并包含：

1. **功能描述**：清晰描述建议的功能
2. **使用场景**：说明这个功能的应用场景
3. **实现方案**：如果有想法，可以描述可能的实现方案
4. **优先级**：说明这个功能对您的重要程度

### 提交代码

#### 开发环境设置

1. **Fork项目**
   ```bash
   # 在GitHub上Fork项目到您的账户
   ```

2. **克隆代码**
   ```bash
   git clone https://github.com/YOUR_USERNAME/ai-notes.git
   cd ai-notes
   ```

3. **设置上游仓库**
   ```bash
   git remote add upstream https://github.com/ORIGINAL_OWNER/ai-notes.git
   ```

4. **安装依赖**
   ```bash
   cd ai_notes_flutter
   flutter pub get
   ```

#### 开发流程

1. **创建功能分支**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **开发代码**
   - 遵循项目的代码规范
   - 编写必要的测试
   - 确保代码质量

3. **运行测试**
   ```bash
   flutter test
   flutter analyze
   ```

4. **提交代码**
   ```bash
   git add .
   git commit -m "feat: add your feature description"
   ```

5. **推送分支**
   ```bash
   git push origin feature/your-feature-name
   ```

6. **创建Pull Request**
   - 在GitHub上创建Pull Request
   - 填写详细的PR描述
   - 关联相关的Issue

## 📝 代码规范

### Dart代码规范

我们遵循[Dart官方代码规范](https://dart.dev/guides/language/effective-dart)：

#### 命名规范

```dart
// 类名使用PascalCase
class UserProfileScreen extends StatelessWidget {}

// 文件名使用snake_case
// user_profile_screen.dart

// 变量和方法名使用camelCase
String userName = 'John';
void updateUserProfile() {}

// 常量使用lowerCamelCase
const int maxRetryCount = 3;

// 私有成员以下划线开头
String _privateField;
void _privateMethod() {}
```

#### 文件组织

```dart
// 导入顺序：
// 1. Dart核心库
import 'dart:async';
import 'dart:math';

// 2. Flutter框架
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// 3. 第三方包
import 'package:riverpod/riverpod.dart';
import 'package:dio/dio.dart';

// 4. 项目内部文件
import '../models/user.dart';
import '../services/api_service.dart';
```

#### 代码格式化

```bash
# 格式化所有代码
flutter format .

# 检查代码质量
flutter analyze

# 运行测试
flutter test
```

### 项目结构规范

```
feature_name/
├── data/
│   ├── datasources/          # 数据源（API、本地存储）
│   ├── models/              # 数据模型
│   └── repositories/        # 仓库实现
├── domain/
│   ├── entities/            # 业务实体
│   ├── repositories/        # 仓库接口
│   └── usecases/           # 用例
└── presentation/
    ├── providers/          # 状态管理
    ├── screens/            # 页面
    └── widgets/            # UI组件
```

### Git提交规范

我们使用[Conventional Commits](https://www.conventionalcommits.org/)规范：

```
<type>[optional scope]: <description>

[optional body]

[optional footer(s)]
```

#### 提交类型

- `feat`: 新功能
- `fix`: Bug修复
- `docs`: 文档更新
- `style`: 代码格式调整（不影响功能）
- `refactor`: 代码重构
- `test`: 测试相关
- `chore`: 构建过程或辅助工具的变动

#### 示例

```bash
feat(auth): add user registration functionality

Add user registration form with email validation
and password strength checking.

Closes #123
```

## 🧪 测试指南

### 单元测试

```dart
// test/features/auth/domain/usecases/sign_in_usecase_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  group('SignInUseCase', () {
    late SignInUseCase useCase;
    late MockAuthRepository mockRepository;

    setUp(() {
      mockRepository = MockAuthRepository();
      useCase = SignInUseCase(mockRepository);
    });

    test('should return user when credentials are valid', () async {
      // arrange
      final email = 'test@example.com';
      final password = 'password123';
      final expectedUser = User(id: '1', email: email);
      
      when(mockRepository.signIn(email, password))
          .thenAnswer((_) async => Right(expectedUser));

      // act
      final result = await useCase(SignInParams(email, password));

      // assert
      expect(result, Right(expectedUser));
      verify(mockRepository.signIn(email, password));
    });
  });
}
```

### Widget测试

```dart
// test/features/auth/presentation/screens/login_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('LoginScreen should display login form', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(),
      ),
    );

    expect(find.byType(TextField), findsNWidgets(2)); // Email and password
    expect(find.byType(ElevatedButton), findsOneWidget); // Login button
    expect(find.text('登录'), findsOneWidget);
  });
}
```

### 集成测试

```dart
// integration_test/app_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:ai_notes/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('complete user flow', (tester) async {
      app.main();
      await tester.pumpAndSettle();

      // 测试登录流程
      await tester.tap(find.byKey(Key('login_button')));
      await tester.pumpAndSettle();

      // 测试创建笔记
      await tester.tap(find.byKey(Key('create_note_fab')));
      await tester.pumpAndSettle();

      // 验证结果
      expect(find.text('新建笔记'), findsOneWidget);
    });
  });
}
```

## 📋 Pull Request检查清单

在提交PR之前，请确保：

- [ ] 代码遵循项目的代码规范
- [ ] 所有测试都通过
- [ ] 新功能包含相应的测试
- [ ] 文档已更新（如果需要）
- [ ] 提交消息遵循约定格式
- [ ] PR描述清晰，包含必要的信息
- [ ] 关联了相关的Issue

## 🎯 优先级指南

我们按以下优先级处理贡献：

### 高优先级
- 安全漏洞修复
- 严重Bug修复
- 核心功能实现

### 中优先级
- 新功能开发
- 性能优化
- 用户体验改进

### 低优先级
- 代码重构
- 文档完善
- 小的功能增强

## 🏆 贡献者认可

我们重视每一个贡献者的努力：

- 所有贡献者将在项目README中被提及
- 重要贡献者可以获得项目维护者权限
- 优秀的贡献将在项目社区中被特别表彰

## 📞 获得帮助

如果您在贡献过程中遇到问题：

1. **查看文档**：首先查看项目文档和开发指南
2. **搜索Issue**：查看是否有类似的问题已经被讨论
3. **创建Issue**：如果找不到答案，创建一个新的Issue
4. **联系维护者**：通过邮件或其他方式联系项目维护者

## 🙏 感谢

感谢您对AI Notes项目的关注和贡献！每一个贡献都让项目变得更好。

---

Happy coding! 🚀
