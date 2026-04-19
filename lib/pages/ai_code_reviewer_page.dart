import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../util/code_language_helper.dart';
import '../util/code_download_helper.dart';
import '../util/code_upload_helper.dart';
import '../util/code_auto_detect_helper.dart';
import 'package:code_text_field/code_text_field.dart';
import '../models/review_result.dart';
import '../services/openrouter_ai_reviewer.dart';
import '../services/mock_ai_reviewer.dart';
import '../widgets/app_header.dart';
import '../widgets/code_compare_dialog.dart';
import '../widgets/code_editor_card.dart';
import '../widgets/complexity_card.dart';
import '../widgets/explain_button.dart';
import '../widgets/explanation_card.dart';
import '../widgets/hover_text_action_button.dart';
import '../widgets/improve_button.dart';
import '../widgets/improved_code_card.dart';
import '../widgets/language_dropdown.dart';
import '../widgets/result_list_card.dart';
import '../widgets/review_button.dart';
import '../widgets/score_card.dart';

class AiCodeReviewerPage extends StatefulWidget {
  const AiCodeReviewerPage({super.key});


  @override
  State<AiCodeReviewerPage> createState() => _AiCodeReviewerPageState();
}

class _AiCodeReviewerPageState extends State<AiCodeReviewerPage> {
  late final CodeController _codeController;
  late CodeController _improvedCodeController;
  final ScrollController _inputScrollController = ScrollController();
  final ScrollController _improvedCodeScrollController = ScrollController();
  bool _isImproving = false;
  String? _improvedCodeResult;
  final List<String> _languages = [
    'Java',
    'Python',
    'JavaScript',
    'TypeScript',
    'C',
    'C++',
    'C#',
    'Dart',
    'Go',
    'PHP',
    'Kotlin',
    'Swift',
    'Rust',
  ];
  String _selectedLanguage = 'Java';

  bool _isReviewing = false;
  bool _isExplaining = false;
  ReviewResult? _reviewResult;
  String? _codeExplanation;
  String _currentAction = '';
  bool _skipNextAutoDetect = false;
  String _lastAutoDetectedLanguage = 'Java';

  bool get _hasCode => _codeController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();

    _codeController = CodeController(
      text: '',
      language: CodeLanguageHelper.getHighlightLanguage(_selectedLanguage),
    );

    _improvedCodeController = CodeController(
      text: '',
      language: CodeLanguageHelper.getHighlightLanguage(_selectedLanguage),
    );
    _codeController.addListener(() {
      if (!mounted) return;

      setState(() {});

      if (_skipNextAutoDetect) {
        _skipNextAutoDetect = false;
        return;
      }

      _autoDetectLanguageFromCode();
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    _improvedCodeController.dispose();
    _inputScrollController.dispose();
    _improvedCodeScrollController.dispose();
    super.dispose();
  }

  void _autoDetectLanguageFromCode() {
    final detectedLanguage =
    CodeAutoDetectHelper.detectLanguageFromCode(_codeController.text);

    if (detectedLanguage == null) return;
    if (!_languages.contains(detectedLanguage)) return;
    if (detectedLanguage == _selectedLanguage) return;

    setState(() {
      _selectedLanguage = detectedLanguage;
      _lastAutoDetectedLanguage = detectedLanguage;
      _codeController.language =
          CodeLanguageHelper.getHighlightLanguage(detectedLanguage);
    });
  }

  Future<void> _generateImprovedCode() async {
    if (!_hasCode || _isImproving) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _isImproving = true;
      _improvedCodeResult = null;
    });

