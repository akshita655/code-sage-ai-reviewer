import 'package:flutter/material.dart';

class ImproveButton extends StatelessWidget {
  const ImproveButton({
    super.key,
    required this.enabled,
    required this.isLoading,
    required this.onTap,
  });

  final bool enabled;
  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 62, // ✅ SAME HEIGHT
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: enabled
              ? const LinearGradient(
            colors: [Color(0xFF1F2937), Color(0xFF374151)],
          )
              : const LinearGradient(
            colors: [Color(0xFF2E3342), Color(0xFF2E3342)],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: enabled
              ? [
            BoxShadow(
              color: const Color(0xFF374151).withOpacity(0.16),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ]
              : null,
        ),
        child: ElevatedButton.icon(
          onPressed: enabled ? onTap : null,

          icon: isLoading
              ? const SizedBox(
            width: 18,
            height: 18,
            child: CircularProgressIndicator(
              strokeWidth: 2.2,
              color: Colors.white,
            ),
          )
              : const Icon(
            Icons.auto_fix_high_rounded, // ✨ Improve icon
            color: Color(0xFFE6E8EE),
            size: 22,
          ),

          label: Text(
            isLoading ? 'Improving...' : 'Improve Code',
            style: const TextStyle(
              color: Color(0xFFF1F3F6),
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),

          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            disabledBackgroundColor: Colors.transparent,
            disabledForegroundColor: const Color(0xFF9BA1AF),
            padding: const EdgeInsets.symmetric(horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
        ),
      ),
    );
  }
}