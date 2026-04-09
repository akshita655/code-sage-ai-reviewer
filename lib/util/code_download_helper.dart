import 'dart:convert';
import 'dart:html' as html;

class CodeDownloadHelper {
  static void downloadCode({
    required String code,
    required String language,
  }) {
    final fileExtension = _getFileExtension(language);
    final fileName = 'improved_code.$fileExtension';

    final bytes = utf8.encode(code);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);

    final anchor =
    html.AnchorElement(href: url)
      ..setAttribute('download', fileName)
      ..click();

    html.Url.revokeObjectUrl(url);
    anchor.remove();
  }

  static String _getFileExtension(String language) {
    switch (language.toLowerCase()) {
      case 'java':
        return 'java';
      case 'python':
        return 'py';
      case 'javascript':
        return 'js';
      case 'typescript':
        return 'ts';
      case 'c':
        return 'c';
      case 'c++':
        return 'cpp';
      case 'c#':
        return 'cs';
      case 'dart':
        return 'dart';
      case 'go':
        return 'go';
      case 'php':
        return 'php';
      case 'kotlin':
        return 'kt';
      case 'swift':
        return 'swift';
      case 'rust':
        return 'rs';
      default:
        return 'txt';
    }
  }
}