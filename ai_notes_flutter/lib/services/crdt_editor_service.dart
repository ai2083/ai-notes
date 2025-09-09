import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:dio/dio.dart';

class CRDTEditorService {
  static const String _editorAssetPath = 'assets/web/crdt_note_editor.html';
  
  InAppWebViewController? _controller;
  String? _currentDocId;
  Function(String title, String content)? onContentChanged;
  Function(String docId)? onDocIdGenerated;
  
  // Initialize the WebView controller
  void setController(InAppWebViewController controller) {
    _controller = controller;
    _setupEventHandlers();
  }
  
  // Setup event handlers for Flutter-WebView communication
  void _setupEventHandlers() {
    _controller?.addJavaScriptHandler(
      handlerName: 'editorEvent',
      callback: (args) {
        if (args.isEmpty) return;
        
        final eventData = args.first as Map<String, dynamic>;
        final event = eventData['event'] as String;
        final data = eventData['data'] as Map<String, dynamic>;
        
        switch (event) {
          case 'docId':
            _currentDocId = data['docId'] as String;
            onDocIdGenerated?.call(_currentDocId!);
            break;
            
          case 'contentChanged':
            final title = data['title'] as String? ?? '';
            final content = data['content'] as String? ?? '';
            onContentChanged?.call(title, content);
            break;
        }
      },
    );
  }
  
  // Open a specific document by ID
  Future<void> openDocument(String docId) async {
    if (_controller == null) return;
    
    _currentDocId = docId;
    await _controller!.evaluateJavascript(
      source: "window.editorAPI?.openDocument('$docId');",
    );
  }
  
  // Get current document content
  Future<Map<String, String>?> getContent() async {
    if (_controller == null) return null;
    
    final result = await _controller!.evaluateJavascript(
      source: "window.editorAPI?.getContent();",
    );
    
    if (result != null && result is Map) {
      return {
        'title': result['title']?.toString() ?? '',
        'content': result['content']?.toString() ?? '',
        'docId': result['docId']?.toString() ?? '',
      };
    }
    
    return null;
  }
  
  // Set document content
  Future<void> setContent({String? title, String? content}) async {
    if (_controller == null) return;
    
    final titleJson = title != null ? "'$title'" : 'undefined';
    final contentJson = content != null ? "'$content'" : 'undefined';
    
    await _controller!.evaluateJavascript(
      source: "window.editorAPI?.setContent($titleJson, $contentJson);",
    );
  }
  
  // Create InAppWebView widget
  InAppWebView createWebView({
    Function(String title, String content)? onContentChanged,
    Function(String docId)? onDocIdGenerated,
    String? docId,
  }) {
    this.onContentChanged = onContentChanged;
    this.onDocIdGenerated = onDocIdGenerated;
    
    // Build the URL with docId parameter if provided
    final url = docId != null 
        ? 'http://localhost:8800/crdt_note_editor.html?docId=$docId'
        : 'http://localhost:8800/crdt_note_editor.html';
    
    return InAppWebView(
      initialUrlRequest: URLRequest(url: WebUri(url)),
      initialSettings: InAppWebViewSettings(
        useShouldOverrideUrlLoading: false,
        mediaPlaybackRequiresUserGesture: false,
        allowsInlineMediaPlayback: true,
        iframeAllow: "camera; microphone",
        iframeAllowFullscreen: true,
        javaScriptEnabled: true,
        domStorageEnabled: true,
        databaseEnabled: true,
        clearCache: false,
        cacheEnabled: true,
        // Allow local file access for offline mode
        allowFileAccessFromFileURLs: true,
        allowUniversalAccessFromFileURLs: true,
      ),
      onWebViewCreated: (controller) {
        setController(controller);
      },
      onLoadStop: (controller, url) async {
        // Inject additional JavaScript if needed
        await controller.evaluateJavascript(source: """
          console.log('CRDT Editor loaded in Flutter WebView');
        """);
      },
      onConsoleMessage: (controller, consoleMessage) {
        // Log console messages for debugging
        print('[WebView Console] ${consoleMessage.message}');
      },
      onPermissionRequest: (controller, request) async {
        // Grant permissions for WebRTC, localStorage, etc.
        return PermissionResponse(
          resources: request.resources,
          action: PermissionResponseAction.GRANT,
        );
      },
    );
  }
  
  // Create fallback WebView for offline mode using local assets
  InAppWebView createOfflineWebView({
    Function(String title, String content)? onContentChanged,
    Function(String docId)? onDocIdGenerated,
    String? initialTitle,
    String? initialContent,
  }) {
    this.onContentChanged = onContentChanged;
    this.onDocIdGenerated = onDocIdGenerated;
    
    return InAppWebView(
      initialFile: _editorAssetPath,
      initialSettings: InAppWebViewSettings(
        javaScriptEnabled: true,
        domStorageEnabled: true,
        databaseEnabled: true,
        allowFileAccessFromFileURLs: true,
        allowUniversalAccessFromFileURLs: true,
      ),
      onWebViewCreated: (controller) {
        setController(controller);
      },
      onLoadStop: (controller, url) async {
        // Set initial content if provided
        if (initialTitle != null || initialContent != null) {
          await setContent(title: initialTitle, content: initialContent);
        }
      },
      onConsoleMessage: (controller, consoleMessage) {
        print('[WebView Console] ${consoleMessage.message}');
      },
    );
  }
  
  // Check if CRDT server is available
  static Future<bool> isServerAvailable() async {
    try {
      final dio = Dio();
      final response = await dio.get(
        'http://localhost:8800/crdt_note_editor.html',
        options: Options(
          headers: {'User-Agent': 'Flutter-App-Health-Check'},
          receiveTimeout: Duration(seconds: 3),
          sendTimeout: Duration(seconds: 3),
        ),
      );
      
      return response.statusCode == 200;
    } catch (e) {
      print('Server availability check failed: $e');
      return false;
    }
  }
  
  // Dispose resources
  void dispose() {
    _controller = null;
    onContentChanged = null;
    onDocIdGenerated = null;
  }
}
