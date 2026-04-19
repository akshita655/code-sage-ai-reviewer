import '../models/review_result.dart';

class MockAiReviewer {
  static ReviewResult review({required String code, required String language}) {
    final lines = code
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .length;

    final hasTryCatch = code.contains('try') || code.contains('catch');
    final hasComment =
        code.contains('//') || code.contains('/*') || code.contains('///');
    final hasNullCheck =
        code.contains('null') || code.contains('?.') || code.contains('??');

    final issues = <String>[];
    final suggestions = <String>[];

    if (!hasComment) {
      issues.add(
        'The code has little or no documentation/comments, which reduces readability.',
      );
      suggestions.add(
        'Add short comments or docstrings for important methods and logic blocks.',
      );
    }

    if (!hasTryCatch) {
      issues.add(
        'No clear exception handling is present, so runtime failures may be harder to manage.',
      );
      suggestions.add(
        'Use targeted exception handling where operations can fail.',
      );
    }

    if (!hasNullCheck) {
      issues.add(
        'Possible null or invalid input cases are not handled explicitly.',
      );
      suggestions.add(
        'Add validation and null checks before processing input values.',
      );
    }

    if (lines < 5) {
      issues.add(
        'The snippet is very short, so intent and structure are not fully clear.',
      );
      suggestions.add(
        'Use more descriptive naming and structure the code into clear methods/classes.',
      );
    } else {
      issues.add(
        'Some naming and structure choices can be improved for maintainability.',
      );
      suggestions.add(
        'Use descriptive method/variable names and keep one responsibility per method.',
      );
    }

    while (issues.length < 4) {
      issues.add(
        'The code can be made more consistent with language-specific best practices.',
      );
    }

    while (suggestions.length < 5) {
      suggestions.add(
        'Improve consistency in formatting, naming, and validation.',
      );
    }

    int score = 88;
    if (!hasComment) score -= 5;
    if (!hasTryCatch) score -= 4;
    if (!hasNullCheck) score -= 4;
    if (lines < 5) score -= 5;
    if (score < 55) score = 55;

    final timeComplexity = _estimateTimeComplexity(code, language);
    final spaceComplexity = _estimateSpaceComplexity(code, language);
    final complexityExplanation = _buildComplexityExplanation(
      timeComplexity: timeComplexity,
      spaceComplexity: spaceComplexity,
    );

    return ReviewResult(
      issues: issues.take(4).toList(),
      suggestions: suggestions.take(5).toList(),
      score: score,
      timeComplexity: timeComplexity,
      spaceComplexity: spaceComplexity,
      complexityExplanation: complexityExplanation,
    );
  }

  static String _estimateTimeComplexity(String code, String language) {
    final lowerCode = code.toLowerCase();

    final loopMatches = RegExp(r'\b(for|while)\b').allMatches(lowerCode).length;
    final hasSort = lowerCode.contains('.sort') ||
        lowerCode.contains('arrays.sort') ||
        lowerCode.contains('collections.sort') ||
        lowerCode.contains('sort(');
    final hasRecursion = _looksRecursive(code, language);

    if (hasSort) return 'O(n log n)';
    if (hasRecursion && loopMatches > 0) return 'O(n²)';
    if (loopMatches >= 2) return 'O(n²)';
    if (loopMatches == 1) return 'O(n)';
    if (hasRecursion) return 'O(n)';
    return 'O(1)';
  }

  static String _estimateSpaceComplexity(String code, String language) {
    final lowerCode = code.toLowerCase();

    final hasDynamicStorage = lowerCode.contains('new ') ||
        lowerCode.contains('malloc(') ||
        lowerCode.contains('calloc(') ||
        lowerCode.contains('vector<') ||
        lowerCode.contains('list<') ||
        lowerCode.contains('map<') ||
        lowerCode.contains('set<') ||
        lowerCode.contains('dict') ||
        lowerCode.contains('[]') ||
        lowerCode.contains('array') ||
        lowerCode.contains('hashmap') ||
        lowerCode.contains('hashset');

    final hasRecursion = _looksRecursive(code, language);

    if (hasDynamicStorage && hasRecursion) return 'O(n)';
    if (hasDynamicStorage) return 'O(n)';
    if (hasRecursion) return 'O(n)';
    return 'O(1)';
  }

  static String _buildComplexityExplanation({
    required String timeComplexity,
    required String spaceComplexity,
  }) {
    return 'The estimated time complexity is $timeComplexity based on the visible control flow in the code. '
        'The estimated space complexity is $spaceComplexity depending on whether extra data structures or recursive call stack space are used.';
  }

  static bool _looksRecursive(String code, String language) {
    final lowerCode = code.toLowerCase();

    switch (language) {
      case 'Python':
        return RegExp(r'def\s+(\w+)\s*\(').firstMatch(code) != null &&
            _callsOwnFunction(code, RegExp(r'def\s+(\w+)\s*\(').firstMatch(code)!.group(1)!);

      case 'Java':
      case 'C#':
      case 'C++':
      case 'C':
      case 'Dart':
      case 'Go':
      case 'PHP':
      case 'Kotlin':
      case 'Swift':
      case 'Rust':
      case 'JavaScript':
      case 'TypeScript':
        final match = RegExp(r'(\w+)\s*\([^)]*\)\s*\{').firstMatch(code);
        if (match == null) return false;
        final functionName = match.group(1);
        if (functionName == null) return false;
        return _callsOwnFunction(code, functionName);

      default:
        return lowerCode.contains('recursion');
    }
  }

  static bool _callsOwnFunction(String code, String functionName) {
    final escaped = RegExp.escape(functionName);
    final matches = RegExp(r'\b' + escaped + r'\s*\(').allMatches(code).length;
    return matches > 1;
  }
}