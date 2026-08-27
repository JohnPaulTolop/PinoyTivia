import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/leaderboard_entry.dart';
import '../models/quiz_result.dart';

class FirestoreService {
  FirestoreService._();

  static final FirestoreService instance = FirestoreService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User get _currentUser {
    final user = _auth.currentUser;

    if (user == null) {
      throw StateError(
        'No authenticated Firebase user.',
      );
    }

    return user;
  }

  DocumentReference<Map<String, dynamic>> get _userReference {
    return _firestore
        .collection('users')
        .doc(_currentUser.uid);
  }

  CollectionReference<Map<String, dynamic>> get _historyReference {
    return _userReference.collection(
      'quizHistory',
    );
  }

  DocumentReference<Map<String, dynamic>> get _leaderboardReference {
    return _firestore
        .collection('leaderboard')
        .doc(_currentUser.uid);
  }

  // ============================================================
  // SAVE COMPLETED QUIZ
  // ============================================================

  Future<void> saveQuizResult(
    QuizResult result,
  ) async {
    final user = _currentUser;

    final userRef = _userReference;
    final leaderboardRef = _leaderboardReference;

    // Generate the history document ID before starting transaction.
    final historyDocument = _historyReference.doc();

    await _firestore.runTransaction(
      (transaction) async {
        final userSnapshot = await transaction.get(
          userRef,
        );

        final currentData =
            userSnapshot.data() ?? <String, dynamic>{};

        final currentPoints =
            (currentData['totalPoints'] as num?)?.toInt() ?? 0;

        final currentQuizzes =
            (currentData['totalQuizzes'] as num?)?.toInt() ?? 0;

        final currentHighScore =
            (currentData['highScore'] as num?)?.toInt() ?? 0;

        final currentCorrectAnswers =
            (currentData['totalCorrectAnswers'] as num?)?.toInt() ?? 0;

        final currentQuestionsAnswered =
            (currentData['totalQuestionsAnswered'] as num?)?.toInt() ?? 0;

        final newTotalPoints =
            currentPoints + result.score;

        final newTotalQuizzes =
            currentQuizzes + 1;

        final newHighScore = max(
          currentHighScore,
          result.score,
        );

        final newCorrectAnswers =
            currentCorrectAnswers + result.correctAnswers;

        final newQuestionsAnswered =
            currentQuestionsAnswered + result.totalQuestions;

        final level =
            (newTotalPoints ~/ 1000) + 1;

        final rankTitle = _rankFromPoints(
          newTotalPoints,
        );

        // Save individual quiz attempt.
        transaction.set(
          historyDocument,
          {
            'id': historyDocument.id,
            'uid': user.uid,
            'category': result.category,
            'difficulty': result.difficulty,
            'score': result.score,
            'correctAnswers': result.correctAnswers,
            'incorrectAnswers':
                result.totalQuestions - result.correctAnswers,
            'totalQuestions': result.totalQuestions,
            'accuracy': result.accuracy,
            'completedAt': FieldValue.serverTimestamp(),
          },
        );

        // Update private student profile.
        transaction.set(
          userRef,
          {
            'totalPoints': newTotalPoints,
            'totalQuizzes': newTotalQuizzes,
            'highScore': newHighScore,
            'totalCorrectAnswers': newCorrectAnswers,
            'totalQuestionsAnswered': newQuestionsAnswered,
            'updatedAt': FieldValue.serverTimestamp(),
          },
          SetOptions(
            merge: true,
          ),
        );

        // Update public leaderboard data.
        transaction.set(
          leaderboardRef,
          {
            'uid': user.uid,
            'name': currentData['name'] ??
                user.displayName ??
                'Student',
            'totalPoints': newTotalPoints,
            'totalQuizzes': newTotalQuizzes,
            'highScore': newHighScore,
            'level': level,
            'rankTitle': rankTitle,
            'updatedAt': FieldValue.serverTimestamp(),
          },
          SetOptions(
            merge: true,
          ),
        );
      },
    );
  }

  // ============================================================
  // LOAD QUIZ HISTORY
  // ============================================================

