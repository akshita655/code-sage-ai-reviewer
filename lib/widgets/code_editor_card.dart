import 'package:code_text_field/code_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';

import '../util/code_language_helper.dart';

class CodeEditorCard extends StatefulWidget {
  const CodeEditorCard({
    super.key,
    required this.controller,
    required this.scrollController,
    required this.language,
  });

  final CodeController controller;
  final ScrollController scrollController;
  final String language;

  @override
  State<CodeEditorCard> createState() => _CodeEditorCardState();
}

class _CodeEditorCardState extends State<CodeEditorCard> {
  static const double _fontSize = 16;
  static const double _lineHeightMultiplier = 1.55;
  static const int _minLines = 15;

  @override
  void didUpdateWidget(covariant CodeEditorCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.language != widget.language) {
      widget.controller.language =
          CodeLanguageHelper.getHighlightLanguage(widget.language);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 420),
      decoration: BoxDecoration(
        color: const Color(0xFF12141C),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF202430)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: CodeTheme(
          data: CodeThemeData(styles: atomOneDarkTheme),
          child: CodeField(
            controller: widget.controller,
            textStyle: const TextStyle(
              fontSize: _fontSize,
              height: _lineHeightMultiplier,
              fontFamily: 'monospace',
            ),
            lineNumberStyle: const LineNumberStyle(
              width: 58,
              textStyle: TextStyle(
                color: Color(0xFF717789),
                fontSize: _fontSize,
                height: _lineHeightMultiplier,
                fontFamily: 'monospace',
              ),
              background: Color(0xFF0E1017),
            ),
            background: const Color(0xFF12141C),
            expands: false,
            minLines: _minLines,
            maxLines: null,
            wrap: false,
            horizontalScroll: true,
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 12),
          ),
        ),
      ),
    );
  }
}