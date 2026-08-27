import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/achievement.dart';
import '../../services/app_data.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text(
          'Achievements',
        ),
      ),
      body: AnimatedBuilder(
        animation: AppData.instance,
        builder: (context, child) {
          final achievements = AppData.instance.achievements;

          return Column(
            children: [
              _buildProgressHeader(
                achievements,
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: achievements.length,
                  separatorBuilder: (_, _) {
                    return const SizedBox(
                      height: 12,
                    );
                  },
                  itemBuilder: (context, index) {
                    return _AchievementCard(
                      achievement: achievements[index],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildProgressHeader(
    List<Achievement> achievements,
  ) {
    final unlocked = AppData.instance.unlockedAchievements;

    final progress = achievements.isEmpty
        ? 0.0
        : unlocked / achievements.length;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.darkBlue,
            AppColors.primaryBlue,
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.emoji_events_rounded,
            size: 65,
            color: AppColors.yellow,
          ),
          const SizedBox(height: 15),
          Text(
            '$unlocked / ${achievements.length} Unlocked',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 9,
              backgroundColor: Colors.white24,
              color: AppColors.yellow,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Keep playing to unlock more achievements!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementCard extends StatelessWidget {
  final Achievement achievement;

  const _AchievementCard({
    required this.achievement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: achievement.unlocked
            ? Colors.white
            : const Color(0xFFF1F2F4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: achievement.unlocked
              ? AppColors.yellow
              : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: achievement.unlocked
                  ? const Color(0xFFFFF4C7)
                  : const Color(0xFFE5E7EB),
              shape: BoxShape.circle,
            ),
            child: Icon(
              achievement.unlocked
                  ? achievement.icon
                  : Icons.lock_rounded,
              size: 32,
              color: achievement.unlocked
                  ? AppColors.gold
                  : Colors.grey,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: achievement.unlocked
                        ? AppColors.textPrimary
                        : Colors.grey,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  achievement.description,
                  style: TextStyle(
                    color: achievement.unlocked
                        ? AppColors.textSecondary
                        : Colors.grey,
                    height: 1.4,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            achievement.unlocked
                ? Icons.check_circle_rounded
                : Icons.lock_outline_rounded,
            color: achievement.unlocked
                ? const Color(0xFF27AE60)
                : Colors.grey,
          ),
        ],
      ),
    );
  }
}