    try {
      final result = await OpenRouterAiReviewer.generateImprovedCode(
        code: _codeController.text,
        language: _selectedLanguage,
      );

      if (!mounted) return;

      setState(() {
        _improvedCodeResult = result;

        // ✅ IMPORTANT: update editor here AFTER result comes
        _improvedCodeController.text = result;
        _improvedCodeController.language =
            CodeLanguageHelper.getHighlightLanguage(_selectedLanguage);
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to generate improved code: $e'),
        ),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _isImproving = false;
      });
    }
  }

  Future<void> _reviewCode() async {
    if (!_hasCode || _isReviewing || _isExplaining) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _isReviewing = true;
      _reviewResult = null;
    });

    try {
      final result = await OpenRouterAiReviewer.review(
        code: _codeController.text,
        language: _selectedLanguage,
      );

      if (!mounted) return;

      setState(() {
        _reviewResult = result;
      });
    } catch (e) {
      final fallbackResult = MockAiReviewer.review(
        code: _codeController.text,
        language: _selectedLanguage,
      );

      if (!mounted) return;

      setState(() {
        _reviewResult = fallbackResult;
      });

      debugPrint('Review error: $e');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Live AI failed: $e'),
        ),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _isReviewing = false;
      });
    }
  }

  Future<void> _explainCode() async {
    if (!_hasCode || _isExplaining || _isReviewing) return;

    FocusScope.of(context).unfocus();

    setState(() {
      _isExplaining = true;
      _codeExplanation = null;
    });

    try {
      final explanation = await OpenRouterAiReviewer.explainCode(
        code: _codeController.text,
        language: _selectedLanguage,
      );

      if (!mounted) return;

      setState(() {
        _codeExplanation = explanation;
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Explain request failed or timed out: $e'),
        ),
      );
    } finally {
      if (!mounted) return;

      setState(() {
        _isExplaining = false;
      });
    }
  }

  void _clearCode() {
    setState(() {
      _skipNextAutoDetect = false;
      _selectedLanguage = 'Java';
      _lastAutoDetectedLanguage = 'Java';
      _codeController.clear();
      _codeController.language =
          CodeLanguageHelper.getHighlightLanguage(_selectedLanguage);
      _reviewResult = null;
      _codeExplanation = null;
    });
  }

  Future<void> _uploadCodeFile() async {
    final result = await CodeUploadHelper.pickCodeFile();

    if (result == null) return;

    final detectedLanguage =
    CodeUploadHelper.detectLanguageFromFileName(result.fileName);

    setState(() {
      _skipNextAutoDetect = false;
      _codeController.text = result.content;

      if (detectedLanguage != null && _languages.contains(detectedLanguage)) {
        _selectedLanguage = detectedLanguage;
        _lastAutoDetectedLanguage = detectedLanguage;
        _codeController.language =
            CodeLanguageHelper.getHighlightLanguage(detectedLanguage);
      }

      _reviewResult = null;
      _codeExplanation = null;
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Loaded file: ${result.fileName}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Scrollbar(
          thumbVisibility: true,
          child: SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppHeader(),
                const Divider(color: Color(0xFF1A1D27), height: 1),

                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 34,
                    vertical: 30,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Code Input',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16,
                            ),
                          ),
                          Row(
                            children: [
                              HoverTextActionButton(
                                icon: Icons.code_rounded,
                                label: 'Upload',
                                onTap: _uploadCodeFile,
                              ),
                              const SizedBox(width: 10),
                              HoverTextActionButton(
                                icon: Icons.delete_outline_rounded,
                                label: 'Clear',
                                onTap: _clearCode,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      CodeEditorCard(
                        controller: _codeController,
                        scrollController: _inputScrollController,
                        language: _selectedLanguage,
                      ),

                      const SizedBox(height: 24),

                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SizedBox(
                            width: 250,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Language',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 15,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                LanguageDropdown(
                                  value: _selectedLanguage,
                                  items: _languages,
                                  onChanged: (value) {
                                    if (value == null) return;

                                    setState(() {
                                      _skipNextAutoDetect = true;
                                      _selectedLanguage = value;
                                      _codeController.language =
                                          CodeLanguageHelper.getHighlightLanguage(value);
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              ExplainButton(
                                enabled: _hasCode && !_isExplaining && !_isReviewing && !_isImproving,
                                isLoading: _isExplaining,
                                onTap: _explainCode,
                              ),
                              const SizedBox(width: 14),

                              ReviewButton(
                                enabled: _hasCode && !_isReviewing && !_isExplaining && !_isImproving,
                                isLoading: _isReviewing,
                                onTap: _reviewCode,
                              ),
                              const SizedBox(width: 14),

                              ImproveButton(
                                enabled: _hasCode && !_isImproving && !_isReviewing && !_isExplaining,
                                isLoading: _isImproving,
                                onTap: _generateImprovedCode,
                              ),
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ),

                if (_isReviewing || _isExplaining)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 24),
                      child: Column(
                        children: [
                          const SizedBox(
                            width: 36,
                            height: 36,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Color(0xFF7C3AED),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            _isExplaining
                                ? 'Explaining your code...'
                                : 'Analyzing your code...',
                            style: const TextStyle(
                              color: Color(0xFFB7BCCC),
                              fontSize: 15,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                if (_codeExplanation != null) ...[
                  const SizedBox(height: 22),
                  const Divider(color: Color(0xFF1A1D27), height: 1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 30),
                    child: ExplanationCard(
                      explanation: _codeExplanation!,
                    ),
                  ),
                ],

                if (_reviewResult != null) ...[
                  const SizedBox(height: 22),
                  const Divider(color: Color(0xFF1A1D27), height: 1),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 30,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1440),
                      child: Column(
                        children: [
                          const Center(
                            child: Text(
                              'Analysis Results',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final isWide = constraints.maxWidth > 960;

                                if (isWide) {
                                  return Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ResultListCard(
                                          title: 'Issues',
                                          icon: Icons.error_outline_rounded,
                                          iconBg: const Color(0xFF37151B),
                                          iconColor: const Color(0xFFFF5B6B),
                                          bulletColor:
                                          const Color(0xFFFF5B6B),
                                          items: _reviewResult!.issues,
                                        ),
                                      ),
                                      const SizedBox(width: 28),
                                      Expanded(
                                        child: ResultListCard(
                                          title: 'Suggestions',
                                          icon:
                                          Icons.lightbulb_outline_rounded,
                                          iconBg: const Color(0xFF3A300B),
                                          iconColor: const Color(0xFFFACC15),
                                          bulletColor:
                                          const Color(0xFFFACC15),
                                          items: _reviewResult!.suggestions,
                                        ),
                                      ),
                                    ],
                                  );
                                }

                                return Column(
                                  children: [
                                    ResultListCard(
                                      title: 'Issues',
                                      icon: Icons.error_outline_rounded,
                                      iconBg: const Color(0xFF37151B),
                                      iconColor: const Color(0xFFFF5B6B),
                                      bulletColor:
                                      const Color(0xFFFF5B6B),
                                      items: _reviewResult!.issues,
                                    ),
                                    const SizedBox(height: 20),
                                    ResultListCard(
                                      title: 'Suggestions',
                                      icon:
                                      Icons.lightbulb_outline_rounded,
                                      iconBg: const Color(0xFF3A300B),
                                      iconColor: const Color(0xFFFACC15),
                                      bulletColor:
                                      const Color(0xFFFACC15),
                                      items: _reviewResult!.suggestions,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),

                          const SizedBox(height: 30),

                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: ScoreCard(score: _reviewResult!.score),
                          ),
                          const SizedBox(height: 30),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 18),
                            child: ComplexityCard(
                              timeComplexity: _reviewResult!.timeComplexity,
                              spaceComplexity: _reviewResult!.spaceComplexity,
                              explanation: _reviewResult!.complexityExplanation,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 30,),

                if (_improvedCodeResult != null) ...[
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: ImprovedCodeCard(
                      controller: _improvedCodeController,
                      scrollController: _improvedCodeScrollController,
                      language: _selectedLanguage,

                    ),
                  ),
                ],

                const SizedBox(height: 200),
                const Divider(color: Color(0xFF1A1D27), height: 1),
                const SizedBox(height: 18),
                const Center(
                  child: Text(
                    'CodeSage AI • Powered by Advanced AI • Built for Developers',
                    style: TextStyle(
                      color: Color(0xFF767B88),
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Tooltip(
        message: "Help",
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: StatefulBuilder(
            builder: (context, setState) {
              bool isHovering = false;

              return MouseRegion(
                onEnter: (_) => setState(() => isHovering = true),
                onExit: (_) => setState(() => isHovering = false),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          backgroundColor: const Color(0xFF161820),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: const Text(
                            'How to use CodeSage AI',
                            style: TextStyle(color: Colors.white),
                          ),
                          content: const Text(
                            '1. Paste your code\n'
                                '2. Select your programming language\n'
                                '3. Click "Review Code"\n'
                                '4. Get AI suggestions and improved code',
                            style: TextStyle(
                              color: Color(0xFFB0B6C3),
                              height: 1.5,
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Got it'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: isHovering ? 48 : 44,
                    height: isHovering ? 48 : 44,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: isHovering
                          ? [
                        const BoxShadow(
                          color: Color(0x33000000),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ]
                          : [],
                    ),
                    child: const Icon(
                      Icons.question_mark_rounded,
                      color: Colors.black87,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}