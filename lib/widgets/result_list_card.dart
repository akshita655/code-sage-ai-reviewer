import 'package:flutter/material.dart';

class ResultListCard extends StatelessWidget {
  const ResultListCard({
    super.key,
    required this.title,
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.bulletColor,
    required this.items,
  });

  final String title;
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final Color bulletColor;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  color: iconBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: iconColor),
              ),
              const SizedBox(width: 16),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          ...items.map(
                (item) => Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 9),
                    child: Icon(Icons.circle, size: 6.5, color: bulletColor),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      item,
                      style: const TextStyle(
                        color: Color(0xFFE5E7EB),
                        fontSize: 16,
                        height: 1.55,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}