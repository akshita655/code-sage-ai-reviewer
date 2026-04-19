import 'package:flutter/material.dart';

class ImprovedCodeCard extends StatelessWidget {
  const ImprovedCodeCard({
    super.key,
    required this.improvedCode,
    required this.scrollController,
    required this.language,
  });

  final String improvedCode;
  final ScrollController scrollController;
  final String language;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111318), // outer background (same tone)
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFF1F2430)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 TITLE
          Row(
            children: const [
              Icon(Icons.code_rounded, color: Color(0xFF8B5CF6)),
              SizedBox(width: 10),
              Text(
                'Improved Code',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),

          const Text(
            'Optimized and cleaned code version',
            style: TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 16),

          /// 🔹 CODE BOX (inner card like complexity rows)
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFF0B0E14),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFF1A1D27)),
            ),
            padding: const EdgeInsets.all(14),
            child: Scrollbar(
              controller: scrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: scrollController,
                child: SelectableText(
                  improvedCode,
                  style: const TextStyle(
                    color: Color(0xFFE5E7EB),
                    fontFamily: 'monospace',
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}