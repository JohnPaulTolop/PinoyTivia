import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../services/app_data.dart';
import '../../services/auth_service.dart';
import '../../services/firestore_service.dart';
import '../home/home_screen.dart';
import '../onboarding/onboarding_screen.dart';

class SplashScreen
    extends StatefulWidget {
  const SplashScreen({
    super.key,
  });

  @override
  State<SplashScreen>
      createState() =>
          _SplashScreenState();
}

class _SplashScreenState
    extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    _initializeApp();
  }

  Future<void>
      _initializeApp() async {
    // Keep splash visible briefly.
    await Future.delayed(
      const Duration(
        seconds: 2,
      ),
    );

    if (!mounted) {
      return;
    }

    final user =
        AuthService.instance
            .currentUser;

    if (user == null) {
      Navigator.of(context)
          .pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              const OnboardingScreen(),
        ),
      );

      return;
    }

    try {
      final profile =
          await AuthService.instance
              .getCurrentUserProfile();

      final history =
          await FirestoreService.instance
              .getQuizHistory();

      String name =
          user.displayName ??
              'Student';

      final profileName =
          profile?['name'];

      if (profileName is String &&
          profileName
              .trim()
              .isNotEmpty) {
        name = profileName;
      }

      AppData.instance
          .loadUserSession(
        name: name,
        quizHistory: history,
      );

      if (!mounted) {
        return;
      }

      Navigator.of(context)
          .pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              const HomeScreen(),
        ),
      );
    } catch (error) {
      // If profile restoration fails,
      // return to onboarding/login.
      if (!mounted) {
        return;
      }

      await AuthService.instance
          .logout();

      AppData.instance
          .clearUserSession();

      if (!mounted) {
        return;
      }

      Navigator.of(context)
          .pushReplacement(
        MaterialPageRoute(
          builder: (_) =>
              const OnboardingScreen(),
        ),
      );
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration:
            const BoxDecoration(
          gradient:
              LinearGradient(
            begin:
                Alignment.topCenter,
            end:
                Alignment.bottomCenter,
            colors: [
              AppColors.darkBlue,
              AppColors.navyBlue,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding:
                const EdgeInsets
                    .symmetric(
              horizontal: 30,
              vertical: 35,
            ),
            child: Column(
              children: [
                const Spacer(),

                const Icon(
                  Icons
                      .wb_sunny_rounded,
                  color:
                      AppColors.yellow,
                  size: 78,
                ),

                const SizedBox(
                  height: 16,
                ),

                const Text(
                  'PINOY',
                  style:
                      TextStyle(
                    fontSize: 45,
                    fontWeight:
                        FontWeight
                            .w900,
                    color:
                        Colors.white,
                    letterSpacing: 2,
                  ),
                ),

                Transform.rotate(
                  angle: -0.035,
                  child: Container(
                    padding:
                        const EdgeInsets
                            .symmetric(
                      horizontal: 22,
                      vertical: 6,
                    ),
                    decoration:
                        BoxDecoration(
                      color: AppColors
                          .primaryRed,
                      borderRadius:
                          BorderRadius
                              .circular(
                        6,
                      ),
                    ),
                    child:
                        const Text(
                      'TRIVIA',
                      style:
                          TextStyle(
                        color:
                            Colors.white,
                        fontSize: 29,
                        fontWeight:
                            FontWeight
                                .w900,
                        letterSpacing:
                            2,
                      ),
                    ),
                  ),
                ),

                const SizedBox(
                  height: 32,
                ),

                const Text(
                  'Test your knowledge.',
                  style:
                      TextStyle(
                    color:
                        Colors.white,
                    fontWeight:
                        FontWeight
                            .w600,
                  ),
                ),

                const SizedBox(
                  height: 6,
                ),

                const Text(
                  'Learn more about the Philippines.',
                  textAlign:
                      TextAlign.center,
                  style:
                      TextStyle(
                    color: Color(
                      0xFFD6E4F5,
                    ),
                  ),
                ),

                const Spacer(),

                const SizedBox(
                  width: 32,
                  height: 32,
                  child:
                      CircularProgressIndicator(
                    strokeWidth: 3,
                    color:
                        AppColors.yellow,
                  ),
                ),

                const SizedBox(
                  height: 16,
                ),

                const Text(
                  'Loading your progress...',
                  style:
                      TextStyle(
                    color:
                        Colors.white70,
                    fontSize: 13,
                  ),
                ),

                const SizedBox(
                  height: 25,
                ),

                const Text(
                  'LEARN. PLAY. BE PROUD.',
                  style:
                      TextStyle(
                    color:
                        AppColors.yellow,
                    fontSize: 12,
                    letterSpacing:
                        1.5,
                    fontWeight:
                        FontWeight
                            .w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}