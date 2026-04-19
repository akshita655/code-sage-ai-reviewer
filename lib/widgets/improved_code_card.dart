import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';

import '../util/code_language_helper.dart';
import '../util/code_download_helper.dart';

class ImprovedCodeCard extends StatelessWidget {
  final String code;
  final String language;

  const ImprovedCodeCard({
    super.key,
    required this.code,
    required this.language,
  });

  void _copyCode(BuildContext context) {
    Clipboard.setData(ClipboardData(text: code));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Code copied to clipboard"),
      ),
    );
  }

  void _downloadCode(BuildContext context) {
    CodeDownloadHelper.downloadCode(
      code: code,
      language: language,
    );
  }

  Widget _actionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          children: [
            Icon(icon, size: 18, color: Colors.white70),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, // ✅ SAME WIDTH AS COMPLEXITY CARD
      padding: const EdgeInsets.fromLTRB(28, 28, 28, 28),
      decoration: BoxDecoration(
        color: const Color(0xFF161820),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF232734)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔥 HEADER + ACTIONS
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
              const Expanded(
                child: Text(
                  'Improved Code',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
              ),

              /// 🔥 ACTION BUTTONS (RIGHT SIDE)
              Row(
                children: [
                  _actionButton(
                    icon: Icons.download_rounded,
                    label: "Download",
                    onTap: () => _downloadCode(context),
                  ),
                  const SizedBox(width: 8),
                  _actionButton(
                    icon: Icons.copy_rounded,
                    label: "Copy",
                    onTap: () => _copyCode(context),
                  ),
                ],
              )
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

          /// 🔥 CODE BLOCK (NO GREY BG ANYMORE)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF0B0D12), // ✅ ONLY DARK BG
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF232734)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: HighlightView(
                code,
                language: language.toLowerCase(),
                theme: {
                  "root": const TextStyle(
                    backgroundColor: Colors.transparent, // ✅ REMOVE GREY
                    color: Color(0xFFE5E7EB),
                    fontFamily: 'monospace',
                    fontSize: 13,
                    height: 1.6,
                  ),
                },
                padding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}