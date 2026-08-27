import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/trivia_question.dart';

class AdminService {
  AdminService._();

  static final AdminService instance = AdminService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  bool? _cachedAdminStatus;

  User? get currentUser => _auth.currentUser;

  CollectionReference<Map<String, dynamic>> get _questions {
    return _firestore.collection('triviaQuestions');
  }

  Future<bool> isCurrentUserAdmin({
    bool refresh = false,
  }) async {
    if (!refresh && _cachedAdminStatus != null) {
      return _cachedAdminStatus!;
    }

    final user = _auth.currentUser;

    if (user == null) {
      _cachedAdminStatus = false;
      return false;
    }

    try {
      final document = await _firestore
          .collection('admins')
          .doc(user.uid)
          .get();

      final data = document.data();

      final isAdmin = document.exists &&
          data != null &&
          data['active'] == true;

      _cachedAdminStatus = isAdmin;

      return isAdmin;
    } catch (error) {
      _cachedAdminStatus = false;
      return false;
    }
  }

  void clearAdminCache() {
    _cachedAdminStatus = null;
  }

  Stream<List<TriviaQuestion>> getAllQuestions() {
    return _questions.snapshots().map(
      (snapshot) {
        final questions = snapshot.docs.map(
          (document) {
            return TriviaQuestion.fromMap(
              document.data(),
              id: document.id,
            );
          },
        ).toList();

        questions.sort(
          (a, b) {
            final categoryComparison =
                a.category.compareTo(b.category);

            if (categoryComparison != 0) {
              return categoryComparison;
            }

            final difficultyComparison =
                a.difficulty.compareTo(b.difficulty);

            if (difficultyComparison != 0) {
              return difficultyComparison;
            }

            return a.question.compareTo(b.question);
          },
        );

        return questions;
      },
    );
  }

  Future<void> addQuestion(
    TriviaQuestion question,
  ) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw StateError(
        'You must be logged in.',
      );
    }

    final isAdmin = await isCurrentUserAdmin();

    if (!isAdmin) {
      throw StateError(
        'Administrator access is required.',
      );
    }

    final document = _questions.doc();

    await document.set({
      ...question.toMap(),
      'id': document.id,
      'createdBy': user.uid,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateQuestion(
    TriviaQuestion question,
  ) async {
    if (question.id.isEmpty) {
      throw ArgumentError(
        'Question ID is missing.',
      );
    }

    final user = _auth.currentUser;

    if (user == null) {
      throw StateError(
        'You must be logged in.',
      );
    }

    final isAdmin = await isCurrentUserAdmin();

    if (!isAdmin) {
      throw StateError(
        'Administrator access is required.',
      );
    }

    await _questions.doc(question.id).update({
      ...question.toMap(),
      'updatedBy': user.uid,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> setQuestionActive({
    required String questionId,
    required bool isActive,
  }) async {
    if (questionId.isEmpty) {
      return;
    }

    final user = _auth.currentUser;

    if (user == null) {
      throw StateError(
        'You must be logged in.',
      );
    }

    final isAdmin = await isCurrentUserAdmin();

    if (!isAdmin) {
      throw StateError(
        'Administrator access is required.',
      );
    }

    await _questions.doc(questionId).update({
      'isActive': isActive,
      'updatedBy': user.uid,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<void> deleteQuestion(
    String questionId,
  ) async {
    if (questionId.isEmpty) {
      return;
    }

    final isAdmin = await isCurrentUserAdmin();

    if (!isAdmin) {
      throw StateError(
        'Administrator access is required.',
      );
    }

    await _questions.doc(questionId).delete();
  }
}