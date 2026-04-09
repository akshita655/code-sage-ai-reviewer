import 'package:flutter/material.dart';

class LanguageDropdown extends StatelessWidget {
  const LanguageDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String value;
  final List<String> items;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF151821),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF232734)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: const Color(0xFF151821),
          borderRadius: BorderRadius.circular(14),
          isExpanded: true,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: Color(0xFF787E8D),
          ),
          items: items
              .map(
                (language) => DropdownMenuItem<String>(
              value: language,
              child: Text(language),
            ),
          )
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}