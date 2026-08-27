import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  bool get isLoggedIn => currentUser != null;

  Stream<User?> get authStateChanges {
    return _auth.authStateChanges();
  }

  Future<UserCredential> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    final cleanedName = name.trim();
    final cleanedEmail =
        email.trim().toLowerCase();

    UserCredential? credential;

    try {
      credential =
          await _auth.createUserWithEmailAndPassword(
        email: cleanedEmail,
        password: password,
      );

      final user = credential.user;

      if (user == null) {
        throw StateError(
          'Firebase did not return a user.',
        );
      }

      await user.updateDisplayName(
        cleanedName,
      );

      final userRef = _firestore
          .collection('users')
          .doc(user.uid);

      final leaderboardRef = _firestore
          .collection('leaderboard')
          .doc(user.uid);

      final batch = _firestore.batch();

      batch.set(
        userRef,
        {
          'uid': user.uid,
          'name': cleanedName,
          'email': cleanedEmail,
          'totalPoints': 0,
          'totalQuizzes': 0,
          'highScore': 0,
          'totalCorrectAnswers': 0,
          'totalQuestionsAnswered': 0,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
      );

      batch.set(
        leaderboardRef,
        {
          'uid': user.uid,
          'name': cleanedName,
          'totalPoints': 0,
          'totalQuizzes': 0,
          'highScore': 0,
          'level': 1,
          'rankTitle': 'Trivia Beginner',
          'updatedAt': FieldValue.serverTimestamp(),
        },
      );

      await batch.commit();

      return credential;
    } catch (_) {
      // Prevent partially created accounts if
      // Firestore setup fails immediately after sign-up.
      final createdUser = credential?.user;

      if (createdUser != null) {
        try {
          await createdUser.delete();
        } catch (_) {
          // Ignore secondary cleanup failure.
        }
      }

      rethrow;
    }
  }

  Future<UserCredential> login({
    required String email,
    required String password,
  }) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> logout() {
    return _auth.signOut();
  }

  Future<void> sendPasswordResetEmail({
    required String email,
  }) {
    return _auth.sendPasswordResetEmail(
      email: email.trim(),
    );
  }

  Future<Map<String, dynamic>?>
      getCurrentUserProfile() async {
    final user = currentUser;

    if (user == null) {
      return null;
    }

    final document = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();

    return document.data();
  }
}