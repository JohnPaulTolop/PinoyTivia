import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../services/admin_service.dart';
import '../../services/app_data.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../achievements/achievements_screen.dart';
import '../admin/question_management_screen.dart';
import '../auth/login_screen.dart';
import '../settings/settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: AppData.instance,
          builder: (context, child) {
            return SingleChildScrollView(
              padding: const EdgeInsets.only(
                bottom: 30,
              ),
              child: Column(
                children: [
                  _buildProfileHeader(
                    context,
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Column(
                      children: [
                        _buildLevelCard(
                          context,
                        ),

                        const SizedBox(height: 18),

                        _buildStats(
                          context,
                        ),

                        const SizedBox(height: 24),

                        _buildMenuCard(
                          context,
                        ),

                        const SizedBox(height: 20),

                        _buildLogoutButton(
                          context,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // PROFILE HEADER
  // ============================================================

  Widget _buildProfileHeader(
    BuildContext context,
  ) {
    final email =
        AuthService.instance.currentUser?.email ??
            'No email available';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        20,
        28,
        20,
        30,
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
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          // PROFILE AVATAR
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.yellow,
                width: 4,
              ),
            ),
            child: Center(
              child: Text(
                _getInitial(),
                style: const TextStyle(
                  color: AppColors.primaryBlue,
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),

          const SizedBox(height: 15),

          // NAME
          Text(
            AppData.instance.studentName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 5),

          // EMAIL
          Text(
            email,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 7),

          // LEVEL
          Text(
            'Level ${AppData.instance.level} • ${AppData.instance.rankTitle}',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.yellow,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 8),

          // EDIT PROFILE NAME
          TextButton.icon(
            onPressed: () {
              _showEditNameDialog(
                context,
              );
            },
            icon: const Icon(
              Icons.edit_rounded,
              size: 17,
              color: Colors.white,
            ),
            label: const Text(
              'Edit Profile Name',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LEVEL CARD
  // ============================================================

  Widget _buildLevelCard(
    BuildContext context,
  ) {
    final remainingXp =
        AppData.instance.xpNeededForNextLevel -
            AppData.instance.currentLevelXP;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Theme.of(context)
              .colorScheme
              .outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: AppColors.lightBlue,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.military_tech_rounded,
                  color: AppColors.primaryBlue,
                ),
              ),

              const SizedBox(width: 13),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Level ${AppData.instance.level}',
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                      ),
                    ),

                    const SizedBox(height: 2),

                    Text(
                      AppData.instance.rankTitle,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),

              Text(
                '${AppData.instance.currentLevelXP}/'
                '${AppData.instance.xpNeededForNextLevel} XP',
                style: const TextStyle(
                  color: AppColors.primaryBlue,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: LinearProgressIndicator(
              value: AppData.instance.levelProgress,
              minHeight: 10,
              backgroundColor: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest,
              color: AppColors.primaryBlue,
            ),
          ),

          const SizedBox(height: 10),

          Text(
            '$remainingXp more points until '
            'Level ${AppData.instance.level + 1}',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // STATISTICS
  // ============================================================

  Widget _buildStats(
    BuildContext context,
  ) {
    return Row(
      children: [
        Expanded(
          child: _ProfileStat(
            value:
                '${AppData.instance.totalPoints}',
            label: 'Points',
            icon: Icons.star_rounded,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _ProfileStat(
            value:
                '${AppData.instance.totalQuizzes}',
            label: 'Quizzes',
            icon: Icons.quiz_rounded,
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: _ProfileStat(
            value:
                '${AppData.instance.overallAccuracy}%',
            label: 'Accuracy',
            icon: Icons.track_changes_rounded,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // MENU
  // ============================================================

  Widget _buildMenuCard(
    BuildContext context,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Theme.of(context)
              .colorScheme
              .outlineVariant,
        ),
      ),
      child: Column(
        children: [
          // ACHIEVEMENTS
          _ProfileMenuItem(
            icon: Icons.emoji_events_rounded,
            title: 'Achievements',
            subtitle:
                '${AppData.instance.unlockedAchievements}/'
                '${AppData.instance.achievements.length} unlocked',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      const AchievementsScreen(),
                ),
              );
            },
          ),

          const Divider(height: 1),

          // HIGH SCORE
          _ProfileMenuItem(
            icon: Icons.workspace_premium_rounded,
            title: 'High Score',
            subtitle:
                '${AppData.instance.highScore} points',
            onTap: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                SnackBar(
                  content: Text(
                    'Your current high score is '
                    '${AppData.instance.highScore} points.',
                  ),
                ),
              );
            },
          ),

          const Divider(height: 1),

          // CORRECT ANSWERS
          _ProfileMenuItem(
            icon: Icons.check_circle_outline_rounded,
            title: 'Correct Answers',
            subtitle:
                '${AppData.instance.totalCorrectAnswers} '
                'correct answers',
            onTap: () {
              ScaffoldMessenger.of(context)
                  .showSnackBar(
                SnackBar(
                  content: Text(
                    'You have answered '
                    '${AppData.instance.totalCorrectAnswers} '
                    'questions correctly.',
                  ),
                ),
              );
            },
          ),

          // ======================================================
          // ADMIN / TEACHER ONLY
          // ======================================================

          FutureBuilder<bool>(
            future: AdminService.instance
                .isCurrentUserAdmin(),
            builder: (context, snapshot) {
              if (snapshot.data != true) {
                return const SizedBox.shrink();
              }

              return Column(
                children: [
                  const Divider(height: 1),

                  _ProfileMenuItem(
                    icon: Icons
                        .admin_panel_settings_rounded,
                    title: 'Question Management',
                    subtitle:
                        'Admin / Teacher tools',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              const QuestionManagementScreen(),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),

          const Divider(height: 1),

          // SETTINGS
          _ProfileMenuItem(
            icon: Icons.settings_rounded,
            title: 'Settings',
            subtitle:
                'App preferences and account settings',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) =>
                      const SettingsScreen(),
                ),
              );
            },
          ),

          const Divider(height: 1),

          // ABOUT
          _ProfileMenuItem(
            icon: Icons.info_outline_rounded,
            title: 'About Pinoy Trivia',
            subtitle: 'Learn. Play. Be Proud.',
            onTap: () {
              _showAboutDialog(
                context,
              );
            },
          ),
        ],
      ),
    );
  }

  // ============================================================
  // LOGOUT BUTTON
  // ============================================================

  Widget _buildLogoutButton(
    BuildContext context,
  ) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {
          _showLogoutDialog(
            context,
          );
        },
        style: OutlinedButton.styleFrom(
          minimumSize: const Size(
            double.infinity,
            54,
          ),
          foregroundColor:
              AppColors.primaryRed,
          side: const BorderSide(
            color: AppColors.primaryRed,
          ),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(14),
          ),
        ),
        icon: const Icon(
          Icons.logout_rounded,
        ),
        label: const Text(
          'Log Out',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // EDIT PROFILE NAME
  // ============================================================

  Future<void> _showEditNameDialog(
    BuildContext context,
  ) async {
    final updatedName =
        await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return _EditProfileNameDialog(
          initialName:
              AppData.instance.studentName,
        );
      },
    );

    if (updatedName == null) {
      return;
    }

    if (!context.mounted) {
      return;
    }

    // IMPORTANT:
    // Update AppData AFTER the dialog has been closed.
    AppData.instance.setStudentName(
      updatedName,
    );

    ScaffoldMessenger.of(context)
        .hideCurrentSnackBar();

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          'Profile name updated successfully.',
        ),
      ),
    );
  }

  // ============================================================
  // LOGOUT
  // ============================================================

  void _showLogoutDialog(
    BuildContext context,
  ) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        bool isLoggingOut = false;

        return StatefulBuilder(
          builder: (
            dialogBuildContext,
            setDialogState,
          ) {
            return AlertDialog(
              title: const Text(
                'Log Out?',
              ),
              content: const Text(
                'Are you sure you want to log out of Pinoy Trivia?',
              ),
              actions: [
                TextButton(
                  onPressed: isLoggingOut
                      ? null
                      : () {
                          Navigator.of(
                            dialogContext,
                          ).pop();
                        },
                  child: const Text(
                    'Cancel',
                  ),
                ),

                FilledButton(
                  style:
                      FilledButton.styleFrom(
                    minimumSize:
                        const Size(
                      90,
                      44,
                    ),
                    backgroundColor:
                        AppColors.primaryRed,
                  ),
                  onPressed:
                      isLoggingOut
                          ? null
                          : () async {
                              setDialogState(
                                () {
                                  isLoggingOut =
                                      true;
                                },
                              );

                              try {
                                await AuthService
                                    .instance
                                    .logout();

                                AdminService
                                    .instance
                                    .clearAdminCache();

                                AppData.instance
                                    .clearUserSession();

                                if (!dialogBuildContext
                                    .mounted) {
                                  return;
                                }

                                Navigator.of(
                                  dialogBuildContext,
                                ).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        const LoginScreen(),
                                  ),
                                  (route) =>
                                      false,
                                );
                              } catch (error) {
                                if (!dialogBuildContext
                                    .mounted) {
                                  return;
                                }

                                setDialogState(
                                  () {
                                    isLoggingOut =
                                        false;
                                  },
                                );

                                ScaffoldMessenger.of(
                                  dialogBuildContext,
                                ).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Unable to log out. '
                                      'Please try again.',
                                    ),
                                  ),
                                );
                              }
                            },
                  child: isLoggingOut
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            color:
                                Colors.white,
                          ),
                        )
                      : const Text(
                          'Log Out',
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  // ============================================================
  // ABOUT
  // ============================================================

  void _showAboutDialog(
    BuildContext context,
  ) {
    showAboutDialog(
      context: context,
      applicationName:
          'Pinoy Trivia',
      applicationVersion:
          '1.0.0',
      applicationIcon:
          const Icon(
        Icons.wb_sunny_rounded,
        size: 45,
        color: AppColors.yellow,
      ),
      children: const [
        Text(
          'Pinoy Trivia is an educational Filipino trivia '
          'application designed for students.',
        ),

        SizedBox(height: 10),

        Text(
          'The application helps students learn about '
          'Philippine history, geography, culture, language, '
          'literature, national symbols, famous Filipinos, '
          'and general Filipino knowledge through '
          'interactive quizzes.',
        ),

        SizedBox(height: 10),

        Text(
          'Learn. Play. Be Proud.',
          style: TextStyle(
            color:
                AppColors.primaryBlue,
            fontWeight:
                FontWeight.w900,
          ),
        ),
      ],
    );
  }

  String _getInitial() {
    final name =
        AppData.instance.studentName.trim();

    if (name.isEmpty) {
      return 'S';
    }

    return name[0].toUpperCase();
  }
}

// ============================================================
// EDIT PROFILE NAME DIALOG
// ============================================================

class _EditProfileNameDialog
    extends StatefulWidget {
  final String initialName;

  const _EditProfileNameDialog({
    required this.initialName,
  });

  @override
  State<_EditProfileNameDialog>
      createState() =>
          _EditProfileNameDialogState();
}

class _EditProfileNameDialogState
    extends State<_EditProfileNameDialog> {
  late final TextEditingController
      _nameController;

  bool _isSaving = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _nameController =
        TextEditingController(
      text: widget.initialName,
    );
  }

  @override
  void dispose() {
    // The controller is now disposed ONLY when
    // the dialog widget itself is really removed.
    _nameController.dispose();

    super.dispose();
  }

  Future<void> _saveName() async {
    if (_isSaving) {
      return;
    }

    final name =
        _nameController.text.trim();

    FocusScope.of(context).unfocus();

    if (name.isEmpty) {
      setState(() {
        _errorMessage =
            'Please enter your name.';
      });
      return;
    }

    if (name.length < 2) {
      setState(() {
        _errorMessage =
            'Name must contain at least 2 characters.';
      });
      return;
    }

    if (name.length > 50) {
      setState(() {
        _errorMessage =
            'Name must not exceed 50 characters.';
      });
      return;
    }

    // If name didn't actually change,
    // simply close the dialog.
    if (name == widget.initialName.trim()) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = null;
    });

    try {
      // Updates:
      // Firebase Auth displayName
      // Firestore user profile
      // Firestore leaderboard name
      await FirestoreService.instance
          .updateStudentName(
        name,
      );

      if (!mounted) {
        return;
      }

      // Return the updated name to ProfileScreen.
      Navigator.of(context).pop(
        name,
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isSaving = false;
        _errorMessage =
            'Unable to update your name. '
            'Please check your internet connection '
            'and try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(
            Icons.edit_rounded,
            color: AppColors.primaryBlue,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Edit Profile Name',
            ),
          ),
        ],
      ),

      content: SizedBox(
        width: 400,
        child: Column(
          mainAxisSize:
              MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            TextField(
              controller:
                  _nameController,
              enabled: !_isSaving,
              autofocus: true,
              textCapitalization:
                  TextCapitalization.words,
              textInputAction:
                  TextInputAction.done,
              maxLength: 50,
              autofillHints:
                  const [
                AutofillHints.name,
              ],
              onSubmitted: (_) {
                if (!_isSaving) {
                  _saveName();
                }
              },
              decoration:
                  InputDecoration(
                labelText:
                    'Student Name',
                hintText:
                    'Enter your name',
                prefixIcon:
                    const Icon(
                  Icons
                      .person_outline_rounded,
                ),
                errorText:
                    _errorMessage,
              ),
            ),

            const SizedBox(height: 4),

            const Text(
              'This name will also appear on the leaderboard.',
              style: TextStyle(
                color:
                    AppColors.textSecondary,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),

      actions: [
        TextButton(
          onPressed: _isSaving
              ? null
              : () {
                  FocusScope.of(
                    context,
                  ).unfocus();

                  Navigator.of(
                    context,
                  ).pop();
                },
          child: const Text(
            'Cancel',
          ),
        ),

        FilledButton(
          // Override the app-wide infinite-width
          // FilledButton style inside dialogs.
          style:
              FilledButton.styleFrom(
            minimumSize:
                const Size(
              90,
              44,
            ),
          ),
          onPressed:
              _isSaving
                  ? null
                  : _saveName,
          child: _isSaving
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child:
                      CircularProgressIndicator(
                    strokeWidth: 2,
                    color:
                        Colors.white,
                  ),
                )
              : const Text(
                  'Save',
                ),
        ),
      ],
    );
  }
}

