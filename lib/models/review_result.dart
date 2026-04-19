class ReviewResult {
  final List<String> issues;
  final List<String> suggestions;
  final int score;

  // ✅ ADD THESE
  final String timeComplexity;
  final String spaceComplexity;
  final String complexityExplanation;

  ReviewResult({
    required this.issues,
    required this.suggestions,
    required this.score,

    // ✅ ADD THESE
    required this.timeComplexity,
    required this.spaceComplexity,
    required this.complexityExplanation,
  });
}