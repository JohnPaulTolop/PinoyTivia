class TriviaQuestion {
  final String id;
  final String question;
  final List<String> choices;
  final int correctAnswerIndex;
  final String explanation;
  final String category;
  final String difficulty;
  final bool isActive;

  const TriviaQuestion({
    this.id = '',
    required this.question,
    required this.choices,
    required this.correctAnswerIndex,
    required this.explanation,
    required this.category,
    required this.difficulty,
    this.isActive = true,
  });

  factory TriviaQuestion.fromMap(
    Map<String, dynamic> data, {
    String id = '',
  }) {
    final rawChoices = data['choices'];

    return TriviaQuestion(
      id: id,
      question: data['question'] as String? ?? '',
      choices: rawChoices is List
          ? rawChoices.map((item) => item.toString()).toList()
          : [],
      correctAnswerIndex:
          (data['correctAnswerIndex'] as num?)?.toInt() ?? 0,
      explanation: data['explanation'] as String? ?? '',
      category: data['category'] as String? ?? '',
      difficulty: data['difficulty'] as String? ?? 'Easy',
      isActive: data['isActive'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'choices': choices,
      'correctAnswerIndex': correctAnswerIndex,
      'explanation': explanation,
      'category': category,
      'difficulty': difficulty,
      'isActive': isActive,
    };
  }
}