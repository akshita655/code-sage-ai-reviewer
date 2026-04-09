class CodeAutoDetectHelper {
  static String? detectLanguageFromCode(String code) {
    final text = code.trim();

    if (text.isEmpty) return null;

    // C
    if (text.contains('#include <stdio.h>') ||
        text.contains('#include <stdlib.h>') ||
        text.contains('printf(') ||
        text.contains('scanf(') ||
        text.contains('malloc(') ||
        text.contains('free(')) {
      return 'C';
    }

    // C++
    if (text.contains('#include <iostream>') ||
        text.contains('std::cout') ||
        text.contains('std::cin') ||
        text.contains('using namespace std')) {
      return 'C++';
    }

    // Java
    if (text.contains('public static void main') ||
        text.contains('System.out.println') ||
        (text.contains('public class ') && text.contains(';'))) {
      return 'Java';
    }

    // Python
    if (text.contains('def ') ||
        text.contains('if __name__ == "__main__":') ||
        (text.contains('import ') && !text.contains(';'))) {
      return 'Python';
    }

    // JavaScript
    if (text.contains('console.log(') ||
        text.contains('function ') ||
        text.contains('const ') ||
        text.contains('let ') ||
        text.contains('var ')) {
      return 'JavaScript';
    }

    // TypeScript
    if (text.contains('interface ') ||
        text.contains(': string') ||
        text.contains(': number') ||
        text.contains('type ')) {
      return 'TypeScript';
    }

    // Dart
    if (text.contains('runApp(') ||
        text.contains('StatelessWidget') ||
        text.contains('StatefulWidget') ||
        text.contains("import 'package:flutter/")) {
      return 'Dart';
    }

    // C#
    if (text.contains('using System;') ||
        text.contains('Console.WriteLine(') ||
        text.contains('namespace ')) {
      return 'C#';
    }

    // Go
    if (text.contains('package main') ||
        text.contains('func main()') ||
        text.contains('fmt.Println(')) {
      return 'Go';
    }

    // PHP
    if (text.contains('<?php') || text.contains('echo ')) {
      return 'PHP';
    }

    // Kotlin
    if (text.contains('fun main()') ||
        (text.contains('val ') && text.contains('println('))) {
      return 'Kotlin';
    }

    // Swift
    if (text.contains('import SwiftUI') ||
        text.contains('var body: some View')) {
      return 'Swift';
    }

    // Rust
    if (text.contains('fn main()') ||
        text.contains('println!(') ||
        text.contains('let mut ')) {
      return 'Rust';
    }

    return null;
  }
}