  Future<List<QuizResult>> getQuizHistory() async {
    final snapshot = await _historyReference
        .orderBy(
          'completedAt',
          descending: true,
        )
        .get();

    return snapshot.docs.map(
      (document) {
        final data = document.data();

        final completedAt = data['completedAt'];

        DateTime date;

        if (completedAt is Timestamp) {
          date = completedAt.toDate();
        } else {
          date = DateTime.now();
        }

        return QuizResult(
          category:
              data['category'] as String? ?? 'Unknown',
          difficulty:
              data['difficulty'] as String? ?? 'Easy',
          score:
              (data['score'] as num?)?.toInt() ?? 0,
          correctAnswers:
              (data['correctAnswers'] as num?)?.toInt() ?? 0,
          totalQuestions:
              (data['totalQuestions'] as num?)?.toInt() ?? 0,
          completedAt: date,
        );
      },
    ).toList();
  }

  // ============================================================
  // LEADERBOARD
  // ============================================================

  Stream<List<LeaderboardEntry>> getLeaderboard({
    int limit = 20,
  }) {
    return _firestore
        .collection('leaderboard')
        .orderBy(
          'totalPoints',
          descending: true,
        )
        .limit(limit)
        .snapshots()
        .map(
      (snapshot) {
        return snapshot.docs.map(
          (document) {
            final data = document.data();

            return LeaderboardEntry(
              uid: data['uid'] as String? ?? document.id,
              name: data['name'] as String? ?? 'Student',
              totalPoints:
                  (data['totalPoints'] as num?)?.toInt() ?? 0,
              totalQuizzes:
                  (data['totalQuizzes'] as num?)?.toInt() ?? 0,
              highScore:
                  (data['highScore'] as num?)?.toInt() ?? 0,
              level:
                  (data['level'] as num?)?.toInt() ?? 1,
              rankTitle:
                  data['rankTitle'] as String? ?? 'Trivia Beginner',
            );
          },
        ).toList();
      },
    );
  }

  // ============================================================
  // UPDATE STUDENT NAME
  // ============================================================

  Future<void> updateStudentName(
    String name,
  ) async {
    final cleanedName = name.trim();

    if (cleanedName.isEmpty) {
      return;
    }

    final user = _currentUser;

    await user.updateDisplayName(
      cleanedName,
    );

    final batch = _firestore.batch();

    batch.set(
      _userReference,
      {
        'name': cleanedName,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(
        merge: true,
      ),
    );

    batch.set(
      _leaderboardReference,
      {
        'uid': user.uid,
        'name': cleanedName,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(
        merge: true,
      ),
    );

    await batch.commit();
  }

  // ============================================================
  // RESET STUDENT PROGRESS
  // ============================================================

  Future<void> resetProgress() async {
    final historySnapshot =
        await _historyReference.get();

    // Firestore batches have write limits,
    // so delete history in smaller chunks.
    const int batchSize = 400;

    for (
      int start = 0;
      start < historySnapshot.docs.length;
      start += batchSize
    ) {
      final batch = _firestore.batch();

      final end = min(
        start + batchSize,
        historySnapshot.docs.length,
      );

      for (int index = start; index < end; index++) {
        batch.delete(
          historySnapshot.docs[index].reference,
        );
      }

      await batch.commit();
    }

    final resetBatch = _firestore.batch();

    resetBatch.set(
      _userReference,
      {
        'totalPoints': 0,
        'totalQuizzes': 0,
        'highScore': 0,
        'totalCorrectAnswers': 0,
        'totalQuestionsAnswered': 0,
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(
        merge: true,
      ),
    );

    resetBatch.set(
      _leaderboardReference,
      {
        'uid': _currentUser.uid,
        'name':
            _currentUser.displayName ?? 'Student',
        'totalPoints': 0,
        'totalQuizzes': 0,
        'highScore': 0,
        'level': 1,
        'rankTitle': 'Trivia Beginner',
        'updatedAt': FieldValue.serverTimestamp(),
      },
      SetOptions(
        merge: true,
      ),
    );

    await resetBatch.commit();
  }

  String _rankFromPoints(
    int points,
  ) {
    if (points >= 10000) {
      return 'Pinoy Trivia Master';
    }

    if (points >= 6000) {
      return 'Trivia Expert';
    }

    if (points >= 3000) {
      return 'Knowledge Seeker';
    }

    if (points >= 1000) {
      return 'Filipino Explorer';
    }

    return 'Trivia Beginner';
  }
}