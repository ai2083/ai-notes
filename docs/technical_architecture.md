# AI笔记APP 技术架构文档

## 1. 整体架构

### 1.1 架构概述
采用分层架构设计，遵循Clean Architecture原则，确保代码的可维护性、可测试性和可扩展性。

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                       │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐           │
│  │   Screens   │ │   Widgets   │ │ Controllers │           │
│  └─────────────┘ └─────────────┘ └─────────────┘           │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                    Business Logic Layer                     │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐           │
│  │  Use Cases  │ │ Repositories│ │   Models    │           │
│  └─────────────┘ └─────────────┘ └─────────────┘           │
└─────────────────────────────────────────────────────────────┘
┌─────────────────────────────────────────────────────────────┐
│                     Data Layer                              │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐           │
│  │ Data Sources│ │ APIs/Services│ │ Local Storage│          │
│  └─────────────┘ └─────────────┘ └─────────────┘           │
└─────────────────────────────────────────────────────────────┘
```

### 1.2 技术栈
- **前端框架：** Flutter 3.10+
- **编程语言：** Dart 3.0+
- **状态管理：** Riverpod 2.4+
- **本地存储：** Hive
- **云端存储：** Firebase Firestore
- **文件存储：** Firebase Storage
- **身份认证：** Firebase Auth
- **网络请求：** Dio + Retrofit
- **依赖注入：** GetIt

## 2. 项目结构

### 2.1 目录结构
```
lib/
├── core/                           # 核心组件
│   ├── constants/                  # 常量定义
│   ├── error/                      # 错误处理
│   ├── network/                    # 网络配置
│   ├── storage/                    # 存储配置
│   ├── utils/                      # 工具类
│   └── di/                         # 依赖注入
├── features/                       # 功能模块
│   ├── auth/                       # 身份认证
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── notes/                      # 笔记管理
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── upload/                     # 文件上传
│   ├── ai_generation/              # AI生成
│   ├── flashcards/                 # 闪卡系统
│   ├── quiz/                       # 测验系统
│   ├── chat/                       # AI聊天
│   ├── audio/                      # 音频功能
│   ├── sync/                       # 数据同步
│   └── sharing/                    # 分享功能
├── shared/                         # 共享组件
│   ├── widgets/                    # UI组件
│   ├── models/                     # 数据模型
│   ├── services/                   # 服务类
│   └── extensions/                 # 扩展方法
└── main.dart                       # 应用入口
```

### 2.2 核心模块详细设计

#### 2.2.1 身份认证模块 (Auth)
```dart
// Domain Layer
abstract class AuthRepository {
  Future<User> signInWithEmail(String email, String password);
  Future<User> signUpWithEmail(String email, String password);
  Future<void> signOut();
  Stream<User?> get authStateChanges;
}

// Use Cases
class SignInUseCase {
  final AuthRepository repository;
  SignInUseCase(this.repository);
  
  Future<Either<Failure, User>> call(String email, String password) async {
    // 业务逻辑实现
  }
}
```

#### 2.2.2 笔记管理模块 (Notes)
```dart
// Models
class Note {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> tags;
  final String folderId;
  final NoteType type;
}

// Repository
abstract class NotesRepository {
  Future<List<Note>> getNotes();
  Future<Note> createNote(CreateNoteRequest request);
  Future<Note> updateNote(String id, UpdateNoteRequest request);
  Future<void> deleteNote(String id);
  Stream<List<Note>> watchNotes();
}
```

#### 2.2.3 AI生成模块 (AI Generation)
```dart
// AI Service Interface
abstract class AIService {
  Future<String> generateNoteFromAudio(String audioPath);
  Future<String> generateNoteFromVideo(String videoPath);
  Future<String> generateNoteFromPDF(String pdfPath);
  Future<String> generateNoteFromURL(String url);
  Future<List<Flashcard>> generateFlashcards(String content);
  Future<List<Question>> generateQuiz(String content);
}

// Implementation
class OpenAIService implements AIService {
  final Dio dio;
  
  @override
  Future<String> generateNoteFromAudio(String audioPath) async {
    // 1. 音频转文字 (Whisper API)
    // 2. 文字结构化 (GPT API)
    // 3. 返回Markdown格式笔记
  }
}
```

## 3. 数据存储设计

### 3.1 本地存储 (Hive)
```dart
// 本地数据模型
@HiveType(typeId: 0)
class LocalNote extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String title;
  
  @HiveField(2)
  String content;
  
  @HiveField(3)
  DateTime createdAt;
  
  @HiveField(4)
  bool isSynced;
}

