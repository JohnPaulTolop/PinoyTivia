import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../services/app_data.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../home/home_screen.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool rememberMe = false;
  bool hidePassword = true;
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showMessage(
        'Please enter your email and password.',
      );
      return;
    }

    if (!email.contains('@')) {
      _showMessage(
        'Please enter a valid email address.',
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Login using Firebase Authentication.
      await AuthService.instance.login(
        email: email,
        password: password,
      );

      // Load the student's Firestore profile.
      final profile =
          await AuthService.instance.getCurrentUserProfile();

      // Load all previous quiz results.
      final history =
          await FirestoreService.instance.getQuizHistory();

      String name = 'Student';

      final profileName = profile?['name'];

      if (profileName is String && profileName.trim().isNotEmpty) {
        name = profileName.trim();
      } else {
        final firebaseName =
            AuthService.instance.currentUser?.displayName;

        if (firebaseName != null &&
            firebaseName.trim().isNotEmpty) {
          name = firebaseName.trim();
        }
      }

      // Restore data into the local app state.
      AppData.instance.loadUserSession(
        name: name,
        quizHistory: history,
      );

      if (!mounted) {
        return;
      }

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => const HomeScreen(),
        ),
        (route) => false,
      );
    } on FirebaseAuthException catch (error) {
      if (!mounted) {
        return;
      }

      _showMessage(
        _firebaseMessage(error),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showMessage(
        'Unable to load your account. Please try again.',
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> forgotPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      _showMessage(
        'Enter your email address first.',
      );
      return;
    }

    if (!email.contains('@')) {
      _showMessage(
        'Please enter a valid email address.',
      );
      return;
    }

    try {
      await AuthService.instance.sendPasswordResetEmail(
        email: email,
      );

      if (!mounted) {
        return;
      }

      _showMessage(
        'Password reset email sent. Check your inbox.',
      );
    } on FirebaseAuthException catch (error) {
      if (!mounted) {
        return;
      }

      _showMessage(
        _firebaseMessage(error),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showMessage(
        'Unable to send password reset email.',
      );
    }
  }

  void openSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const SignUpScreen(),
      ),
    );
  }

  void continueWithGoogle() {
    _showMessage(
      'Google Sign-In will be added later.',
    );
  }

  String _firebaseMessage(
    FirebaseAuthException error,
  ) {
    switch (error.code) {
      case 'invalid-email':
        return 'The email address is invalid.';

      case 'user-disabled':
        return 'This account has been disabled.';

      case 'user-not-found':
        return 'No account exists with this email.';

      case 'wrong-password':
        return 'Incorrect password.';

      case 'invalid-credential':
        return 'Incorrect email or password.';

      case 'too-many-requests':
        return 'Too many login attempts. Please try again later.';

      case 'network-request-failed':
        return 'Check your internet connection and try again.';

      default:
        return error.message ?? 'Unable to log in.';
    }
  }

  void _showMessage(
    String message,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 25,
            vertical: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 15),

              // Filipino color decorations
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _flagDecoration(AppColors.primaryBlue),
                  const SizedBox(width: 8),
                  _flagDecoration(AppColors.primaryRed),
                  const SizedBox(width: 8),
                  _flagDecoration(AppColors.yellow),
                  const SizedBox(width: 8),
                  _flagDecoration(AppColors.primaryBlue),
                  const SizedBox(width: 8),
                  _flagDecoration(AppColors.primaryRed),
                ],
              ),

              const SizedBox(height: 55),

              const Icon(
                Icons.wb_sunny_rounded,
                color: AppColors.yellow,
                size: 52,
              ),

              const SizedBox(height: 15),

              const Text(
                'Welcome Back!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.primaryBlue,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Log in to continue your Pinoy Trivia journey.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 40),

              const Text(
                'Email',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: emailController,
                enabled: !isLoading,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                autofillHints: const [
                  AutofillHints.email,
                ],
                decoration: const InputDecoration(
                  hintText: 'Enter your email',
                  prefixIcon: Icon(
                    Icons.email_outlined,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'Password',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: passwordController,
                enabled: !isLoading,
                obscureText: hidePassword,
                textInputAction: TextInputAction.done,
                autofillHints: const [
                  AutofillHints.password,
                ],
                onSubmitted: (_) {
                  if (!isLoading) {
                    login();
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  prefixIcon: const Icon(
                    Icons.lock_outline_rounded,
                  ),
                  suffixIcon: IconButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                    icon: Icon(
                      hidePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  Checkbox(
                    value: rememberMe,
                    activeColor: AppColors.primaryBlue,
                    onChanged: isLoading
                        ? null
                        : (value) {
                            setState(() {
                              rememberMe = value ?? false;
                            });
                          },
                  ),

                  const Text(
                    'Remember me',
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),

                  const Spacer(),

                  TextButton(
                    onPressed: isLoading
                        ? null
                        : forgotPassword,
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              FilledButton(
                onPressed: isLoading
                    ? null
                    : login,
                child: isLoading
                    ? const SizedBox(
                        width: 22,
                        height: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        'Log In',
                      ),
              ),

              const SizedBox(height: 30),

              Row(
                children: [
                  const Expanded(
                    child: Divider(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                    ),
                    child: Text(
                      'or',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                  const Expanded(
                    child: Divider(),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              OutlinedButton.icon(
                onPressed: isLoading
                    ? null
                    : continueWithGoogle,
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(
                    double.infinity,
                    54,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                icon: const Icon(
                  Icons.account_circle_outlined,
                ),
                label: const Text(
                  'Continue with Google',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an account?",
                  ),
                  TextButton(
                    onPressed: isLoading
                        ? null
                        : openSignUp,
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _flagDecoration(
    Color color,
  ) {
    return Transform.rotate(
      angle: 0.7,
      child: Container(
        width: 17,
        height: 17,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(3),
        ),
      ),
    );
  }
}