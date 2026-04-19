import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import '../util/code_download_helper.dart';

class ImprovedCodeCard extends StatelessWidget {
  const ImprovedCodeCard({
    super.key,
    required this.code,
    required this.language,
  });

  final String code;
  final String language;

  /// 📋 COPY
  void _copyCode(BuildContext context) {
    Clipboard.setData(ClipboardData(text: code));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Code copied")),
    );
  }

  /// 📥 DOWNLOAD (FIXED)
  void _downloadCode(BuildContext context) {
    try {
      CodeDownloadHelper.downloadCode(
        code: code,
        language: language,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Downloaded")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
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
                fontSize: 14,
                fontWeight: FontWeight.w500,
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
      width: double.infinity,
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

              const Spacer(),

              /// 📥 DOWNLOAD
              _actionButton(
                icon: Icons.download_rounded,
                label: "Download",
                onTap: () => _downloadCode(context),
              ),

              const SizedBox(width: 14),

              /// 📋 COPY
              _actionButton(
                icon: Icons.copy_rounded,
                label: "Copy",
                onTap: () => _copyCode(context),
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

          /// 🔥 CODE BLOCK
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFF0D1117),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF232734)),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Material(
                color: Colors.transparent,
                child: HighlightView(
                  code,
                  language: language.toLowerCase(),
                  theme: atomOneDarkTheme,
                  padding: EdgeInsets.zero,
                  textStyle: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
              )
            ),
          ),
        ],
      ),
    );
  }
}