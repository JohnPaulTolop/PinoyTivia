import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../services/trivia_service.dart';
import '../../models/quiz_result.dart';
import '../../services/app_data.dart';
import '../../services/firestore_service.dart';
import '../home/home_screen.dart';
import 'quiz_screen.dart';

class QuizResultScreen
    extends StatefulWidget {
  final String category;
  final String difficulty;
  final int score;
  final int correctAnswers;
  final int totalQuestions;

  const QuizResultScreen({
    super.key,
    required this.category,
    required this.difficulty,
    required this.score,
    required this.correctAnswers,
    required this.totalQuestions,
  });

  @override
  State<QuizResultScreen>
      createState() =>
          _QuizResultScreenState();
}

class _QuizResultScreenState
    extends State<QuizResultScreen> {
  bool resultSaved = false;
  bool isSaving = true;
  String? saveError;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance
        .addPostFrameCallback(
      (_) {
        _saveQuizResult();
      },
    );
  }

  Future<void> _saveQuizResult() async {
    if (resultSaved) {
      return;
    }

    resultSaved = true;

    final result = QuizResult(
      category: widget.category,
      difficulty: widget.difficulty,
      score: widget.score,
      correctAnswers:
          widget.correctAnswers,
      totalQuestions:
          widget.totalQuestions,
      completedAt: DateTime.now(),
    );

    try {
      await FirestoreService.instance
          .saveQuizResult(
        result,
      );

      // Add locally only after Firestore accepted the save.
      AppData.instance.addQuizResult(
        result,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        isSaving = false;
        saveError = null;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        isSaving = false;
        saveError =
            'Unable to save this result.';
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            'Quiz completed, but the result could not be saved.',
          ),
        ),
      );
    }
  }

  void _backToHome() {
    Navigator.of(context)
        .pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (_) =>
            const HomeScreen(),
      ),
      (route) => false,
    );
  }

  Future<void> _tryAgain() async {
  try {
    final questions =
        widget.category == 'Daily Challenge'
            ? await TriviaService.instance.getDailyQuestions()
            : await TriviaService.instance.getQuestions(
                category: widget.category,
                difficulty: widget.difficulty,
              );

    if (!mounted) {
      return;
    }

    if (questions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No questions are available for this quiz.',
          ),
        ),
      );

      return;
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => QuizScreen(
          category: widget.category,
          difficulty: widget.difficulty,
          questions: questions,
        ),
      ),
    );
  } catch (error) {
    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Unable to reload the quiz.',
        ),
      ),
    );
  }
}

  @override
  Widget build(
    BuildContext context,
  ) {
    final percentage =
        widget.totalQuestions == 0
            ? 0
            : ((widget.correctAnswers /
                        widget.totalQuestions) *
                    100)
                .round();

    final incorrectAnswers =
        widget.totalQuestions -
            widget.correctAnswers;

    return Scaffold(
      backgroundColor:
          Theme.of(context)
              .scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding:
              const EdgeInsets.all(
            25,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),

              Container(
                width: 125,
                height: 125,
                decoration:
                    const BoxDecoration(
                  color:
                      Color(0xFFFFF3C4),
                  shape:
                      BoxShape.circle,
                ),
                child: const Icon(
                  Icons
                      .emoji_events_rounded,
                  size: 78,
                  color:
                      AppColors.gold,
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              const Text(
                'Quiz Completed!',
                textAlign:
                    TextAlign.center,
                style: TextStyle(
                  color: AppColors
                      .primaryBlue,
                  fontSize: 30,
                  fontWeight:
                      FontWeight.w900,
                ),
              ),

              const SizedBox(
                height: 8,
              ),

              Text(
                _performanceTitle(
                  percentage,
                ),
                style: const TextStyle(
                  color: AppColors
                      .primaryRed,
                  fontSize: 17,
                  fontWeight:
                      FontWeight.w800,
                ),
              ),

              const SizedBox(
                height: 6,
              ),

              Text(
                _resultMessage(
                  percentage,
                ),
                textAlign:
                    TextAlign.center,
                style: const TextStyle(
                  color: AppColors
                      .textSecondary,
                  height: 1.5,
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              Container(
                width:
                    double.infinity,
                padding:
                    const EdgeInsets.all(
                  25,
                ),
                decoration:
                    BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surface,
                  borderRadius:
                      BorderRadius
                          .circular(22),
                ),
                child: Column(
                  children: [
                    const Text(
                      'YOUR SCORE',
                      style:
                          TextStyle(
                        color: AppColors
                            .textSecondary,
                        fontWeight:
                            FontWeight
                                .w700,
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),

                    Text(
                      '${widget.score}',
                      style:
                          const TextStyle(
                        fontSize: 48,
                        fontWeight:
                            FontWeight
                                .w900,
                        color: AppColors
                            .primaryBlue,
                      ),
                    ),

                    const Text(
                      'POINTS',
                      style:
                          TextStyle(
                        color: AppColors
                            .textSecondary,
                        fontSize: 11,
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    const Divider(),

                    const SizedBox(
                      height: 15,
                    ),

                    Row(
                      children: [
                        Expanded(
                          child:
                              _ResultStat(
                            value:
                                '${widget.correctAnswers}',
                            label:
                                'Correct',
                            icon: Icons
                                .check_circle_rounded,
                            color:
                                const Color(
                              0xFF27AE60,
                            ),
                          ),
                        ),

                        Expanded(
                          child:
                              _ResultStat(
                            value:
                                '$incorrectAnswers',
                            label:
                                'Wrong',
                            icon: Icons
                                .cancel_rounded,
                            color: AppColors
                                .primaryRed,
                          ),
                        ),

                        Expanded(
                          child:
                              _ResultStat(
                            value:
                                '$percentage%',
                            label:
                                'Accuracy',
                            icon: Icons
                                .track_changes_rounded,
                            color: AppColors
                                .primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 18,
              ),

              _buildSaveStatus(),

              const SizedBox(
                height: 20,
              ),

              Container(
                padding:
                    const EdgeInsets.all(
                  17,
                ),
                decoration:
                    BoxDecoration(
                  color: AppColors
                      .lightBlue,
                  borderRadius:
                      BorderRadius
                          .circular(18),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons
                              .military_tech_rounded,
                          color: AppColors
                              .primaryBlue,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          'Level ${AppData.instance.level}',
                          style:
                              const TextStyle(
                            color: AppColors
                                .primaryBlue,
                            fontWeight:
                                FontWeight
                                    .w900,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '${AppData.instance.currentLevelXP}/${AppData.instance.xpNeededForNextLevel} XP',
                          style:
                              const TextStyle(
                            fontSize: 11,
                            color: AppColors
                                .textSecondary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 12,
                    ),

                    ClipRRect(
                      borderRadius:
                          BorderRadius
                              .circular(20),
                      child:
                          LinearProgressIndicator(
                        value:
                            AppData.instance
                                .levelProgress,
                        minHeight: 8,
                        backgroundColor:
                            Colors.white,
                        color: AppColors
                            .primaryBlue,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 30,
              ),

              FilledButton.icon(
                onPressed:
                    isSaving
                        ? null
                        : _backToHome,
                icon: const Icon(
                  Icons.home_rounded,
                ),
                label: const Text(
                  'Back to Home',
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              SizedBox(
                width:
                    double.infinity,
                child:
                    OutlinedButton.icon(
                  onPressed:
                      isSaving
                          ? null
                          : _tryAgain,
                  icon: const Icon(
                    Icons
                        .refresh_rounded,
                  ),
                  label:
                      const Text(
                    'Try Again',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSaveStatus() {
    if (isSaving) {
      return const Row(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child:
                CircularProgressIndicator(
              strokeWidth: 2,
            ),
          ),
          SizedBox(width: 10),
          Text(
            'Saving your progress...',
          ),
        ],
      );
    }

    if (saveError != null) {
      return Row(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          const Icon(
            Icons
                .cloud_off_rounded,
            color:
                AppColors.primaryRed,
          ),
          const SizedBox(
            width: 8,
          ),
          Text(
            saveError!,
            style:
                const TextStyle(
              color: AppColors
                  .primaryRed,
            ),
          ),
        ],
      );
    }

    return const Row(
      mainAxisAlignment:
          MainAxisAlignment.center,
      children: [
        Icon(
          Icons
              .cloud_done_rounded,
          color:
              Color(0xFF27AE60),
        ),
        SizedBox(width: 8),
        Text(
          'Progress saved',
          style: TextStyle(
            color:
                Color(0xFF27AE60),
            fontWeight:
                FontWeight.w700,
          ),
        ),
      ],
    );
  }

  String _performanceTitle(
    int percentage,
  ) {
    if (percentage == 100) {
      return 'Perfect Score!';
    }

    if (percentage >= 90) {
      return 'Excellent!';
    }

    if (percentage >= 70) {
      return 'Great Job!';
    }

    if (percentage >= 50) {
      return 'Good Effort!';
    }

    return 'Keep Practicing!';
  }

  String _resultMessage(
    int percentage,
  ) {
    if (percentage == 100) {
      return 'Amazing! You answered every question correctly.';
    }

    if (percentage >= 90) {
      return 'You have excellent knowledge of this Filipino trivia category.';
    }

    if (percentage >= 70) {
      return 'You did very well. Keep learning and aim for a perfect score!';
    }

    if (percentage >= 50) {
      return 'You are making progress. Review the topics and try again.';
    }

    return 'Keep learning and practicing. Every quiz helps improve your knowledge.';
  }
}

class _ResultStat
    extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _ResultStat({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: color,
        ),
        const SizedBox(
          height: 7,
        ),
        Text(
          value,
          style:
              const TextStyle(
            fontSize: 19,
            fontWeight:
                FontWeight.w900,
          ),
        ),
        Text(
          label,
          style:
              const TextStyle(
            color: AppColors
                .textSecondary,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}