// 存储服务
class LocalStorageService {
  late Box<LocalNote> notesBox;
  
  Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(LocalNoteAdapter());
    notesBox = await Hive.openBox<LocalNote>('notes');
  }
}
```

### 3.2 云端存储 (Firestore)
```dart
// Firestore文档结构
collection('users') {
  document(userId) {
    'profile': {
      'email': String,
      'displayName': String,
      'createdAt': Timestamp,
      'subscription': String,
    },
    
    collection('notes') {
      document(noteId) {
        'title': String,
        'content': String,
        'tags': List<String>,
        'folderId': String,
        'createdAt': Timestamp,
        'updatedAt': Timestamp,
      }
    },
    
    collection('folders') {
      document(folderId) {
        'name': String,
        'parentId': String?,
        'createdAt': Timestamp,
      }
    }
  }
}
```

## 4. 网络架构

### 4.1 API设计
```dart
// API接口定义
@RestApi(baseUrl: "https://api.ainotes.com/v1/")
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;
  
  @POST("/ai/generate-note")
  Future<GenerateNoteResponse> generateNote(@Body() GenerateNoteRequest request);
  
  @POST("/ai/generate-flashcards")
  Future<FlashcardsResponse> generateFlashcards(@Body() FlashcardsRequest request);
  
  @POST("/ai/chat")
  Future<ChatResponse> chat(@Body() ChatRequest request);
}

// 请求/响应模型
@JsonSerializable()
class GenerateNoteRequest {
  final String fileUrl;
  final String fileType;
  final String language;
  
  GenerateNoteRequest({
    required this.fileUrl,
    required this.fileType,
    required this.language,
  });
}
```

### 4.2 网络拦截器
```dart
class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await AuthService.instance.getToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    print('REQUEST: ${options.method} ${options.path}');
    handler.next(options);
  }
}
```

## 5. 状态管理

### 5.1 Riverpod Providers
```dart
// 认证状态
final authStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// 笔记列表状态
final notesProvider = StateNotifierProvider<NotesNotifier, AsyncValue<List<Note>>>((ref) {
  return NotesNotifier(ref.read(notesRepositoryProvider));
});

class NotesNotifier extends StateNotifier<AsyncValue<List<Note>>> {
  final NotesRepository _repository;
  
  NotesNotifier(this._repository) : super(const AsyncValue.loading()) {
    _loadNotes();
  }
  
  Future<void> _loadNotes() async {
    try {
      final notes = await _repository.getNotes();
      state = AsyncValue.data(notes);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }
}
```

### 5.2 状态持久化
```dart
class StateManager {
  static const String _notesKey = 'cached_notes';
  
  static Future<void> saveNotes(List<Note> notes) async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = notes.map((note) => note.toJson()).toList();
    await prefs.setString(_notesKey, jsonEncode(notesJson));
  }
  
  static Future<List<Note>?> loadNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final notesString = prefs.getString(_notesKey);
    if (notesString != null) {
      final notesList = jsonDecode(notesString) as List;
      return notesList.map((json) => Note.fromJson(json)).toList();
    }
    return null;
  }
}
```

## 6. 文件处理架构

### 6.1 文件上传流程
```dart
class FileUploadService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  
  Future<String> uploadFile(File file, String userId) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
    final ref = _storage.ref().child('uploads/$userId/$fileName');
    
    final uploadTask = ref.putFile(file);
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }
  
  Stream<TaskSnapshot> uploadFileWithProgress(File file, String userId) {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${path.basename(file.path)}';
    final ref = _storage.ref().child('uploads/$userId/$fileName');
    return ref.putFile(file).snapshotEvents;
  }
}
```

### 6.2 文件处理管道
```dart
abstract class FileProcessor {
  bool canProcess(String fileType);
  Future<ProcessResult> process(String filePath);
}

class AudioProcessor implements FileProcessor {
  @override
  bool canProcess(String fileType) => ['mp3', 'wav', 'm4a'].contains(fileType);
  
  @override
  Future<ProcessResult> process(String filePath) async {
    // 1. 音频预处理
    // 2. 调用语音识别API
    // 3. 返回文字内容
  }
}

class VideoProcessor implements FileProcessor {
  @override
  bool canProcess(String fileType) => ['mp4', 'avi', 'mov'].contains(fileType);
  
  @override
  Future<ProcessResult> process(String filePath) async {
    // 1. 提取音频轨道
    // 2. 语音识别
    // 3. 场景分析（可选）
    // 4. 返回处理结果
  }
}
```

## 7. AI集成架构

### 7.1 AI服务抽象
```dart
abstract class AIProvider {
  Future<String> transcribeAudio(String audioUrl);
  Future<String> generateNote(String content, NoteStyle style);
  Future<List<Flashcard>> generateFlashcards(String content, int count);
  Future<String> chatWithContent(String content, String question);
}

