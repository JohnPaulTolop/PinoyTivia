import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/quiz_result.dart';
import '../../services/app_data.dart';

class QuizHistoryScreen extends StatelessWidget {
  const QuizHistoryScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: AppData.instance,
          builder: (context, child) {
            final history = AppData.instance.quizHistory;

            return Column(
              children: [
                _buildHeader(
                  context,
                  history,
                ),

                Expanded(
                  child: history.isEmpty
                      ? _buildEmptyHistory()
                      : _buildHistoryList(
                          history,
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    List<QuizResult> history,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        12,
        25,
      ),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.darkBlue,
            AppColors.primaryBlue,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Quiz History',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),

              if (history.isNotEmpty)
                IconButton(
                  tooltip: 'Clear history',
                  onPressed: () {
                    _showClearDialog(
                      context,
                    );
                  },
                  icon: const Icon(
                    Icons.delete_outline_rounded,
                    color: Colors.white,
                  ),
                ),
            ],
          ),

          const SizedBox(height: 5),

          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Review your previous quiz performances',
              style: TextStyle(
                color: Colors.white70,
              ),
            ),
          ),

          const SizedBox(height: 22),

          Row(
            children: [
              Expanded(
                child: _HeaderStat(
                  value:
                      '${AppData.instance.totalQuizzes}',
                  label: 'Quizzes',
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _HeaderStat(
                  value:
                      '${AppData.instance.totalPoints}',
                  label: 'Points',
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: _HeaderStat(
                  value:
                      '${AppData.instance.overallAccuracy}%',
                  label: 'Accuracy',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyHistory() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: const BoxDecoration(
                color: AppColors.lightBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.history_rounded,
                size: 55,
                color: AppColors.primaryBlue,
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'No Quiz History Yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.primaryBlue,
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              'Complete your first trivia quiz and your result will appear here.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryList(
    List<QuizResult> history,
  ) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: history.length,
      separatorBuilder: (_, _) {
        return const SizedBox(
          height: 12,
        );
      },
      itemBuilder: (context, index) {
        final result = history[index];

        return _HistoryCard(
          result: result,
        );
      },
    );
  }

  void _showClearDialog(
    BuildContext context,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Clear Quiz History?',
          ),
          content: const Text(
            'This will remove all your current quiz results and reset your statistics.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                );
              },
              child: const Text(
                'Cancel',
              ),
            ),

            FilledButton(
              onPressed: () {
                AppData.instance
                    .clearQuizHistory();

                Navigator.pop(
                  dialogContext,
                );
              },
              style: FilledButton.styleFrom(
                backgroundColor:
                    AppColors.primaryRed,
              ),
              child: const Text(
                'Clear',
              ),
            ),
          ],
        );
      },
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final QuizResult result;

  const _HistoryCard({
    required this.result,
  });

  @override
  Widget build(BuildContext context) {
    final bool goodScore =
        result.accuracy >= 70;

    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color:
                      AppColors.lightBlue,
                  borderRadius:
                      BorderRadius.circular(
                    15,
                  ),
                ),
                child: const Icon(
                  Icons.quiz_rounded,
                  color:
                      AppColors.primaryBlue,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      result.category,
                      style:
                          const TextStyle(
                        fontSize: 16,
                        fontWeight:
                            FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Row(
                      children: [
                        _DifficultyBadge(
                          difficulty:
                              result.difficulty,
                        ),

                        const SizedBox(
                          width: 8,
                        ),

                        Text(
                          _formatDate(
                            result.completedAt,
                          ),
                          style:
                              const TextStyle(
                            fontSize: 11,
                            color: AppColors
                                .textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Column(
                children: [
                  Text(
                    '${result.score}',
                    style: const TextStyle(
                      color:
                          AppColors.primaryBlue,
                      fontSize: 21,
                      fontWeight:
                          FontWeight.w900,
                    ),
                  ),

                  const Text(
                    'points',
                    style: TextStyle(
                      fontSize: 10,
                      color:
                          AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          const Divider(),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: _HistoryStat(
                  icon:
                      Icons.check_circle_rounded,
                  value:
                      '${result.correctAnswers}',
                  label: 'Correct',
                ),
              ),

              Expanded(
                child: _HistoryStat(
                  icon: Icons.cancel_rounded,
                  value:
                      '${result.incorrectAnswers}',
                  label: 'Wrong',
                ),
              ),

              Expanded(
                child: _HistoryStat(
                  icon:
                      Icons.track_changes_rounded,
                  value:
                      '${result.accuracy}%',
                  label: 'Accuracy',
                  highlight: goodScore,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(
    DateTime date,
  ) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];

    final hour =
        date.hour > 12
            ? date.hour - 12
            : date.hour == 0
                ? 12
                : date.hour;

    final minute =
        date.minute
            .toString()
            .padLeft(
              2,
              '0',
            );

    final period =
        date.hour >= 12
            ? 'PM'
            : 'AM';

    return '${months[date.month - 1]} ${date.day}, ${date.year} • $hour:$minute $period';
  }
}

class _DifficultyBadge
    extends StatelessWidget {
  final String difficulty;

  const _DifficultyBadge({
    required this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (difficulty) {
      case 'Hard':
        color =
            AppColors.primaryRed;
        break;

      case 'Medium':
        color =
            const Color(
          0xFFF39C12,
        );
        break;

      default:
        color =
            const Color(
          0xFF27AE60,
        );
    }

    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: 0.12,
        ),
        borderRadius:
            BorderRadius.circular(20),
      ),
      child: Text(
        difficulty,
        style: TextStyle(
          color: color,
          fontWeight:
              FontWeight.w800,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _HistoryStat extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final bool highlight;

  const _HistoryStat({
    required this.icon,
    required this.value,
    required this.label,
    this.highlight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: highlight
              ? const Color(
                  0xFF27AE60,
                )
              : AppColors.primaryBlue,
        ),

        const SizedBox(height: 5),

        Text(
          value,
          style: const TextStyle(
            fontWeight:
                FontWeight.w900,
          ),
        ),

        const SizedBox(height: 2),

        Text(
          label,
          style: const TextStyle(
            color:
                AppColors.textSecondary,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _HeaderStat
    extends StatelessWidget {
  final String value;
  final String label;

  const _HeaderStat({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        vertical: 13,
      ),
      decoration: BoxDecoration(
        color: Colors.white
            .withValues(
          alpha: 0.12,
        ),
        borderRadius:
            BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Text(
            value,
            style:
                const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight:
                  FontWeight.w900,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            label,
            style:
                const TextStyle(
              color: Colors.white70,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}