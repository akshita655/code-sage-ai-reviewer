import 'package:flutter/material.dart';

class AppHeader extends StatelessWidget {
  const AppHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(
                colors: [Color(0xFF4F8CFF), Color(0xFFB620E0)],
              ),
            ),
            child: const Icon(Icons.code_rounded, color: Colors.white, size: 28),
          ),
          const SizedBox(width: 14),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'CodeSage AI',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 26,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'Analyze and improve your code using AI',
                style: TextStyle(
                  color: Color(0xFFA4A8B5),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}