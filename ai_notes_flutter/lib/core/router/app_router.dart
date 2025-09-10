import 'package:flutter/material.dart';

import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../pages/create_new_note_page.dart';

class AppRouter {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String notes = '/notes';
  static const String noteDetail = '/note-detail';
  static const String createNote = '/create-note';
  static const String editNote = '/edit-note';
  static const String search = '/search';
  static const String settings = '/settings';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(
          builder: (_) => const SplashScreen(),
          settings: settings,
        );
      case login:
        return MaterialPageRoute(
          builder: (_) => const LoginScreen(),
          settings: settings,
        );
      case register:
        return MaterialPageRoute(
          builder: (_) => const RegisterScreen(),
          settings: settings,
        );
      case home:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(
              child: Text('主页功能待实现'),
            ),
          ),
          settings: settings,
        );
      case createNote:
        final args = settings.arguments as Map<String, dynamic>?;
        final targetFolder = args?['targetFolder'] as String?;
        return MaterialPageRoute(
          builder: (context) => CreateNewNotePage(
            targetFolder: targetFolder,
          ),
          settings: settings,
        );
      case editNote:
        final args = settings.arguments as Map<String, dynamic>?;
        final noteId = args?['noteId'] as String?;
        final targetFolder = args?['targetFolder'] as String?;
        
        if (noteId == null) {
          return MaterialPageRoute(
            builder: (context) => const Scaffold(
              body: Center(child: Text('Note ID required')),
            ),
          );
        }
        
        return MaterialPageRoute(
          builder: (context) => CreateNewNotePage(
            targetFolder: targetFolder,
            existingNoteId: noteId,
          ),
          settings: settings,
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('页面 ${settings.name} 未找到'),
            ),
          ),
          settings: settings,
        );
    }
  }
}
