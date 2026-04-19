import 'package:flutter/material.dart';
import 'package:code_text_field/code_text_field.dart';

class ImprovedCodeCard extends StatelessWidget {
  const ImprovedCodeCard({
    super.key,
    required this.controller,
    required this.scrollController,
    required this.language,
  });

  final CodeController controller;
  final ScrollController scrollController;
  final String language;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      // ❌ margin removed to match ComplexityCard width
      padding: const EdgeInsets.fromLTRB(28, 28, 28, 28),
      decoration: BoxDecoration(
        color: const Color(0xFF161820),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF232734)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 HEADER
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.code_rounded,
                  color: Color(0xFF60A5FA),
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Improved Code',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          const Text(
            'Optimized and cleaned code version',
            style: TextStyle(
              color: Color(0xFF9CA3AF),
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 24),

          /// 🔹 CODE EDITOR BLOCK
          Container(
            constraints: const BoxConstraints(minHeight: 220),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1117),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF232734)),
            ),
            child: Scrollbar(
              controller: scrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: scrollController,
                child: CodeField(
                  controller: controller,
                  readOnly: true,
                  expands: false,
                  textStyle: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13,
                    height: 1.5,
                    color: Color(0xFFE5E7EB),
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