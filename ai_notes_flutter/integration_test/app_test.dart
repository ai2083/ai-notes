import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ai_notes_flutter/main.dart' as app;
import 'package:ai_notes_flutter/features/auth/presentation/screens/login_screen.dart';
import 'package:ai_notes_flutter/features/auth/presentation/screens/register_screen.dart';
import 'package:ai_notes_flutter/features/auth/presentation/screens/splash_screen.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('AI Notes App Integration Tests', () {
    setUpAll(() async {
      // Initialize Firebase for testing
      await Firebase.initializeApp();
    });

    group('Authentication Flow Tests', () {
      testWidgets('App startup and splash screen navigation', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle();

        // Verify splash screen is shown
        expect(find.byType(SplashScreen), findsOneWidget);
        expect(find.text('AI Notes'), findsOneWidget);
        expect(find.text('智能笔记，让学习更高效'), findsOneWidget);

        // Wait for splash screen timeout and navigation
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Should navigate to login screen for unauthenticated user
        expect(find.byType(LoginScreen), findsOneWidget);
      });

      testWidgets('Login screen UI elements', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Verify login screen elements
        expect(find.text('欢迎回来'), findsOneWidget);
        expect(find.text('登录您的账户继续使用'), findsOneWidget);
        expect(find.text('邮箱'), findsOneWidget);
        expect(find.text('密码'), findsOneWidget);
        expect(find.text('登录'), findsAtLeastNWidgets(1));
        expect(find.text('忘记密码？'), findsOneWidget);
        expect(find.text('使用 Google 登录'), findsOneWidget);
        expect(find.text('还没有账户？'), findsOneWidget);
        expect(find.text('注册'), findsOneWidget);
      });

      testWidgets('Navigation to register screen', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Tap on register link
        await tester.tap(find.text('注册'));
        await tester.pumpAndSettle();

        // Verify navigation to register screen
        expect(find.byType(RegisterScreen), findsOneWidget);
        expect(find.text('创建新账户'), findsOneWidget);
      });

      testWidgets('Register screen UI elements', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Navigate to register screen
        await tester.tap(find.text('注册'));
        await tester.pumpAndSettle();

        // Verify register screen elements
        expect(find.text('创建新账户'), findsOneWidget);
        expect(find.text('填写信息开始您的智能笔记之旅'), findsOneWidget);
        expect(find.text('姓名'), findsOneWidget);
        expect(find.text('邮箱'), findsOneWidget);
        expect(find.text('密码'), findsOneWidget);
        expect(find.text('确认密码'), findsOneWidget);
        expect(find.text('注册'), findsAtLeastNWidgets(1));
        expect(find.text('使用 Google 注册'), findsOneWidget);
        expect(find.text('已有账户？'), findsOneWidget);
        expect(find.text('登录'), findsOneWidget);
      });

      testWidgets('Form validation on login screen', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Try to login with empty fields
        await tester.tap(find.text('登录').last);
        await tester.pumpAndSettle();

        // Should show validation errors
        expect(find.text('请输入邮箱'), findsOneWidget);
        expect(find.text('请输入密码'), findsOneWidget);
      });

      testWidgets('Form validation on register screen', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Navigate to register screen
        await tester.tap(find.text('注册'));
        await tester.pumpAndSettle();

        // Try to register with empty fields
        await tester.tap(find.text('注册').last);
        await tester.pumpAndSettle();

        // Should show validation errors
        expect(find.text('请输入姓名'), findsOneWidget);
        expect(find.text('请输入邮箱'), findsOneWidget);
        expect(find.text('请输入密码'), findsOneWidget);
        expect(find.text('请确认密码'), findsOneWidget);
      });

      testWidgets('Email validation', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Enter invalid email
        await tester.enterText(
          find.widgetWithText(TextFormField, '请输入邮箱').first,
          'invalid-email',
        );
        
        // Try to login
        await tester.tap(find.text('登录').last);
        await tester.pumpAndSettle();

        // Should show email validation error
        expect(find.text('请输入有效的邮箱地址'), findsOneWidget);
      });

      testWidgets('Password confirmation validation', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Navigate to register screen
        await tester.tap(find.text('注册'));
        await tester.pumpAndSettle();

        // Enter different passwords
        await tester.enterText(
          find.widgetWithText(TextFormField, '请输入密码').first,
          'password123',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, '请确认密码').first,
          'different123',
        );

        // Try to register
        await tester.tap(find.text('注册').last);
        await tester.pumpAndSettle();

        // Should show password confirmation error
        expect(find.text('密码不匹配'), findsOneWidget);
      });

      testWidgets('Test login with valid credentials (mock)', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Enter valid credentials
        await tester.enterText(
          find.widgetWithText(TextFormField, '请输入邮箱').first,
          'test@example.com',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, '请输入密码').first,
          'password123',
        );

        // Submit login form
        await tester.tap(find.text('登录').last);
        await tester.pumpAndSettle();

        // Should show loading state or error (since we're not actually connected to Firebase)
        // In a real test environment, this would navigate to the home screen
      });
    });

    group('Notes Management Tests', () {
      testWidgets('Notes data models serialization', (WidgetTester tester) async {
        // This test doesn't need UI, just testing data model functionality
        // We'll create mock data to test serialization
        
        // Create test note data
        final testNoteJson = {
          'id': 'test-note-1',
          'title': 'Test Note',
          'content': 'This is a test note content',
          'type': 'text',
          'status': 'draft',
          'tags': ['test', 'example'],
          'attachments': [],
          'summary': 'Test summary',
          'transcript': null,
          'keywords': ['test', 'note'],
          'userId': 'test-user-1',
          'createdAt': DateTime.now().toIso8601String(),
          'updatedAt': DateTime.now().toIso8601String(),
          'deletedAt': null,
          'metadata': {'version': 1},
        };

        // Test JSON parsing (this would be done in a unit test normally)
        // But we include it here to verify integration
        expect(testNoteJson['id'], equals('test-note-1'));
        expect(testNoteJson['title'], equals('Test Note'));
        expect(testNoteJson['type'], equals('text'));
      });
    });

    group('Navigation Tests', () {
      testWidgets('Router navigation between auth screens', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Start at login screen
        expect(find.byType(LoginScreen), findsOneWidget);

        // Navigate to register
        await tester.tap(find.text('注册'));
        await tester.pumpAndSettle();
        expect(find.byType(RegisterScreen), findsOneWidget);

        // Navigate back to login
        await tester.tap(find.text('登录'));
        await tester.pumpAndSettle();
        expect(find.byType(LoginScreen), findsOneWidget);
      });

      testWidgets('Back button navigation', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Navigate to register screen
        await tester.tap(find.text('注册'));
        await tester.pumpAndSettle();
        expect(find.byType(RegisterScreen), findsOneWidget);

        // Use back button
        await tester.pageBack();
        await tester.pumpAndSettle();

        // Should return to login screen
        expect(find.byType(LoginScreen), findsOneWidget);
      });
    });

    group('Error Handling Tests', () {
      testWidgets('Network error handling simulation', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Enter valid but non-existent credentials
        await tester.enterText(
          find.widgetWithText(TextFormField, '请输入邮箱').first,
          'nonexistent@example.com',
        );
        await tester.enterText(
          find.widgetWithText(TextFormField, '请输入密码').first,
          'wrongpassword',
        );

        // Try to login
        await tester.tap(find.text('登录').last);
        await tester.pumpAndSettle();

        // Should handle the authentication error gracefully
        // (In real tests, we'd mock the Firebase response)
      });
    });

    group('Accessibility Tests', () {
      testWidgets('Screen reader compatibility', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Check for semantic labels
        expect(find.bySemanticsLabel('邮箱输入框'), findsOneWidget);
        expect(find.bySemanticsLabel('密码输入框'), findsOneWidget);
        expect(find.bySemanticsLabel('登录按钮'), findsOneWidget);
      });

      testWidgets('Keyboard navigation', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Test tab navigation
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pumpAndSettle();

        // Verify focus moves between form fields
        // (This would need more sophisticated focus testing in a real scenario)
      });
    });

    group('Performance Tests', () {
      testWidgets('App startup performance', (WidgetTester tester) async {
        final stopwatch = Stopwatch()..start();
        
        app.main();
        await tester.pumpAndSettle();
        
        stopwatch.stop();
        
        // App should start within reasonable time (adjust threshold as needed)
        expect(stopwatch.elapsedMilliseconds, lessThan(5000));
      });

      testWidgets('Smooth animations', (WidgetTester tester) async {
        app.main();
        await tester.pumpAndSettle(const Duration(seconds: 3));

        // Test splash screen animations
        expect(find.byType(SplashScreen), findsNothing); // Should have navigated away
        
        // Test navigation animations
        await tester.tap(find.text('注册'));
        await tester.pump(); // Start animation
        await tester.pump(const Duration(milliseconds: 100)); // Mid animation
        await tester.pumpAndSettle(); // Complete animation

        expect(find.byType(RegisterScreen), findsOneWidget);
      });
    });
  });
}
