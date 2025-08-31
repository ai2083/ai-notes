import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/notes/presentation/screens/notes_list_screen.dart';
import '../../features/notes/presentation/screens/note_detail_screen.dart';
import '../../features/notes/presentation/screens/create_note_screen.dart';
import '../../features/upload/presentation/screens/upload_screen.dart';
import '../../features/flashcards/presentation/screens/flashcards_screen.dart';
import '../../features/quiz/presentation/screens/quiz_screen.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';

enum AppRoute {
  splash,
  login,
  register,
  home,
  notes,
  noteDetail,
  createNote,
  upload,
  flashcards,
  quiz,
  chat,
  profile,
}

extension AppRouteExtension on AppRoute {
  String get path {
    switch (this) {
      case AppRoute.splash:
        return '/';
      case AppRoute.login:
        return '/login';
      case AppRoute.register:
        return '/register';
      case AppRoute.home:
        return '/home';
      case AppRoute.notes:
        return '/notes';
      case AppRoute.noteDetail:
        return '/notes/:id';
      case AppRoute.createNote:
        return '/notes/create';
      case AppRoute.upload:
        return '/upload';
      case AppRoute.flashcards:
        return '/flashcards';
      case AppRoute.quiz:
        return '/quiz';
      case AppRoute.chat:
        return '/chat';
      case AppRoute.profile:
        return '/profile';
    }
  }

  String get name {
    switch (this) {
      case AppRoute.splash:
        return 'splash';
      case AppRoute.login:
        return 'login';
      case AppRoute.register:
        return 'register';
      case AppRoute.home:
        return 'home';
      case AppRoute.notes:
        return 'notes';
      case AppRoute.noteDetail:
        return 'noteDetail';
      case AppRoute.createNote:
        return 'createNote';
      case AppRoute.upload:
        return 'upload';
      case AppRoute.flashcards:
        return 'flashcards';
      case AppRoute.quiz:
        return 'quiz';
      case AppRoute.chat:
        return 'chat';
      case AppRoute.profile:
        return 'profile';
    }
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoute.splash.path,
    routes: [
      // 启动页
      GoRoute(
        path: AppRoute.splash.path,
        name: AppRoute.splash.name,
        builder: (context, state) => const SplashScreen(),
      ),
      
      // 认证相关
      GoRoute(
        path: AppRoute.login.path,
        name: AppRoute.login.name,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoute.register.path,
        name: AppRoute.register.name,
        builder: (context, state) => const RegisterScreen(),
      ),
      
      // 主要应用界面
      ShellRoute(
        builder: (context, state, child) {
          return MainNavigationScreen(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoute.home.path,
            name: AppRoute.home.name,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoute.notes.path,
            name: AppRoute.notes.name,
            builder: (context, state) => const NotesListScreen(),
          ),
          GoRoute(
            path: AppRoute.upload.path,
            name: AppRoute.upload.name,
            builder: (context, state) => const UploadScreen(),
          ),
          GoRoute(
            path: AppRoute.flashcards.path,
            name: AppRoute.flashcards.name,
            builder: (context, state) => const FlashcardsScreen(),
          ),
          GoRoute(
            path: AppRoute.quiz.path,
            name: AppRoute.quiz.name,
            builder: (context, state) => const QuizScreen(),
          ),
          GoRoute(
            path: AppRoute.chat.path,
            name: AppRoute.chat.name,
            builder: (context, state) => const ChatScreen(),
          ),
          GoRoute(
            path: AppRoute.profile.path,
            name: AppRoute.profile.name,
            builder: (context, state) => const ProfileScreen(),
          ),
        ],
      ),
      
      // 详情页面
      GoRoute(
        path: AppRoute.noteDetail.path,
        name: AppRoute.noteDetail.name,
        builder: (context, state) {
          final noteId = state.pathParameters['id']!;
          return NoteDetailScreen(noteId: noteId);
        },
      ),
      GoRoute(
        path: AppRoute.createNote.path,
        name: AppRoute.createNote.name,
        builder: (context, state) => const CreateNoteScreen(),
      ),
    ],
    redirect: (context, state) {
      // 这里可以添加认证状态检查逻辑
      // 例如：如果用户未登录且访问需要认证的页面，重定向到登录页
      return null;
    },
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              '页面未找到',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 8),
            Text(
              state.error.toString(),
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go(AppRoute.home.path),
              child: const Text('返回首页'),
            ),
          ],
        ),
      ),
    ),
  );
});

// 主导航框架
class MainNavigationScreen extends StatefulWidget {
  final Widget child;

  const MainNavigationScreen({
    super.key,
    required this.child,
  });

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  static const List<NavigationDestination> _destinations = [
    NavigationDestination(
      icon: Icon(Icons.home_outlined),
      selectedIcon: Icon(Icons.home),
      label: '首页',
    ),
    NavigationDestination(
      icon: Icon(Icons.note_outlined),
      selectedIcon: Icon(Icons.note),
      label: '笔记',
    ),
    NavigationDestination(
      icon: Icon(Icons.upload_outlined),
      selectedIcon: Icon(Icons.upload),
      label: '上传',
    ),
    NavigationDestination(
      icon: Icon(Icons.quiz_outlined),
      selectedIcon: Icon(Icons.quiz),
      label: '学习',
    ),
    NavigationDestination(
      icon: Icon(Icons.person_outline),
      selectedIcon: Icon(Icons.person),
      label: '我的',
    ),
  ];

  void _onDestinationSelected(int index) {
    setState(() {
      _currentIndex = index;
    });

    switch (index) {
      case 0:
        context.go(AppRoute.home.path);
        break;
      case 1:
        context.go(AppRoute.notes.path);
        break;
      case 2:
        context.go(AppRoute.upload.path);
        break;
      case 3:
        context.go(AppRoute.flashcards.path);
        break;
      case 4:
        context.go(AppRoute.profile.path);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: _destinations,
      ),
    );
  }
}
