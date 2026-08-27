class LeaderboardEntry {
  final String uid;
  final String name;
  final int totalPoints;
  final int totalQuizzes;
  final int highScore;
  final int level;
  final String rankTitle;

  const LeaderboardEntry({
    required this.uid,
    required this.name,
    required this.totalPoints,
    required this.totalQuizzes,
    required this.highScore,
    required this.level,
    required this.rankTitle,
  });
}