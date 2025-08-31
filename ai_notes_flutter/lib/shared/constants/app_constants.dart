class AppConstants {
  static const String appName = 'AI Notes';
  static const String appVersion = '1.0.0';
  
  // API相关
  static const String baseUrl = 'https://api.ainotes.com/v1/';
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 60);
  
  // 存储相关
  static const String notesBoxName = 'notes';
  static const String foldersBoxName = 'folders';
  static const String settingsBoxName = 'settings';
  
  // 文件上传限制
  static const int maxFileSize = 500 * 1024 * 1024; // 500MB
  static const List<String> supportedAudioFormats = ['mp3', 'wav', 'm4a', 'aac'];
  static const List<String> supportedVideoFormats = ['mp4', 'avi', 'mov', 'mkv'];
  static const List<String> supportedDocumentFormats = ['pdf', 'doc', 'docx', 'ppt', 'pptx', 'txt'];
  static const List<String> supportedImageFormats = ['jpg', 'jpeg', 'png', 'gif', 'bmp'];
  
  // AI相关
  static const int maxTokensPerRequest = 4000;
  static const int defaultFlashcardCount = 10;
  static const int defaultQuizQuestionCount = 5;
  
  // UI相关
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  
  // 动画时长
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 400);
  static const Duration longAnimationDuration = Duration(milliseconds: 600);
}
