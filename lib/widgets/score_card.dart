import 'package:flutter/material.dart';

class ScoreCard extends StatelessWidget {
  const ScoreCard({super.key, required this.score});

  final int score;

  @override
  Widget build(BuildContext context) {
    final double progress = score / 100;
    final Color progressColor = score >= 80
        ? const Color(0xFF22C55E)
        : score >= 60
        ? const Color(0xFFEAB308)
        : const Color(0xFFEF4444);

    final String label = score >= 80
        ? 'Excellent'
        : score >= 60
        ? 'Good'
        : 'Needs work';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(28, 30, 28, 28),
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
                  color: const Color(0xFF112243),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.workspace_premium_outlined,
                  color: Color(0xFF4EA1FF),
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Code Quality Score',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$score',
                style: TextStyle(
                  color: progressColor,
                  fontSize: 60,
                  fontWeight: FontWeight.w800,
                  height: 1,
                ),
              ),
              const SizedBox(width: 8),
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  '/100',
                  style: TextStyle(
                    color: Color(0xFF9AA0AF),
                    fontSize: 24,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 14,
              valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              backgroundColor: const Color(0xFF2A2E38),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Text(
                label,
                style: TextStyle(
                  color: progressColor,
                  fontWeight: FontWeight.w700,
                  fontSize: 17,
                ),
              ),
              const Spacer(),
              const Text(
                'Keep improving',
                style: TextStyle(
                  color: Color(0xFF858B99),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}