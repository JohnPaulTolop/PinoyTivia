import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../services/app_data.dart';
import '../../services/auth_service.dart';
import '../home/home_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({
    super.key,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool hidePassword = true;
  bool hideConfirmPassword = true;
  bool agreeToTerms = false;
  bool isLoading = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
  }

  Future<void> signUp() async {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (name.isEmpty ||
        email.isEmpty ||
        password.isEmpty ||
        confirmPassword.isEmpty) {
      _showMessage(
        'Please complete all fields.',
      );
      return;
    }

    if (name.length < 2) {
      _showMessage(
        'Please enter your complete name.',
      );
      return;
    }

    if (!email.contains('@') || !email.contains('.')) {
      _showMessage(
        'Please enter a valid email address.',
      );
      return;
    }

    if (password.length < 6) {
      _showMessage(
        'Password must contain at least 6 characters.',
      );
      return;
    }

    if (password != confirmPassword) {
      _showMessage(
        'Passwords do not match.',
      );
      return;
    }

    if (!agreeToTerms) {
      _showMessage(
        'Please agree to the Terms and Conditions.',
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Creates:
      // 1. Firebase Authentication user
      // 2. Firestore student document
      // 3. Leaderboard document
      await AuthService.instance.signUp(
        name: name,
        email: email,
        password: password,
      );

      // New users start with no quiz history.
      AppData.instance.loadUserSession(
        name: name,
        quizHistory: const [],
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
        'Unable to create your account. Please try again.',
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  String _firebaseMessage(
    FirebaseAuthException error,
  ) {
    switch (error.code) {
      case 'email-already-in-use':
        return 'An account already exists with this email.';

      case 'invalid-email':
        return 'The email address is invalid.';

      case 'weak-password':
        return 'Your password is too weak.';

      case 'operation-not-allowed':
        return 'Email and password registration is not enabled.';

      case 'network-request-failed':
        return 'Check your internet connection and try again.';

      default:
        return error.message ??
            'Unable to create your account.';
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
      appBar: AppBar(
        title: const Text(
          'Create Account',
          style: TextStyle(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 25,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.wb_sunny_rounded,
                size: 55,
                color: AppColors.yellow,
              ),

              const SizedBox(height: 15),

              const Text(
                'Join Pinoy Trivia!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primaryBlue,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                'Create your student account and start learning.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 35),

              // Full Name
              const Text(
                'Full Name',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: nameController,
                enabled: !isLoading,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                autofillHints: const [
                  AutofillHints.name,
                ],
                decoration: const InputDecoration(
                  hintText: 'Enter your full name',
                  prefixIcon: Icon(
                    Icons.person_outline_rounded,
                  ),
                ),
              ),

              const SizedBox(height: 18),

              // Email
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

              const SizedBox(height: 18),

              // Password
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
                textInputAction: TextInputAction.next,
                autofillHints: const [
                  AutofillHints.newPassword,
                ],
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

              const SizedBox(height: 6),

              const Text(
                'Password must contain at least 6 characters.',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 11,
                ),
              ),

              const SizedBox(height: 18),

              // Confirm Password
              const Text(
                'Confirm Password',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              TextField(
                controller: confirmPasswordController,
                enabled: !isLoading,
                obscureText: hideConfirmPassword,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) {
                  if (!isLoading) {
                    signUp();
                  }
                },
                decoration: InputDecoration(
                  hintText: 'Repeat your password',
                  prefixIcon: const Icon(
                    Icons.lock_outline_rounded,
                  ),
                  suffixIcon: IconButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            setState(() {
                              hideConfirmPassword =
                                  !hideConfirmPassword;
                            });
                          },
                    icon: Icon(
                      hideConfirmPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Terms
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Checkbox(
                    value: agreeToTerms,
                    activeColor: AppColors.primaryBlue,
                    onChanged: isLoading
                        ? null
                        : (value) {
                            setState(() {
                              agreeToTerms = value ?? false;
                            });
                          },
                  ),

                  const Expanded(
                    child: Text(
                      'I agree to the Terms and Conditions.',
                      style: TextStyle(
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),

              FilledButton(
                onPressed: isLoading
                    ? null
                    : signUp,
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
                        'Create Account',
                      ),
              ),

              const SizedBox(height: 25),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account?',
                  ),
                  TextButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            Navigator.of(context).pop();
                          },
                    child: const Text(
                      'Log In',
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
}