class QuizResult {
  final String category;
  final String difficulty;
  final int score;
  final int correctAnswers;
  final int totalQuestions;
  final DateTime completedAt;

  const QuizResult({
    required this.category,
    required this.difficulty,
    required this.score,
    required this.correctAnswers,
    required this.totalQuestions,
    required this.completedAt,
  });

  int get incorrectAnswers {
    return totalQuestions - correctAnswers;
  }

  int get accuracy {
    if (totalQuestions == 0) {
      return 0;
    }

    return ((correctAnswers / totalQuestions) * 100).round();
  }
}