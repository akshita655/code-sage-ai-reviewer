import 'package:flutter/material.dart';

class CodeCompareDialog extends StatelessWidget {
  const CodeCompareDialog({
    super.key,
    required this.originalCode,
    required this.improvedCode,
  });

  final String originalCode;
  final String improvedCode;

  List<_CompareRow> _buildComparisonRows() {
    final oldLines = originalCode.split('\n');
    final newLines = improvedCode.split('\n');

    final maxLength = oldLines.length > newLines.length
        ? oldLines.length
        : newLines.length;

    final rows = <_CompareRow>[];

    for (int i = 0; i < maxLength; i++) {
      final oldLine = i < oldLines.length ? oldLines[i] : null;
      final newLine = i < newLines.length ? newLines[i] : null;

      if (oldLine != null && newLine != null) {
        if (oldLine == newLine) {
          rows.add(
            _CompareRow(
              leftLineNumber: i + 1,
              rightLineNumber: i + 1,
              leftText: oldLine,
              rightText: newLine,
              leftBg: Colors.transparent,
              rightBg: Colors.transparent,
            ),
          );
        } else {
          rows.add(
            _CompareRow(
              leftLineNumber: i + 1,
              rightLineNumber: i + 1,
              leftText: oldLine,
              rightText: newLine,
              leftBg: const Color(0xFF3A1F24),
              rightBg: const Color(0xFF1D3328),
            ),
          );
        }
      } else if (oldLine != null) {
        rows.add(
          _CompareRow(
            leftLineNumber: i + 1,
            rightLineNumber: null,
            leftText: oldLine,
            rightText: '',
            leftBg: const Color(0xFF3A1F24),
            rightBg: Colors.transparent,
          ),
        );
      } else if (newLine != null) {
        rows.add(
          _CompareRow(
            leftLineNumber: null,
            rightLineNumber: i + 1,
            leftText: '',
            rightText: newLine,
            leftBg: Colors.transparent,
            rightBg: const Color(0xFF1D3328),
          ),
        );
      }
    }

    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final rows = _buildComparisonRows();

    return Dialog(
      backgroundColor: const Color(0xFF161820),
      insetPadding: const EdgeInsets.symmetric(horizontal: 36, vertical: 28),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Container(
        width: 1200,
        height: 720,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFF161820),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFF232734)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A1F3D),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.compare_arrows_rounded,
                    color: Color(0xFFB388FF),
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Code Comparison',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 22,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Compare original code with improved code',
                        style: TextStyle(
                          color: Color(0xFF9CA3AF),
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Close',
                    style: TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF0B0D12),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: const Color(0xFF232734)),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      decoration: const BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Color(0xFF232734)),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Previous Code',
                              style: TextStyle(
                                color: Color(0xFFFF9AA2),
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              'Improved Code',
                              style: TextStyle(
                                color: Color(0xFF7CFFB2),
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Scrollbar(
                        thumbVisibility: true,
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: rows.map((row) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: _CodePaneLine(
                                        lineNumber: row.leftLineNumber,
                                        text: row.leftText,
                                        backgroundColor: row.leftBg,
                                        textColor: row.leftBg == Colors.transparent
                                            ? const Color(0xFFD1D5DB)
                                            : const Color(0xFFFFB4BC),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: _CodePaneLine(
                                        lineNumber: row.rightLineNumber,
                                        text: row.rightText,
                                        backgroundColor: row.rightBg,
                                        textColor: row.rightBg == Colors.transparent
                                            ? const Color(0xFFD1D5DB)
                                            : const Color(0xFF9DFFC5),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CodePaneLine extends StatelessWidget {
  const _CodePaneLine({
    required this.lineNumber,
    required this.text,
    required this.backgroundColor,
    required this.textColor,
  });

  final int? lineNumber;
  final String text;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 34),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 34,
            child: Text(
              lineNumber?.toString() ?? '',
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontFamily: 'monospace',
                fontSize: 13,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text.isEmpty ? ' ' : text,
              style: TextStyle(
                color: textColor,
                fontFamily: 'monospace',
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CompareRow {
  const _CompareRow({
    required this.leftLineNumber,
    required this.rightLineNumber,
    required this.leftText,
    required this.rightText,
    required this.leftBg,
    required this.rightBg,
  });

  final int? leftLineNumber;
  final int? rightLineNumber;
  final String leftText;
  final String rightText;
  final Color leftBg;
  final Color rightBg;
}