// ============================================================
// PROFILE STAT CARD
// ============================================================

class _ProfileStat extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;

  const _ProfileStat({
    required this.value,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        vertical: 17,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surface,
        borderRadius:
            BorderRadius.circular(18),
        border: Border.all(
          color: Theme.of(context)
              .colorScheme
              .outlineVariant,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color:
                AppColors.primaryBlue,
          ),

          const SizedBox(height: 7),

          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight:
                  FontWeight.w900,
            ),
          ),

          const SizedBox(height: 3),

          Text(
            label,
            textAlign:
                TextAlign.center,
            style: const TextStyle(
              color:
                  AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================================
// PROFILE MENU ITEM
// ============================================================

class _ProfileMenuItem
    extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,

      leading: Container(
        width: 43,
        height: 43,
        decoration: BoxDecoration(
          color:
              AppColors.lightBlue,
          borderRadius:
              BorderRadius.circular(
            12,
          ),
        ),
        child: Icon(
          icon,
          color:
              AppColors.primaryBlue,
        ),
      ),

      title: Text(
        title,
        style: const TextStyle(
          fontWeight:
              FontWeight.w800,
        ),
      ),

      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 11,
          color:
              AppColors.textSecondary,
        ),
      ),

      trailing: const Icon(
        Icons.arrow_forward_ios_rounded,
        size: 16,
      ),
    );
  }
}