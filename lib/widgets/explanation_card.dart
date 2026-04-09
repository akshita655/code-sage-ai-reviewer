import 'package:flutter/material.dart';

class ExplanationCard extends StatelessWidget {
  const ExplanationCard({
    super.key,
    required this.explanation,
  });

  final String explanation;

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
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFF1F2432),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.menu_book_rounded,
                  color: Color(0xFF60A5FA),
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Code Explanation',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            explanation,
            style: const TextStyle(
              color: Color(0xFFD7DBE4),
              fontSize: 15,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}