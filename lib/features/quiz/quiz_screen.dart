import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/trivia_question.dart';
import 'quiz_result_screen.dart';

class QuizScreen extends StatefulWidget {
  final String category;
  final String difficulty;
  final List<TriviaQuestion> questions;

  const QuizScreen({
    super.key,
    required this.category,
    required this.difficulty,
    required this.questions,
  });

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int? selectedAnswerIndex;

  bool answered = false;

  int correctAnswers = 0;
  int score = 0;

  TriviaQuestion get currentQuestion =>
      widget.questions[currentQuestionIndex];

  int get pointsPerQuestion {
    switch (widget.difficulty) {
      case 'Medium':
        return 200;
      case 'Hard':
        return 300;
      default:
        return 100;
    }
  }

  void selectAnswer(int index) {
    if (answered) {
      return;
    }

    final isCorrect =
        index == currentQuestion.correctAnswerIndex;

    setState(() {
      selectedAnswerIndex = index;
      answered = true;

      if (isCorrect) {
        correctAnswers++;
        score += pointsPerQuestion;
      }
    });
  }

  void nextQuestion() {
    if (!answered) {
      return;
    }

    if (currentQuestionIndex <
        widget.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedAnswerIndex = null;
        answered = false;
      });
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => QuizResultScreen(
            category: widget.category,
            difficulty: widget.difficulty,
            score: score,
            correctAnswers: correctAnswers,
            totalQuestions: widget.questions.length,
          ),
        ),
      );
    }
  }

  Color getAnswerColor(int index) {
    if (!answered) {
      return Colors.white;
    }

    if (index == currentQuestion.correctAnswerIndex) {
      return const Color(0xFFE5F7EC);
    }

    if (index == selectedAnswerIndex &&
        index != currentQuestion.correctAnswerIndex) {
      return const Color(0xFFFFE9E9);
    }

    return Colors.white;
  }

  Color getBorderColor(int index) {
    if (!answered) {
      return AppColors.border;
    }

    if (index == currentQuestion.correctAnswerIndex) {
      return const Color(0xFF27AE60);
    }

    if (index == selectedAnswerIndex) {
      return AppColors.primaryRed;
    }

    return AppColors.border;
  }

  Widget getTrailingIcon(int index) {
    if (!answered) {
      return const SizedBox.shrink();
    }

    if (index == currentQuestion.correctAnswerIndex) {
      return const Icon(
        Icons.check_circle_rounded,
        color: Color(0xFF27AE60),
      );
    }

    if (index == selectedAnswerIndex) {
      return const Icon(
        Icons.cancel_rounded,
        color: AppColors.primaryRed,
      );
    }

    return const SizedBox.shrink();
  }

  @override
  Widget build(BuildContext context) {
    final progress =
        (currentQuestionIndex + 1) /
        widget.questions.length;

    final correct =
        selectedAnswerIndex ==
        currentQuestion.correctAnswerIndex;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          widget.category,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Question ${currentQuestionIndex + 1}/${widget.questions.length}',
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),

                        const Spacer(),

                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 11,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.lightBlue,
                            borderRadius:
                                BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.difficulty,
                            style: const TextStyle(
                              color: AppColors.primaryBlue,
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    ClipRRect(
                      borderRadius:
                          BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 8,
                        backgroundColor:
                            const Color(0xFFE5E7EB),
                        color: AppColors.primaryBlue,
                      ),
                    ),

                    const SizedBox(height: 35),

                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(22),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(22),
                        border: Border.all(
                          color: AppColors.border,
                        ),
                      ),
                      child: Text(
                        currentQuestion.question,
                        style: const TextStyle(
                          fontSize: 22,
                          height: 1.35,
                          fontWeight: FontWeight.w900,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),

                    const SizedBox(height: 25),

                    ...List.generate(
                      currentQuestion.choices.length,
                      (index) {
                        final labels = [
                          'A',
                          'B',
                          'C',
                          'D',
                        ];

                        return Padding(
                          padding:
                              const EdgeInsets.only(
                            bottom: 13,
                          ),
                          child: InkWell(
                            borderRadius:
                                BorderRadius.circular(18),
                            onTap: () {
                              selectAnswer(index);
                            },
                            child: AnimatedContainer(
                              duration: const Duration(
                                milliseconds: 200,
                              ),
                              padding:
                                  const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color:
                                    getAnswerColor(index),
                                borderRadius:
                                    BorderRadius.circular(
                                  18,
                                ),
                                border: Border.all(
                                  color:
                                      getBorderColor(index),
                                  width: answered &&
                                          (index ==
                                                  selectedAnswerIndex ||
                                              index ==
                                                  currentQuestion
                                                      .correctAnswerIndex)
                                      ? 2
                                      : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    alignment:
                                        Alignment.center,
                                    decoration:
                                        BoxDecoration(
                                      color:
                                          AppColors.lightBlue,
                                      shape:
                                          BoxShape.circle,
                                    ),
                                    child: Text(
                                      labels[index],
                                      style:
                                          const TextStyle(
                                        fontWeight:
                                            FontWeight.w900,
                                        color: AppColors
                                            .primaryBlue,
                                      ),
                                    ),
                                  ),

                                  const SizedBox(
                                    width: 14,
                                  ),

                                  Expanded(
                                    child: Text(
                                      currentQuestion
                                          .choices[index],
                                      style:
                                          const TextStyle(
                                        fontSize: 15,
                                        fontWeight:
                                            FontWeight.w600,
                                      ),
                                    ),
                                  ),

                                  getTrailingIcon(
                                    index,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    if (answered) ...[
                      const SizedBox(height: 10),

                      Container(
                        width: double.infinity,
                        padding:
                            const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: correct
                              ? const Color(0xFFEAF8EF)
                              : const Color(0xFFFFECEC),
                          borderRadius:
                              BorderRadius.circular(18),
                        ),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  correct
                                      ? Icons
                                          .check_circle_rounded
                                      : Icons
                                          .cancel_rounded,
                                  color: correct
                                      ? const Color(
                                          0xFF27AE60,
                                        )
                                      : AppColors
                                          .primaryRed,
                                ),

                                const SizedBox(
                                  width: 8,
                                ),

                                Text(
                                  correct
                                      ? 'Correct!'
                                      : 'Incorrect!',
                                  style: TextStyle(
                                    fontSize: 19,
                                    fontWeight:
                                        FontWeight.w900,
                                    color: correct
                                        ? const Color(
                                            0xFF1E8449,
                                          )
                                        : AppColors
                                            .primaryRed,
                                  ),
                                ),

                                const Spacer(),

                                if (correct)
                                  Text(
                                    '+$pointsPerQuestion',
                                    style:
                                        const TextStyle(
                                      color: AppColors
                                          .primaryBlue,
                                      fontWeight:
                                          FontWeight.w900,
                                    ),
                                  ),
                              ],
                            ),

                            const SizedBox(height: 12),

                            const Text(
                              'Explanation',
                              style: TextStyle(
                                fontWeight:
                                    FontWeight.w800,
                              ),
                            ),

                            const SizedBox(height: 7),

                            Text(
                              currentQuestion
                                  .explanation,
                              style: const TextStyle(
                                height: 1.45,
                                color: AppColors
                                    .textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),

            if (answered)
              Container(
                padding:
                    const EdgeInsets.fromLTRB(
                  22,
                  12,
                  22,
                  22,
                ),
                color: AppColors.background,
                child: FilledButton(
                  onPressed: nextQuestion,
                  child: Text(
                    currentQuestionIndex ==
                            widget.questions.length -
                                1
                        ? 'View Results'
                        : 'Next Question',
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}