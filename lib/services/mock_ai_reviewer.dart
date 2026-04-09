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
      improvedCode: _improvedCode(language),
      score: score,
      timeComplexity: timeComplexity,
      spaceComplexity: spaceComplexity,
      complexityExplanation: complexityExplanation,
    );
  }

  static String _improvedCode(String language) {
    switch (language) {
      case 'Python':
        return '''def calculate_average(numbers: list[int]) -> float | None:
    """Return the average of a list of numbers."""
    if numbers is None:
        raise ValueError("numbers cannot be None")

    if not numbers:
        return None

    return sum(numbers) / len(numbers)
''';

      case 'JavaScript':
        return '''function calculateAverage(numbers) {
  if (!Array.isArray(numbers)) {
    throw new Error("numbers must be an array");
  }

  if (numbers.length === 0) {
    return null;
  }

  const total = numbers.reduce((sum, number) => sum + number, 0);
  return total / numbers.length;
}
''';

      case 'TypeScript':
        return '''function calculateAverage(numbers: number[]): number | null {
  if (!Array.isArray(numbers)) {
    throw new Error("numbers must be an array");
  }

  if (numbers.length === 0) {
    return null;
  }

  const total = numbers.reduce((sum, number) => sum + number, 0);
  return total / numbers.length;
}
''';

      case 'C':
        return '''#include <stdio.h>

double calculateAverage(int arr[], int size) {
    if (size == 0) {
        return 0.0;
    }

    int sum = 0;
    for (int i = 0; i < size; i++) {
        sum += arr[i];
    }

    return (double)sum / size;
}
''';

      case 'C++':
        return '''#include <vector>
#include <stdexcept>

double calculateAverage(const std::vector<int>& numbers) {
    if (numbers.empty()) {
        return 0.0;
    }

    double sum = 0;
    for (int number : numbers) {
        sum += number;
    }

    return sum / numbers.size();
}
''';

      case 'C#':
        return '''using System;
using System.Collections.Generic;
using System.Linq;

public class Calculator
{
    public double? CalculateAverage(List<int> numbers)
    {
        if (numbers == null)
            throw new ArgumentNullException(nameof(numbers));

        if (numbers.Count == 0)
            return null;

        return numbers.Average();
    }
}
''';

      case 'Dart':
        return '''double? calculateAverage(List<int>? numbers) {
  if (numbers == null) {
    throw ArgumentError('numbers cannot be null');
  }

  if (numbers.isEmpty) {
    return null;
  }

  final sum = numbers.reduce((a, b) => a + b);
  return sum / numbers.length;
}
''';

      case 'Go':
        return '''package main

func calculateAverage(numbers []int) float64 {
    if len(numbers) == 0 {
        return 0
    }

    sum := 0
    for _, number := range numbers {
        sum += number
    }

    return float64(sum) / float64(len(numbers))
}
''';

      case 'PHP':
        return '''<?php
function calculateAverage(array \$numbers): ?float {
    if (count(\$numbers) === 0) {
        return null;
    }

    \$sum = array_sum(\$numbers);
    return \$sum / count(\$numbers);
}
?>
''';

      case 'Kotlin':
        return '''fun calculateAverage(numbers: List<Int>?): Double? {
    require(numbers != null) { "numbers cannot be null" }

    if (numbers.isEmpty()) return null

    return numbers.average()
}
''';

      case 'Swift':
        return '''func calculateAverage(_ numbers: [Int]?) -> Double? {
    guard let numbers = numbers else {
        fatalError("numbers cannot be nil")
    }

    guard !numbers.isEmpty else {
        return nil
    }

    let sum = numbers.reduce(0, +)
    return Double(sum) / Double(numbers.count)
}
''';

      case 'Rust':
        return '''fn calculate_average(numbers: &[i32]) -> Option<f64> {
    if numbers.is_empty() {
        return None;
    }

    let sum: i32 = numbers.iter().sum();
    Some(sum as f64 / numbers.len() as f64)
}
''';

      default:
        return '''import java.util.List;
import java.util.Optional;

/**
 * Calculator utility for basic numeric operations.
 */
public class Calculator {

    /**
     * Calculates the average of a list of numbers.
     *
     * @param numbers list of integers to average
     * @return optional average, or empty if the list is empty
     */
    public Optional<Double> calculateAverage(List<Integer> numbers) {
        if (numbers == null) {
            throw new IllegalArgumentException("Numbers list cannot be null");
        }

        if (numbers.isEmpty()) {
            return Optional.empty();
        }

        double sum = 0;
        for (Integer number : numbers) {
            sum += number;
        }

        return Optional.of(sum / numbers.size());
    }
}
''';
    }
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