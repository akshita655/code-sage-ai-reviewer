import 'package:highlight/languages/cpp.dart';
import 'package:highlight/languages/cs.dart';
import 'package:highlight/languages/dart.dart';
import 'package:highlight/languages/go.dart';
import 'package:highlight/languages/java.dart';
import 'package:highlight/languages/javascript.dart';
import 'package:highlight/languages/kotlin.dart';
import 'package:highlight/languages/php.dart';
import 'package:highlight/languages/python.dart';
import 'package:highlight/languages/rust.dart';
import 'package:highlight/languages/swift.dart';
import 'package:highlight/languages/typescript.dart';

class CodeLanguageHelper {
  static dynamic getHighlightLanguage(String language) {
    switch (language.toLowerCase()) {
      case 'java':
        return java;
      case 'python':
        return python;
      case 'javascript':
        return javascript;
      case 'typescript':
        return typescript;
      case 'c':
        return cpp;
      case 'c++':
        return cpp;
      case 'c#':
        return cs;
      case 'dart':
        return dart;
      case 'go':
        return go;
      case 'php':
        return php;
      case 'kotlin':
        return kotlin;
      case 'swift':
        return swift;
      case 'rust':
        return rust;
      default:
        return dart;
    }
  }
}