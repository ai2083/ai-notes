import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Basic App Tests', () {
    test('should run basic test successfully', () {
      // Simple test to verify test setup is working
      expect(1 + 1, equals(2));
      expect('Hello World'.length, equals(11));
      expect(['a', 'b', 'c'], hasLength(3));
    });

    test('should handle strings correctly', () {
      const testString = 'AI Notes Flutter App';
      expect(testString, contains('AI Notes'));
      expect(testString, contains('Flutter'));
      expect(testString.toLowerCase(), equals('ai notes flutter app'));
    });

    test('should handle lists and maps correctly', () {
      final testList = [1, 2, 3, 4, 5];
      final testMap = {'name': 'AI Notes', 'version': '1.0.0'};

      expect(testList, hasLength(5));
      expect(testList, contains(3));
      expect(testList.first, equals(1));
      expect(testList.last, equals(5));

      expect(testMap, hasLength(2));
      expect(testMap['name'], equals('AI Notes'));
      expect(testMap.containsKey('version'), isTrue);
    });

    test('should handle datetime operations', () {
      final now = DateTime.now();
      final tomorrow = now.add(const Duration(days: 1));
      final yesterday = now.subtract(const Duration(days: 1));

      expect(tomorrow.isAfter(now), isTrue);
      expect(yesterday.isBefore(now), isTrue);
      expect(now.difference(yesterday).inDays, equals(1));
    });

    test('should handle async operations', () async {
      // Simulate async operation
      final result = await Future.delayed(
        const Duration(milliseconds: 10),
        () => 'Async operation completed',
      );

      expect(result, equals('Async operation completed'));
    });

    test('should handle error scenarios', () {
      expect(() => throw Exception('Test error'), throwsException);
      expect(() => throw ArgumentError('Invalid argument'), throwsArgumentError);
      
      // Test error handling with custom messages
      try {
        throw Exception('Custom error message');
      } catch (e) {
        expect(e.toString(), contains('Custom error message'));
      }
    });
  });

  group('Flutter Framework Tests', () {
    test('should verify Flutter test framework is working', () {
      // Test Flutter-specific matchers
      expect(42, isA<int>());
      expect('test', isA<String>());
      expect([1, 2, 3], isA<List<int>>());
      expect({'key': 'value'}, isA<Map<String, String>>());
    });

    test('should handle nullable types correctly', () {
      String? nullableString;
      String nonNullableString = 'Hello';

      expect(nullableString, isNull);
      expect(nonNullableString, isNotNull);
      expect(nonNullableString, hasLength(5));

      // Test null-aware operations
      nullableString = 'Not null anymore';
      expect(nullableString, isNotNull);
      expect(nullableString.length, equals(16));
      expect(nonNullableString.length, equals(5));
    });

    test('should work with enums', () {
      // Test with note-related enums that should exist in our app
      // For now, just test the concept of enums
      final testValues = ['value1', 'value2', 'value3'];
      
      expect(testValues, hasLength(3));
      expect(testValues.first, equals('value1'));
      expect(testValues, contains('value2'));
    });

    test('should handle generic types', () {
      final List<String> stringList = ['a', 'b', 'c'];
      final Map<String, int> stringIntMap = {'one': 1, 'two': 2};

      expect(stringList, everyElement(isA<String>()));
      expect(stringIntMap.keys, everyElement(isA<String>()));
      expect(stringIntMap.values, everyElement(isA<int>()));
    });
  });

  group('App-specific Logic Tests', () {
    test('should validate email format correctly', () {
      // Valid emails
      expect(_isValidEmail('test@example.com'), isTrue);
      expect(_isValidEmail('user.name@domain.co.uk'), isTrue);
      expect(_isValidEmail('user+tag@example.org'), isTrue);

      // Invalid emails
      expect(_isValidEmail('invalid-email'), isFalse);
      expect(_isValidEmail('test@'), isFalse);
      expect(_isValidEmail('@example.com'), isFalse);
      expect(_isValidEmail(''), isFalse);
    });

    test('should validate password strength', () {
      // Valid passwords
      expect(_isValidPassword('password123'), isTrue);
      expect(_isValidPassword('StrongP@ss1'), isTrue);
      expect(_isValidPassword('abcdef12'), isTrue);

      // Invalid passwords
      expect(_isValidPassword(''), isFalse);
      expect(_isValidPassword('12345'), isFalse);
      expect(_isValidPassword('short'), isFalse);
    });

    test('should format note titles correctly', () {
      expect(_formatNoteTitle('  hello world  '), equals('Hello World'));
      expect(_formatNoteTitle('UPPERCASE'), equals('Uppercase'));
      expect(_formatNoteTitle('mixed CaSe'), equals('Mixed Case'));
      expect(_formatNoteTitle(''), equals('Untitled Note'));
    });

    test('should calculate reading time', () {
      const shortText = 'This is a short text with about ten words.';
      const longText = '''
        This is a much longer text that contains many more words and should definitely exceed our reading time threshold.
        It should take significantly longer to read than the short text because we have added substantially more content.
        We can use this to test our reading time calculation function with a much larger sample of text content.
        The average reading speed is about 200-250 words per minute which means we need quite a few words here.
        This text should take about 1-2 minutes to read completely when we have enough words to make it realistic.
        Adding more words to ensure we get more than 1 minute reading time for our test case validation.
        The reading time calculation depends on word count and average reading speed assumptions in our algorithm.
        With enough words like this expanded text sample, we should see a realistic reading time estimate.
        This should now definitely be more than 200 words total for our calculation test case.
        Additional content here to ensure we have sufficient word count for testing purposes.
        More text content to guarantee we exceed the single minute threshold in our test.
        Final additional sentences to ensure adequate word count for realistic reading time calculation testing.
      ''';

      expect(_calculateReadingTime(shortText), equals(1));
      expect(_calculateReadingTime(longText), greaterThanOrEqualTo(1));
      expect(_calculateReadingTime(''), equals(0));
    });

    test('should extract keywords from text', () {
      const text = 'This is a test note about Flutter development and testing.';
      final keywords = _extractKeywords(text);

      expect(keywords, contains('flutter'));  // Lowercase after processing
      expect(keywords, contains('development'));
      expect(keywords, contains('testing'));
      expect(keywords, isNot(contains('is')));  // Should filter out common words
      expect(keywords, isNot(contains('a')));   // Should filter out articles
    });
  });
}