class OpenAIProvider implements AIProvider {
  final OpenAI _client;
  
  @override
  Future<String> generateNote(String content, NoteStyle style) async {
    final prompt = _buildNotePrompt(content, style);
    final response = await _client.completions.create(
      model: 'gpt-4',
      prompt: prompt,
      maxTokens: 2000,
    );
    return response.choices.first.text;
  }
}
```

### 7.2 AI服务管理器
```dart
class AIServiceManager {
  final List<AIProvider> _providers;
  int _currentProviderIndex = 0;
  
  Future<T> executeWithFallback<T>(Future<T> Function(AIProvider) operation) async {
    for (int i = 0; i < _providers.length; i++) {
      try {
        final provider = _providers[(_currentProviderIndex + i) % _providers.length];
        return await operation(provider);
      } catch (e) {
        if (i == _providers.length - 1) rethrow;
        // 记录失败，尝试下一个提供商
      }
    }
    throw Exception('All AI providers failed');
  }
}
```

## 8. 性能优化策略

### 8.1 内存管理
```dart
class MemoryManager {
  static const int maxCacheSize = 100;
  final LRUCache<String, Note> _noteCache = LRUCache(maxCacheSize);
  
  void cacheNote(Note note) {
    _noteCache[note.id] = note;
  }
  
  Note? getCachedNote(String id) {
    return _noteCache[id];
  }
  
  void clearCache() {
    _noteCache.clear();
  }
}
```

### 8.2 图片优化
```dart
class ImageOptimizer {
  static Future<File> compressImage(File imageFile) async {
    final result = await FlutterImageCompress.compressAndGetFile(
      imageFile.absolute.path,
      '${imageFile.path}_compressed.jpg',
      quality: 85,
      minHeight: 1920,
      minWidth: 1080,
    );
    return File(result!.path);
  }
}
```

### 8.3 网络优化
```dart
class NetworkOptimizer {
  static Dio createOptimizedDio() {
    final dio = Dio();
    
    // 连接池配置
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    
    // 缓存配置
    dio.interceptors.add(DioCacheInterceptor(options: CacheOptions(
      store: HiveCacheStore(Hive.box('dio_cache')),
      maxStale: const Duration(days: 7),
    )));
    
    return dio;
  }
}
```

## 9. 测试策略

### 9.1 单元测试
```dart
class NotesRepositoryTest {
  late NotesRepository repository;
  late MockApiService mockApiService;
  
  setUp() {
    mockApiService = MockApiService();
    repository = NotesRepositoryImpl(mockApiService);
  }
  
  test('should return notes when API call is successful', () async {
    // Arrange
    final expectedNotes = [Note(id: '1', title: 'Test')];
    when(mockApiService.getNotes()).thenAnswer((_) async => expectedNotes);
    
    // Act
    final result = await repository.getNotes();
    
    // Assert
    expect(result, equals(expectedNotes));
  });
}
```

### 9.2 Widget测试
```dart
class NoteCardTest {
  testWidgets('should display note title and content', (tester) async {
    final note = Note(id: '1', title: 'Test Title', content: 'Test Content');
    
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: NoteCard(note: note),
        ),
      ),
    );
    
    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Test Content'), findsOneWidget);
  });
}
```

### 9.3 集成测试
```dart
class AppIntegrationTest {
  testWidgets('full note creation flow', (tester) async {
    await tester.pumpWidget(MyApp());
    
    // 点击创建笔记按钮
    await tester.tap(find.byKey(Key('create_note_button')));
    await tester.pumpAndSettle();
    
    // 输入标题
    await tester.enterText(find.byKey(Key('title_field')), 'Test Note');
    
    // 保存笔记
    await tester.tap(find.byKey(Key('save_button')));
    await tester.pumpAndSettle();
    
    // 验证笔记已创建
    expect(find.text('Test Note'), findsOneWidget);
  });
}
```

## 10. 部署和发布

### 10.1 构建配置
```yaml
# android/app/build.gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        minSdkVersion 26
        targetSdkVersion 34
        versionCode flutterVersionCode.toInteger()
        versionName flutterVersionName
    }
    
    buildTypes {
        release {
            signingConfig signingConfigs.release
            minifyEnabled true
            proguardFiles getDefaultProguardFile('proguard-android.txt'), 'proguard-rules.pro'
        }
    }
}
```

### 10.2 CI/CD配置
```yaml
# .github/workflows/flutter.yml
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

这个技术架构文档涵盖了AI笔记APP的完整技术实现方案，包括架构设计、数据存储、网络通信、AI集成、性能优化、测试策略等各个方面。接下来我将创建具体的代码实现。
