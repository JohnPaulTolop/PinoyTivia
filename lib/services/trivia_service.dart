import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/trivia_data.dart';
import '../models/trivia_question.dart';

class TriviaService {
  TriviaService._();

  static final TriviaService instance = TriviaService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _questionsCollection {
    return _firestore.collection('triviaQuestions');
  }

  Future<List<TriviaQuestion>> getQuestions({
    required String category,
    required String difficulty,
  }) async {
    try {
      final snapshot = await _questionsCollection
          .where(
            'category',
            isEqualTo: category,
          )
          .where(
            'difficulty',
            isEqualTo: difficulty,
          )
          .get();

      final questions = snapshot.docs
          .where(
            (document) {
              final data = document.data();

              return data['isActive'] != false;
            },
          )
          .map(
            (document) => TriviaQuestion.fromMap(
              document.data(),
              id: document.id,
            ),
          )
          .where(
            _isValidQuestion,
          )
          .toList();

      if (questions.isNotEmpty) {
        questions.shuffle();

        return questions;
      }
    } catch (error) {
      // Firebase unavailable.
      // Fall through to the local question bank.
    }

    return TriviaData.getQuestions(
      category: category,
      difficulty: difficulty,
    );
  }

  Future<List<TriviaQuestion>> getDailyQuestions() async {
    List<TriviaQuestion> questions = [];

    try {
      final snapshot = await _questionsCollection.get();

      questions = snapshot.docs
          .where(
            (document) {
              final data = document.data();

              return data['isActive'] != false;
            },
          )
          .map(
            (document) => TriviaQuestion.fromMap(
              document.data(),
              id: document.id,
            ),
          )
          .where(
            _isValidQuestion,
          )
          .toList();
    } catch (error) {
      questions = [];
    }

    if (questions.isEmpty) {
      questions = List<TriviaQuestion>.from(
        TriviaData.questions,
      );
    }

    if (questions.isEmpty) {
      return [];
    }

    final now = DateTime.now();

    final seed =
        (now.year * 10000) +
        (now.month * 100) +
        now.day;

    final random = Random(seed);

    questions.shuffle(
      random,
    );

    return questions.take(10).toList();
  }

  bool _isValidQuestion(
    TriviaQuestion question,
  ) {
    if (question.question.trim().isEmpty) {
      return false;
    }

    if (question.category.trim().isEmpty) {
      return false;
    }

    if (question.difficulty.trim().isEmpty) {
      return false;
    }

    if (question.choices.length < 2) {
      return false;
    }

    if (question.correctAnswerIndex < 0 ||
        question.correctAnswerIndex >= question.choices.length) {
      return false;
    }

    return true;
  }
}