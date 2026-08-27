import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../services/trivia_service.dart';
import 'quiz_screen.dart';

class DifficultyScreen extends StatefulWidget {
  final String category;
  final IconData categoryIcon;
  final Color categoryColor;

  const DifficultyScreen({
    super.key,
    required this.category,
    required this.categoryIcon,
    required this.categoryColor,
  });

  @override
  State<DifficultyScreen> createState() => _DifficultyScreenState();
}

class _DifficultyScreenState extends State<DifficultyScreen> {
  bool isLoading = false;
  String? loadingDifficulty;

  Future<void> startQuiz(
    String difficulty,
  ) async {
    if (isLoading) {
      return;
    }

    setState(() {
      isLoading = true;
      loadingDifficulty = difficulty;
    });

    try {
      final questions = await TriviaService.instance.getQuestions(
        category: widget.category,
        difficulty: difficulty,
      );

      if (!mounted) {
        return;
      }

      if (questions.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'No $difficulty questions are available for ${widget.category}.',
            ),
          ),
        );

        return;
      }

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => QuizScreen(
            category: widget.category,
            difficulty: difficulty,
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
            'Unable to load the quiz. Please try again.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
          loadingDifficulty = null;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          widget.category,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              const SizedBox(height: 20),

              Container(
                width: 110,
                height: 110,
                decoration: BoxDecoration(
                  color: widget.categoryColor.withValues(
                    alpha: 0.12,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.categoryIcon,
                  size: 58,
                  color: widget.categoryColor,
                ),
              ),

              const SizedBox(height: 22),

              Text(
                widget.category,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.primaryBlue,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Choose your difficulty level',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 35),

              _DifficultyCard(
                title: 'Easy',
                description: 'Perfect for beginners',
                points: '100 points per correct answer',
                icon: Icons.sentiment_satisfied_alt_rounded,
                color: const Color(0xFF27AE60),
                isLoading:
                    isLoading && loadingDifficulty == 'Easy',
                disabled: isLoading,
                onTap: () {
                  startQuiz(
                    'Easy',
                  );
                },
              ),

              const SizedBox(height: 15),

              _DifficultyCard(
                title: 'Medium',
                description: 'Challenge your knowledge',
                points: '200 points per correct answer',
                icon: Icons.psychology_alt_rounded,
                color: const Color(0xFFF39C12),
                isLoading:
                    isLoading && loadingDifficulty == 'Medium',
                disabled: isLoading,
                onTap: () {
                  startQuiz(
                    'Medium',
                  );
                },
              ),

              const SizedBox(height: 15),

              _DifficultyCard(
                title: 'Hard',
                description: 'For Filipino trivia experts',
                points: '300 points per correct answer',
                icon: Icons.local_fire_department_rounded,
                color: AppColors.primaryRed,
                isLoading:
                    isLoading && loadingDifficulty == 'Hard',
                disabled: isLoading,
                onTap: () {
                  startQuiz(
                    'Hard',
                  );
                },
              ),

              const SizedBox(height: 25),

              const Text(
                'Questions are loaded from the Pinoy Trivia question bank.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DifficultyCard extends StatelessWidget {
  final String title;
  final String description;
  final String points;
  final IconData icon;
  final Color color;
  final bool isLoading;
  final bool disabled;
  final VoidCallback onTap;

  const _DifficultyCard({
    required this.title,
    required this.description,
    required this.points,
    required this.icon,
    required this.color,
    required this.isLoading,
    required this.disabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: disabled
            ? null
            : onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: color.withValues(
                alpha: 0.35,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withValues(
                    alpha: 0.12,
                  ),
                  borderRadius: BorderRadius.circular(17),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 32,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: color,
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      points,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),

              if (isLoading)
                SizedBox(
                  width: 25,
                  height: 25,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: color,
                  ),
                )
              else
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: color,
                  size: 18,
                ),
            ],
          ),
        ),
      ),
    );
  }
}