import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';

class _HoverActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _HoverActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  State<_HoverActionButton> createState() => _HoverActionButtonState();
}

class _HoverActionButtonState extends State<_HoverActionButton> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isHovering
                ? const Color(0xFF232734) // 🔥 hover bg
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isHovering
                  ? const Color(0xFF3B3F4A)
                  : Colors.transparent,
            ),
          ),
          child: Row(
            children: [
              Icon(
                widget.icon,
                color: Colors.white,
                size: isHovering ? 22 : 20, // slight pop
              ),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: isHovering
                      ? FontWeight.w600
                      : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImprovedCodeCard extends StatelessWidget {
  const ImprovedCodeCard({
    super.key,
    required this.improvedCode,
    required this.onCopy,
    required this.onDownload,
    required this.onCompare,
    required this.scrollController,
    required this.language,
  });

  final String improvedCode;
  final VoidCallback onCopy;
  final VoidCallback onDownload;
  final VoidCallback onCompare;
  final ScrollController scrollController;
  final String language;

  String _mapLanguage(String language) {
    switch (language.toLowerCase()) {
      case 'java':
        return 'java';
      case 'python':
        return 'python';
      case 'javascript':
        return 'javascript';
      case 'typescript':
        return 'typescript';
      case 'c':
        return 'cpp';
      case 'c++':
        return 'cpp';
      case 'c#':
        return 'cs';
      case 'dart':
        return 'dart';
      case 'go':
        return 'go';
      case 'php':
        return 'php';
      case 'kotlin':
        return 'kotlin';
      case 'swift':
        return 'swift';
      case 'rust':
        return 'rust';
      default:
        return 'dart';
    }
  }

  Map<String, TextStyle> get _cleanDarkTheme => {
    'root': const TextStyle(
      backgroundColor: Colors.transparent,
      color: Color(0xFFE5E7EB),
    ),
    'keyword': const TextStyle(color: Color(0xFFC678DD)),
    'selector-tag': const TextStyle(color: Color(0xFFC678DD)),
    'literal': const TextStyle(color: Color(0xFF56B6C2)),
    'section': const TextStyle(color: Color(0xFF61AFEF)),
    'link': const TextStyle(color: Color(0xFF61AFEF)),
    'function': const TextStyle(color: Color(0xFF61AFEF)),
    'title': const TextStyle(color: Color(0xFF61AFEF)),
    'subst': const TextStyle(color: Color(0xFFE5E7EB)),
    'string': const TextStyle(color: Color(0xFF98C379)),
    'char.escape_': const TextStyle(color: Color(0xFF98C379)),
    'regexp': const TextStyle(color: Color(0xFF98C379)),
    'symbol': const TextStyle(color: Color(0xFFE5C07B)),
    'variable': const TextStyle(color: Color(0xFFE06C75)),
    'template-variable': const TextStyle(color: Color(0xFFE06C75)),
    'type': const TextStyle(color: Color(0xFFE5C07B)),
    'built_in': const TextStyle(color: Color(0xFFE5C07B)),
    'builtin-name': const TextStyle(color: Color(0xFFE5C07B)),
    'number': const TextStyle(color: Color(0xFFD19A66)),
    'comment': const TextStyle(color: Color(0xFF7F848E)),
    'quote': const TextStyle(color: Color(0xFF7F848E)),
    'meta': const TextStyle(color: Color(0xFF7F848E)),
    'deletion': const TextStyle(color: Color(0xFFE06C75)),
    'addition': const TextStyle(color: Color(0xFF98C379)),
  };

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
                  color: const Color(0xFF0E2B21),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.code_rounded,
                  color: Color(0xFF00E28A),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Improved Code',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      language,
                      style: const TextStyle(
                        color: Color(0xFF9CA3AF),
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  _HoverActionButton(
                    icon: Icons.compare_arrows_rounded,
                    label: 'Compare',
                    onTap: onCompare,
                  ),
                  const SizedBox(width: 10),
                  _HoverActionButton(
                    icon: Icons.download_rounded,
                    label: 'Download',
                    onTap: onDownload,
                  ),
                  const SizedBox(width: 10),
                  _HoverActionButton(
                    icon: Icons.content_copy_outlined,
                    label: 'Copy',
                    onTap: onCopy,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 28),
          Container(
            width: double.infinity,
            constraints: const BoxConstraints(minHeight: 300),
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              color: const Color(0xFF0B0D12),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFF232734)),
            ),
            child: Scrollbar(
              controller: scrollController,
              thumbVisibility: true,
              child: SingleChildScrollView(
                controller: scrollController,
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: SelectionArea(
                    child: HighlightView(
                      improvedCode,
                      language: _mapLanguage(language),
                      theme: _cleanDarkTheme,
                      padding: EdgeInsets.zero,
                      textStyle: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 16,
                        height: 1.55,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}