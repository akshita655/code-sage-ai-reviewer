import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/review_result.dart';

class OpenRouterAiReviewer {
  static const String _reviewUrl = '/.netlify/functions/review';
  static const String _explainUrl = '/.netlify/functions/explain';

  static Future<ReviewResult> review({
    required String code,
    required String language,
  }) async {

    // ✅ NEW: Trim large code to prevent timeout
    final trimmedCode =
    code.length > 4000 ? code.substring(0, 4000) : code;

    final response = await http
        .post(
      Uri.parse(_reviewUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'code': trimmedCode, // ✅ use trimmed code
        'language': language,
      }),
    )
        .timeout(const Duration(seconds: 90)); // ✅ increased timeout

    if (response.statusCode != 200) {
      throw Exception(
        'Backend error: ${response.statusCode} ${response.body}',
      );
    }

    final data = jsonDecode(response.body);
    final content = data['result'];

    print('FULL BACKEND RESPONSE BODY:');
    print(response.body);

    print('RAW REVIEW CONTENT:');
    print(content);

    try {
      final Map<String, dynamic> parsed =
      Map<String, dynamic>.from(jsonDecode(content));

      final issues = List<String>.from(parsed['issues'] ?? []);
      final suggestions = List<String>.from(parsed['suggestions'] ?? []);

      final score = (parsed['score'] is int)
          ? parsed['score']
          : int.tryParse(parsed['score']?.toString() ?? '0') ?? 0;

      while (issues.length < 4) {
        issues.add('No additional issue provided.');
      }

      while (suggestions.length < 5) {
        suggestions.add('No additional suggestion provided.');
      }

      return ReviewResult(
        issues: issues.take(4).toList(),
        suggestions: suggestions.take(5).toList(),
        score: score,
        timeComplexity: (parsed['timeComplexity'] ?? 'N/A').toString(),
        spaceComplexity: (parsed['spaceComplexity'] ?? 'N/A').toString(),
        complexityExplanation:
        (parsed['complexityExplanation'] ?? 'Not available.').toString(),
      );
    } catch (e) {
      throw Exception('Invalid JSON response from backend: $e');
    }
  }

  static Future<String> generateImprovedCode({
    required String code,
    required String language,
  }) async {
    final response = await http
        .post(
      Uri.parse('/.netlify/functions/improve'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'code': code,
        'language': language,
      }),
    )
        .timeout(const Duration(seconds: 60)); // longer timeout

    if (response.statusCode != 200) {
      throw Exception(
        'Backend error: ${response.statusCode} ${response.body}',
      );
    }

    final data = jsonDecode(response.body);
    final content = data['result'];

    if (content == null || content.toString().trim().isEmpty) {
      throw Exception('No improved code returned');
    }

    return content.toString().trim();
  }

  static Future<String> explainCode({
    required String code,
    required String language,
  }) async {

    // ✅ NEW: Trim large code here also
    final trimmedCode =
    code.length > 4000 ? code.substring(0, 4000) : code;

    final response = await http
        .post(
      Uri.parse(_explainUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'code': trimmedCode, // ✅ use trimmed code
        'language': language,
      }),
    )
        .timeout(const Duration(seconds: 90)); // ✅ increased timeout

    if (response.statusCode != 200) {
      throw Exception(
        'Backend error: ${response.statusCode} ${response.body}',
      );
    }

    final data = jsonDecode(response.body);
    final content = data['result'];

    if (content == null || content.toString().trim().isEmpty) {
      throw Exception('No explanation returned by backend');
    }

    return content.toString().trim();
  }
}