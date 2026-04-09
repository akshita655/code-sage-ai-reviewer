import 'package:flutter/material.dart';

class ComplexityCard extends StatelessWidget {
  final String timeComplexity;
  final String spaceComplexity;
  final String explanation;

  const ComplexityCard({
    super.key,
    required this.timeComplexity,
    required this.spaceComplexity,
    required this.explanation,
  });

  Color _getComplexityColor(String complexity) {
    if (complexity.contains('1')) return const Color(0xFF00E28A); // green
    if (complexity.contains('log')) return const Color(0xFF61AFEF); // blue
    if (complexity.contains('n²') || complexity.contains('n^2')) {
      return const Color(0xFFFF6B6B); // red
    }
    if (complexity.contains('n')) return const Color(0xFFFFB86C); // orange
    return Colors.white;
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
          // 🔥 HEADER
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
                  Icons.analytics_rounded,
                  color: Color(0xFFB388FF),
                ),
              ),
              const SizedBox(width: 16),
              const Text(
                'Complexity Analysis',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ],
          ),

          const SizedBox(height: 28),

          // 🔥 TIME COMPLEXITY
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF0B0D12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF232734)),
            ),
            child: Row(
              children: [
                const Icon(Icons.timer_rounded, color: Colors.white),
                const SizedBox(width: 12),
                const Text(
                  "Time Complexity:",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                const Spacer(),
                Text(
                  timeComplexity,
                  style: TextStyle(
                    color: _getComplexityColor(timeComplexity),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // 🔥 SPACE COMPLEXITY
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF0B0D12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF232734)),
            ),
            child: Row(
              children: [
                const Icon(Icons.memory_rounded, color: Colors.white),
                const SizedBox(width: 12),
                const Text(
                  "Space Complexity:",
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                const Spacer(),
                Text(
                  spaceComplexity,
                  style: TextStyle(
                    color: _getComplexityColor(spaceComplexity),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 🔥 EXPLANATION
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF0B0D12),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF232734)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.lightbulb_outline, color: Colors.amber),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    explanation,
                    style: const TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}