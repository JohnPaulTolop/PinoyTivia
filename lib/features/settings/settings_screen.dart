import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../services/app_data.dart';
import '../../services/firestore_service.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: AppData.instance,
          builder: (context, child) {
            return ListView(
              padding: const EdgeInsets.all(20),
              children: [
                // =====================================================
                // APPEARANCE
                // =====================================================

                _buildSectionTitle(
                  'Appearance',
                ),

                const SizedBox(height: 10),

                _SettingsContainer(
                  child: SwitchListTile(
                    value: AppData.instance.isDarkMode,
                    activeThumbColor: AppColors.primaryBlue,
                    onChanged: (value) {
                      AppData.instance.setDarkMode(
                        value,
                      );
                    },
                    secondary: const Icon(
                      Icons.dark_mode_rounded,
                      color: AppColors.primaryBlue,
                    ),
                    title: const Text(
                      'Dark Mode',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    subtitle: const Text(
                      'Use a darker appearance for Pinoy Trivia.',
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                // =====================================================
                // GAME PREFERENCES
                // =====================================================

                _buildSectionTitle(
                  'Game Preferences',
                ),

                const SizedBox(height: 10),

                _SettingsContainer(
                  child: Column(
                    children: [
                      SwitchListTile(
                        value: AppData.instance.notificationsEnabled,
                        activeThumbColor: AppColors.primaryBlue,
                        onChanged: (value) {
                          AppData.instance.setNotifications(
                            value,
                          );
                        },
                        secondary: const Icon(
                          Icons.notifications_rounded,
                          color: AppColors.primaryBlue,
                        ),
                        title: const Text(
                          'Notifications',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        subtitle: const Text(
                          'Receive trivia reminders and challenge updates.',
                        ),
                      ),

                      const Divider(
                        height: 1,
                      ),

                      SwitchListTile(
                        value: AppData.instance.soundEffectsEnabled,
                        activeThumbColor: AppColors.primaryBlue,
                        onChanged: (value) {
                          AppData.instance.setSoundEffects(
                            value,
                          );
                        },
                        secondary: const Icon(
                          Icons.volume_up_rounded,
                          color: AppColors.primaryBlue,
                        ),
                        title: const Text(
                          'Sound Effects',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        subtitle: const Text(
                          'Play sounds for correct and incorrect answers.',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // =====================================================
                // ACCOUNT / PROGRESS
                // =====================================================

                _buildSectionTitle(
                  'Progress',
                ),

                const SizedBox(height: 10),

                _SettingsContainer(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.star_rounded,
                          color: AppColors.gold,
                        ),
                        title: const Text(
                          'Total Points',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        trailing: Text(
                          '${AppData.instance.totalPoints}',
                          style: const TextStyle(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),

                      const Divider(
                        height: 1,
                      ),

                      ListTile(
                        leading: const Icon(
                          Icons.quiz_rounded,
                          color: AppColors.primaryBlue,
                        ),
                        title: const Text(
                          'Quizzes Completed',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        trailing: Text(
                          '${AppData.instance.totalQuizzes}',
                          style: const TextStyle(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),

                      const Divider(
                        height: 1,
                      ),

                      ListTile(
                        leading: const Icon(
                          Icons.military_tech_rounded,
                          color: AppColors.primaryBlue,
                        ),
                        title: const Text(
                          'Current Level',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        trailing: Text(
                          '${AppData.instance.level}',
                          style: const TextStyle(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // =====================================================
                // DATA MANAGEMENT
                // =====================================================

                _buildSectionTitle(
                  'Data Management',
                ),

                const SizedBox(height: 10),

                _SettingsContainer(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(
                          Icons.history_rounded,
                          color: AppColors.primaryBlue,
                        ),
                        title: const Text(
                          'Quiz History',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        subtitle: Text(
                          '${AppData.instance.totalQuizzes} saved quiz results',
                        ),
                      ),

                      const Divider(
                        height: 1,
                      ),

                      ListTile(
                        leading: const Icon(
                          Icons.delete_forever_rounded,
                          color: AppColors.primaryRed,
                        ),
                        title: const Text(
                          'Reset Quiz Progress',
                          style: TextStyle(
                            color: AppColors.primaryRed,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        subtitle: const Text(
                          'Delete scores, quiz history, level progress, and related achievements.',
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: AppColors.primaryRed,
                          size: 16,
                        ),
                        onTap: () {
                          _showResetDialog(
                            context,
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // =====================================================
                // APP INFORMATION
                // =====================================================

                _buildSectionTitle(
                  'App Information',
                ),

                const SizedBox(height: 10),

                _SettingsContainer(
                  child: Column(
                    children: [
                      const ListTile(
                        leading: Icon(
                          Icons.info_outline_rounded,
                          color: AppColors.primaryBlue,
                        ),
                        title: Text(
                          'Version',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        trailing: Text(
                          '1.0.0',
                        ),
                      ),

                      const Divider(
                        height: 1,
                      ),

                      ListTile(
                        leading: const Icon(
                          Icons.school_rounded,
                          color: AppColors.primaryBlue,
                        ),
                        title: const Text(
                          'About Pinoy Trivia',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        subtitle: const Text(
                          'Learn. Play. Be Proud.',
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 16,
                        ),
                        onTap: () {
                          _showAboutDialog(
                            context,
                          );
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 35),

                const Center(
                  child: Text(
                    'PINOY TRIVIA',
                    style: TextStyle(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),

                const SizedBox(height: 5),

                const Center(
                  child: Text(
                    'LEARN. PLAY. BE PROUD.',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 10,
                      letterSpacing: 1.3,
                    ),
                  ),
                ),

                const SizedBox(height: 30),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(
    String title,
  ) {
    return Text(
      title,
      style: const TextStyle(
        color: AppColors.primaryBlue,
        fontSize: 15,
        fontWeight: FontWeight.w900,
      ),
    );
  }

  void _showResetDialog(
    BuildContext context,
  ) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        bool isResetting = false;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.primaryRed,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Reset Quiz Progress?',
                    ),
                  ),
                ],
              ),
              content: const Text(
                'This will permanently remove your quiz history and reset your points, high score, level progress, and related achievements.\n\nYour account will not be deleted.',
              ),
              actions: [
                TextButton(
                  onPressed: isResetting
                      ? null
                      : () {
                          Navigator.pop(
                            dialogContext,
                          );
                        },
                  child: const Text(
                    'Cancel',
                  ),
                ),

                FilledButton(
                  onPressed: isResetting
                      ? null
                      : () async {
                          setDialogState(() {
                            isResetting = true;
                          });

                          try {
                            // Delete/reset progress from Firestore.
                            await FirestoreService.instance.resetProgress();

                            // Reset current local app state.
                            AppData.instance.clearQuizHistory();

                            if (!dialogContext.mounted) {
                              return;
                            }

                            Navigator.pop(
                              dialogContext,
                            );

                            if (!context.mounted) {
                              return;
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Quiz progress has been reset successfully.',
                                ),
                              ),
                            );
                          } catch (error) {
                            if (!dialogContext.mounted) {
                              return;
                            }

                            setDialogState(() {
                              isResetting = false;
                            });

                            if (!context.mounted) {
                              return;
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Unable to reset your progress. Please try again.',
                                ),
                              ),
                            );
                          }
                        },
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primaryRed,
                  ),
                  child: isResetting
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Reset Progress',
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAboutDialog(
    BuildContext context,
  ) {
    showAboutDialog(
      context: context,
      applicationName: 'Pinoy Trivia',
      applicationVersion: '1.0.0',
      applicationIcon: const Icon(
        Icons.wb_sunny_rounded,
        size: 48,
        color: AppColors.yellow,
      ),
      children: const [
        SizedBox(height: 10),

        Text(
          'Pinoy Trivia is an educational mobile application designed to help students learn about the Philippines through interactive trivia.',
        ),

        SizedBox(height: 12),

        Text(
          'Topics include Philippine history, geography, culture, language, literature, national symbols, famous Filipinos, and general knowledge.',
        ),

        SizedBox(height: 15),

        Text(
          'Learn. Play. Be Proud.',
          style: TextStyle(
            color: AppColors.primaryBlue,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _SettingsContainer extends StatelessWidget {
  final Widget child;

  const _SettingsContainer({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context).colorScheme.outlineVariant,
        ),
      ),
      child: child,
    );
  }
}