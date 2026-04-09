import 'dart:async';
import 'dart:html' as html;

class CodeUploadResult {
  final String content;
  final String fileName;

  CodeUploadResult({
    required this.content,
    required this.fileName,
  });
}

class CodeUploadHelper {
  static Future<CodeUploadResult?> pickCodeFile() async {
    final completer = Completer<CodeUploadResult?>();

    final uploadInput = html.FileUploadInputElement();
    uploadInput.accept =
    '.txt,.java,.py,.js,.ts,.c,.cpp,.cs,.dart,.go,.php,.kt,.swift,.rs';
    uploadInput.click();

    uploadInput.onChange.listen((event) {
      final file = uploadInput.files?.first;
      if (file == null) {
        completer.complete(null);
        return;
      }

      final reader = html.FileReader();

      reader.readAsText(file);

      reader.onLoadEnd.listen((event) {
        final content = reader.result?.toString() ?? '';
        completer.complete(
          CodeUploadResult(
            content: content,
            fileName: file.name,
          ),
        );
      });

      reader.onError.listen((event) {
        completer.complete(null);
      });
    });

    return completer.future;
  }

  static String? detectLanguageFromFileName(String fileName) {
    final lower = fileName.toLowerCase();

    if (lower.endsWith('.java')) return 'Java';
    if (lower.endsWith('.py')) return 'Python';
    if (lower.endsWith('.js')) return 'JavaScript';
    if (lower.endsWith('.ts')) return 'TypeScript';
    if (lower.endsWith('.c')) return 'C';
    if (lower.endsWith('.cpp')) return 'C++';
    if (lower.endsWith('.cs')) return 'C#';
    if (lower.endsWith('.dart')) return 'Dart';
    if (lower.endsWith('.go')) return 'Go';
    if (lower.endsWith('.php')) return 'PHP';
    if (lower.endsWith('.kt')) return 'Kotlin';
    if (lower.endsWith('.swift')) return 'Swift';
    if (lower.endsWith('.rs')) return 'Rust';

    return null;
  }
}