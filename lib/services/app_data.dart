import 'package:flutter/material.dart';

import '../models/achievement.dart';
import '../models/quiz_result.dart';

class AppData extends ChangeNotifier {
  AppData._();

  static final AppData instance = AppData._();

  String _studentName = 'Student';

  bool _isDarkMode = false;
  bool _notificationsEnabled = true;
  bool _soundEffectsEnabled = true;

  final List<QuizResult> _quizHistory = [];

  String get studentName => _studentName;

  bool get isDarkMode => _isDarkMode;

  bool get notificationsEnabled =>
      _notificationsEnabled;

  bool get soundEffectsEnabled =>
      _soundEffectsEnabled;

  List<QuizResult> get quizHistory =>
      List.unmodifiable(_quizHistory);

  // ============================================================
  // USER SESSION
  // ============================================================

  void loadUserSession({
    required String name,
    required List<QuizResult> quizHistory,
  }) {
    _studentName = name.trim().isEmpty
        ? 'Student'
        : name.trim();

    _quizHistory
      ..clear()
      ..addAll(quizHistory);

    notifyListeners();
  }

  void clearUserSession() {
    _studentName = 'Student';
    _quizHistory.clear();

    notifyListeners();
  }

  void setStudentName(
    String name,
  ) {
    final cleanedName = name.trim();

    if (cleanedName.isEmpty) {
      return;
    }

    _studentName = cleanedName;

    notifyListeners();
  }

  // ============================================================
  // QUIZ STATISTICS
  // ============================================================

  int get totalPoints {
    return _quizHistory.fold(
      0,
      (total, result) =>
          total + result.score,
    );
  }

  int get totalQuizzes {
    return _quizHistory.length;
  }

  int get highScore {
    if (_quizHistory.isEmpty) {
      return 0;
    }

    int highest = 0;

    for (final result in _quizHistory) {
      if (result.score > highest) {
        highest = result.score;
      }
    }

    return highest;
  }

  int get totalCorrectAnswers {
    return _quizHistory.fold(
      0,
      (total, result) =>
          total + result.correctAnswers,
    );
  }

  int get totalQuestionsAnswered {
    return _quizHistory.fold(
      0,
      (total, result) =>
          total + result.totalQuestions,
    );
  }

  int get overallAccuracy {
    if (totalQuestionsAnswered == 0) {
      return 0;
    }

    return ((totalCorrectAnswers /
                totalQuestionsAnswered) *
            100)
        .round();
  }

  // ============================================================
  // LEVEL
  // ============================================================

  static const int pointsPerLevel = 1000;

  int get level {
    return (totalPoints ~/ pointsPerLevel) + 1;
  }

  int get currentLevelXP {
    return totalPoints % pointsPerLevel;
  }

  int get xpNeededForNextLevel {
    return pointsPerLevel;
  }

  double get levelProgress {
    return currentLevelXP / pointsPerLevel;
  }

  String get rankTitle {
    if (totalPoints >= 10000) {
      return 'Pinoy Trivia Master';
    }

    if (totalPoints >= 6000) {
      return 'Trivia Expert';
    }

    if (totalPoints >= 3000) {
      return 'Knowledge Seeker';
    }

    if (totalPoints >= 1000) {
      return 'Filipino Explorer';
    }

    return 'Trivia Beginner';
  }

  // ============================================================
  // ACHIEVEMENTS
  // ============================================================

  List<Achievement> get achievements {
    final hasPerfectScore = _quizHistory.any(
      (result) =>
          result.accuracy == 100,
    );

    final playedHistory = _quizHistory.any(
      (result) =>
          result.category ==
          'Philippine History',
    );

    return [
      Achievement(
        title: 'First Steps',
        description:
            'Complete your first trivia quiz.',
        icon: Icons.flag_rounded,
        unlocked: totalQuizzes >= 1,
      ),
      Achievement(
        title: 'Quiz Explorer',
        description:
            'Complete 5 trivia quizzes.',
        icon: Icons.explore_rounded,
        unlocked: totalQuizzes >= 5,
      ),
      Achievement(
        title: 'Trivia Fan',
        description:
            'Complete 10 trivia quizzes.',
        icon: Icons.quiz_rounded,
        unlocked: totalQuizzes >= 10,
      ),
      Achievement(
        title: 'Perfect Score',
        description:
            'Get 100% accuracy in a quiz.',
        icon:
            Icons.workspace_premium_rounded,
        unlocked: hasPerfectScore,
      ),
      Achievement(
        title: 'Sharp Mind',
        description:
            'Maintain at least 80% overall accuracy after 3 quizzes.',
        icon:
            Icons.psychology_rounded,
        unlocked:
            totalQuizzes >= 3 &&
                overallAccuracy >= 80,
      ),
      Achievement(
        title: 'High Scorer',
        description:
            'Earn at least 1,000 points in a single quiz.',
        icon:
            Icons.emoji_events_rounded,
        unlocked: highScore >= 1000,
      ),
      Achievement(
        title: 'Point Collector',
        description:
            'Earn a total of 5,000 points.',
        icon: Icons.star_rounded,
        unlocked:
            totalPoints >= 5000,
      ),
      Achievement(
        title: 'History Buff',
        description:
            'Complete a Philippine History quiz.',
        icon:
            Icons.account_balance_rounded,
        unlocked: playedHistory,
      ),
    ];
  }

  int get unlockedAchievements {
    return achievements
        .where(
          (achievement) =>
              achievement.unlocked,
        )
        .length;
  }

  // ============================================================
  // LOCAL STATE UPDATES
  // ============================================================

  void addQuizResult(
    QuizResult result,
  ) {
    _quizHistory.insert(
      0,
      result,
    );

    notifyListeners();
  }

  void replaceQuizHistory(
    List<QuizResult> history,
  ) {
    _quizHistory
      ..clear()
      ..addAll(history);

    notifyListeners();
  }

  void clearQuizHistory() {
    _quizHistory.clear();

    notifyListeners();
  }

  void setDarkMode(
    bool value,
  ) {
    _isDarkMode = value;

    notifyListeners();
  }

  void setNotifications(
    bool value,
  ) {
    _notificationsEnabled = value;

    notifyListeners();
  }

  void setSoundEffects(
    bool value,
  ) {
    _soundEffectsEnabled = value;

    notifyListeners();
  }
}