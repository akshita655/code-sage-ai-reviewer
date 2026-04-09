import 'package:flutter/material.dart';

class HoverTextActionButton extends StatefulWidget {
  const HoverTextActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  State<HoverTextActionButton> createState() =>
      _HoverTextActionButtonState();
}

class _HoverTextActionButtonState extends State<HoverTextActionButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final color = _hovering ? Colors.white : const Color(0xFFC2C7D6);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: _hovering
                ? Colors.white.withOpacity(0.04)
                : Colors.transparent,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: color, size: 20),
              const SizedBox(width: 10),
              Text(
                widget.label,
                style: TextStyle(
                  color: color,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}