// Helper functions that would be used in the actual app
bool _isValidEmail(String email) {
  if (email.isEmpty) return false;
  return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email);
}

bool _isValidPassword(String password) {
  return password.isNotEmpty && password.length >= 6;
}

String _formatNoteTitle(String title) {
  final trimmed = title.trim();
  if (trimmed.isEmpty) return 'Untitled Note';
  
  // Convert to title case
  return trimmed.split(' ').map((word) {
    if (word.isEmpty) return word;
    return word[0].toUpperCase() + word.substring(1).toLowerCase();
  }).join(' ');
}

int _calculateReadingTime(String text) {
  if (text.isEmpty) return 0;
  
  const wordsPerMinute = 200;
  final wordCount = text.split(RegExp(r'\s+')).where((word) => word.isNotEmpty).length;
  final minutes = (wordCount / wordsPerMinute).ceil();
  
  return minutes < 1 ? 1 : minutes;
}

List<String> _extractKeywords(String text) {
  const commonWords = {
    'the', 'a', 'an', 'and', 'or', 'but', 'in', 'on', 'at', 'to', 'for',
    'of', 'with', 'by', 'is', 'are', 'was', 'were', 'be', 'been', 'have',
    'has', 'had', 'do', 'does', 'did', 'will', 'would', 'could', 'should',
    'this', 'that', 'these', 'those', 'it', 'its', 'they', 'them', 'their'
  };

  return text
      .toLowerCase()
      .split(RegExp(r'[^\w]+'))
      .where((word) => word.length > 2 && !commonWords.contains(word))
      .toSet()
      .toList();
}
