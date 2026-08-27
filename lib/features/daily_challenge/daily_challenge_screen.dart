import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../services/trivia_service.dart';
import '../quiz/quiz_screen.dart';

class DailyChallengeScreen extends StatefulWidget {
  const DailyChallengeScreen({
    super.key,
  });

  @override
  State<DailyChallengeScreen> createState() =>
      _DailyChallengeScreenState();
}

class _DailyChallengeScreenState
    extends State<DailyChallengeScreen> {
  bool isLoading = false;

  Future<void> _startChallenge() async {
    if (isLoading) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final questions =
          await TriviaService.instance.getDailyQuestions();

      if (!mounted) {
        return;
      }

      if (questions.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Daily Challenge questions are unavailable.',
            ),
          ),
        );

        return;
      }

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => QuizScreen(
            category: 'Daily Challenge',
            difficulty: 'Daily',
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
            'Unable to start the Daily Challenge.',
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Daily Challenge',
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            children: [
              const Spacer(),

              Container(
                width: 135,
                height: 135,
                decoration: const BoxDecoration(
                  color: Color(0xFFFFF3C4),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: AppColors.gold,
                  size: 75,
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'Today\'s Challenge',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.primaryBlue,
                  fontSize: 29,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 12),

              const Text(
                'Test your knowledge with up to 10 mixed Filipino trivia questions.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 30),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color:
                        Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
                child: const Column(
                  children: [
                    _ChallengeInfo(
                      icon: Icons.quiz_rounded,
                      title: 'Questions',
                      value: 'Up to 10',
                    ),
                    Divider(),
                    _ChallengeInfo(
                      icon: Icons.category_rounded,
                      title: 'Categories',
                      value: 'Mixed',
                    ),
                    Divider(),
                    _ChallengeInfo(
                      icon: Icons.calendar_today_rounded,
                      title: 'Selection',
                      value: 'Changes daily',
                    ),
                  ],
                ),
              ),

              const Spacer(),

              FilledButton.icon(
                onPressed: isLoading
                    ? null
                    : _startChallenge,
                icon: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.play_arrow_rounded,
                      ),
                label: Text(
                  isLoading
                      ? 'Loading Challenge...'
                      : 'Start Daily Challenge',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChallengeInfo extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _ChallengeInfo({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppColors.primaryBlue,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}