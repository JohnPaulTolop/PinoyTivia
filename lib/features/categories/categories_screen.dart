import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../quiz/difficulty_screen.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      const CategoryItem(
        title: 'Philippine History',
        subtitle: 'Heroes, events and independence',
        icon: Icons.account_balance_rounded,
        color: Color(0xFFE67E22),
      ),
      const CategoryItem(
        title: 'Philippine Geography',
        subtitle: 'Islands, mountains and places',
        icon: Icons.public_rounded,
        color: Color(0xFF27AE60),
      ),
      const CategoryItem(
        title: 'Filipino Culture',
        subtitle: 'Traditions and Filipino values',
        icon: Icons.diversity_3_rounded,
        color: Color(0xFF8E44AD),
      ),
      const CategoryItem(
        title: 'Filipino Language',
        subtitle: 'Words and expressions',
        icon: Icons.translate_rounded,
        color: Color(0xFFF39C12),
      ),
      const CategoryItem(
        title: 'Philippine Literature',
        subtitle: 'Writers and literary works',
        icon: Icons.menu_book_rounded,
        color: Color(0xFF2980B9),
      ),
      const CategoryItem(
        title: 'Famous Filipinos',
        subtitle: 'Important Filipino personalities',
        icon: Icons.person_rounded,
        color: Color(0xFFE74C3C),
      ),
      const CategoryItem(
        title: 'National Symbols',
        subtitle: 'Symbols of the Philippines',
        icon: Icons.flag_rounded,
        color: Color(0xFF16A085),
      ),
      const CategoryItem(
        title: 'General Knowledge',
        subtitle: 'Test your overall Filipino knowledge',
        icon: Icons.psychology_alt_rounded,
        color: AppColors.primaryBlue,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                20,
                24,
                20,
                24,
              ),
              decoration: const BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(28),
                  bottomRight: Radius.circular(28),
                ),
              ),
              child: const Column(
                children: [
                  Text(
                    'Trivia Categories',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Choose a category to start learning',
                    style: TextStyle(
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: categories.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final category = categories[index];

                  return InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => DifficultyScreen(
                            category: category.title,
                            categoryIcon: category.icon,
                            categoryColor: category.color,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: AppColors.border,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: category.color.withValues(
                                alpha: 0.12,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              category.icon,
                              color: category.color,
                              size: 30,
                            ),
                          ),

                          const SizedBox(width: 15),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  category.title,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  category.subtitle,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 17,
                            color: AppColors.textSecondary,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CategoryItem {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;

  const CategoryItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
  });
}