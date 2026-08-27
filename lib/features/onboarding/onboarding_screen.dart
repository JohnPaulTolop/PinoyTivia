import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../auth/login_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();

  int currentPage = 0;

  final List<OnboardingData> pages = const [
    OnboardingData(
      icon: Icons.flag_rounded,
      title: 'Welcome to\nPinoy Trivia!',
      description:
          'An interactive way to learn and have fun while discovering the Philippines.',
    ),
    OnboardingData(
      icon: Icons.explore_rounded,
      title: 'Explore Categories',
      description:
          'Discover exciting topics about Philippine history, culture, geography, language, and more!',
    ),
    OnboardingData(
      icon: Icons.emoji_events_rounded,
      title: 'Play, Learn,\nand Earn Rewards!',
      description:
          'Answer questions, earn points, collect achievements, and become the ultimate Pinoy Trivia champion!',
    ),
  ];

  void nextPage() {
    if (currentPage < pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    } else {
      openLogin();
    }
  }

  void openLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 20,
                  top: 10,
                ),
                child: TextButton(
                  onPressed: openLogin,
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      color: AppColors.primaryBlue,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),

            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: pages.length,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = pages[index];

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 28,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 230,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AppColors.lightBlue,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: Center(
                            child: Container(
                              width: 145,
                              height: 145,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                page.icon,
                                size: 85,
                                color: index == 2
                                    ? AppColors.gold
                                    : AppColors.primaryBlue,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 45),

                        Text(
                          page.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 29,
                            height: 1.2,
                            fontWeight: FontWeight.w900,
                            color: index == 2
                                ? AppColors.primaryRed
                                : AppColors.primaryBlue,
                          ),
                        ),

                        const SizedBox(height: 20),

                        Text(
                          page.description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.5,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                25,
                20,
                25,
                30,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      children: List.generate(
                        pages.length,
                        (index) {
                          final selected = currentPage == index;

                          return AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            margin: const EdgeInsets.only(right: 7),
                            height: 8,
                            width: selected ? 28 : 8,
                            decoration: BoxDecoration(
                              color: selected
                                  ? AppColors.primaryBlue
                                  : const Color(0xFFD1D5DB),
                              borderRadius: BorderRadius.circular(50),
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  FloatingActionButton(
                    onPressed: nextPage,
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    child: Icon(
                      currentPage == pages.length - 1
                          ? Icons.check_rounded
                          : Icons.arrow_forward_rounded,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnboardingData {
  final IconData icon;
  final String title;
  final String description;

  const OnboardingData({
    required this.icon,
    required this.title,
    required this.description,
  });
}