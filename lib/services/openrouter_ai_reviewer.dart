import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/review_result.dart';

class OpenRouterAiReviewer {
  static const String _url =
      'https://openrouter.ai/api/v1/chat/completions';

  static Future<ReviewResult> review({
    required String code,
    required String language,
  }) async {
    final apiKey = dotenv.env['OPENROUTER_API_KEY'];
    final model =
        dotenv.env['OPENROUTER_MODEL'] ?? 'deepseek/deepseek-r1-0528:free';

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('OpenRouter API key not found in .env file');
    }

    final response = await http
        .post(
      Uri.parse(_url),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
        'HTTP-Referer': 'https://yourapp.example',
        'X-Title': 'AI Code Reviewer',
      },
      body: jsonEncode({
        'model': model,
        'messages': [
          {
            'role': 'system',
            'content':
            'You are an expert senior software engineer and code reviewer. Return only valid JSON.',
          },
          {
            'role': 'user',
            'content': '''
You are reviewing code written in: $language.

Analyze the code according to $language best practices.

Return ONLY valid JSON in this format:
{
  "issues": ["issue 1", "issue 2", "issue 3", "issue 4"],
  "suggestions": ["suggestion 1", "suggestion 2", "suggestion 3", "suggestion 4", "suggestion 5"],
  "improvedCode": "full improved code here",
  "score": 85,
  "timeComplexity": "O(n)",
  "spaceComplexity": "O(n)",
  "complexityExplanation": "Short explanation"
}

Rules:
- Return raw JSON only.
- No markdown.
- No backticks.
- No explanation outside JSON.
- improvedCode must contain actual rewritten code, not a description.
- improvedCode must remain in $language.
- Do not convert the code into another language.
- If the input language is C, improvedCode must use valid C syntax.
- Keep the code readable.
- Keep issues and suggestions practical and short.
- score must be an integer from 0 to 100.
- timeComplexity and spaceComplexity should be Big-O if possible.

Code:
$code
''',
          }
        ],
        'temperature': 0.2,
      }),
    )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode != 200) {
      throw Exception(
        'OpenRouter error: ${response.statusCode} ${response.body}',
      );
    }

    final data = jsonDecode(response.body);
    final content = data['choices'][0]['message']['content'];

    print('FULL RESPONSE BODY:');
    print(response.body);

    print('RAW REVIEW CONTENT:');
    print(content);

    try {
      final Map<String, dynamic> parsed =
      Map<String, dynamic>.from(jsonDecode(content));

      final issues = List<String>.from(parsed['issues'] ?? []);
      final suggestions = List<String>.from(parsed['suggestions'] ?? []);
      final improvedCode = (parsed['improvedCode'] ?? '').toString().trim();

      final score =
      (parsed['score'] is int)
          ? parsed['score']
          : int.tryParse(parsed['score']?.toString() ?? '0') ?? 0;

      while (issues.length < 4) {
        issues.add('No additional issue provided.');
      }

      while (suggestions.length < 5) {
        suggestions.add('No additional suggestion provided.');
      }

      if (improvedCode.isEmpty) {
        throw Exception('AI did not return improved code.');
      }

      final lower = improvedCode.toLowerCase();
      if (lower.startsWith('the original') ||
          lower.startsWith('this code') ||
          lower.startsWith('here is')) {
        throw Exception('AI returned description instead of code.');
      }

      return ReviewResult(
        issues: issues.take(4).toList(),
        suggestions: suggestions.take(5).toList(),
        improvedCode: improvedCode,
        score: score,
        timeComplexity: (parsed['timeComplexity'] ?? 'N/A').toString(),
        spaceComplexity: (parsed['spaceComplexity'] ?? 'N/A').toString(),
        complexityExplanation:
        (parsed['complexityExplanation'] ?? 'Not available.').toString(),
      );
    } catch (e) {
      throw Exception('Invalid JSON response from OpenRouter: $e');
    }
  }

  static Future<String> explainCode({
    required String code,
    required String language,
  }) async {
    final apiKey = dotenv.env['OPENROUTER_API_KEY'];
    final model =
        dotenv.env['OPENROUTER_MODEL'] ?? 'deepseek/deepseek-r1-0528:free';

    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('OpenRouter API key not found in .env file');
    }

    final response = await http
        .post(
      Uri.parse(_url),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
        'HTTP-Referer': 'https://yourapp.example',
        'X-Title': 'AI Code Reviewer',
      },
      body: jsonEncode({
        'model': model,
        'messages': [
          {
            'role': 'system',
            'content':
            'You are a helpful programming teacher. Explain code clearly and simply.',
          },
          {
            'role': 'user',
            'content': '''
The following code is written in $language.

Explain this code in simple language for a student developer.

Rules:
- Keep the explanation easy to understand.
- Explain what the code does.
- Mention the main logic.
- Mention important functions, loops, or conditions.
- Keep it concise but useful.
- Return plain text only.

Code:
$code
''',
          }
        ],
        'temperature': 0.4,
      }),
    )
        .timeout(const Duration(seconds: 30));

    if (response.statusCode != 200) {
      throw Exception(
        'OpenRouter error: ${response.statusCode} ${response.body}',
      );
    }

    final data = jsonDecode(response.body);
    final content = data['choices'][0]['message']['content'];

    if (content == null || content.toString().trim().isEmpty) {
      throw Exception('No explanation returned by OpenRouter');
    }

    return content.toString().trim();
  }
}