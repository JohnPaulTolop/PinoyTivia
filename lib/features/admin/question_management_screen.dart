import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/trivia_question.dart';
import '../../services/admin_service.dart';
import 'question_form_screen.dart';

class QuestionManagementScreen extends StatefulWidget {
  const QuestionManagementScreen({
    super.key,
  });

  @override
  State<QuestionManagementScreen> createState() =>
      _QuestionManagementScreenState();
}

class _QuestionManagementScreenState
    extends State<QuestionManagementScreen> {
  String selectedCategory = 'All';
  String selectedDifficulty = 'All';

  final TextEditingController searchController =
      TextEditingController();

  String searchText = '';

  static const categories = [
    'All',
    'Philippine History',
    'Geography',
    'Culture',
    'Language',
    'Literature',
    'Famous Filipinos',
    'National Symbols',
    'General Knowledge',
  ];

  static const difficulties = [
    'All',
    'Easy',
    'Medium',
    'Hard',
  ];

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void openAddQuestion() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const QuestionFormScreen(),
      ),
    );
  }

  void openEditQuestion(
    TriviaQuestion question,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => QuestionFormScreen(
          question: question,
        ),
      ),
    );
  }

  List<TriviaQuestion> filterQuestions(
    List<TriviaQuestion> questions,
  ) {
    return questions.where(
      (question) {
        final categoryMatches =
            selectedCategory == 'All' ||
                question.category == selectedCategory;

        final difficultyMatches =
            selectedDifficulty == 'All' ||
                question.difficulty == selectedDifficulty;

        final searchMatches =
            searchText.isEmpty ||
                question.question
                    .toLowerCase()
                    .contains(
                      searchText.toLowerCase(),
                    );

        return categoryMatches &&
            difficultyMatches &&
            searchMatches;
      },
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          'Question Management',
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: openAddQuestion,
        icon: const Icon(
          Icons.add_rounded,
        ),
        label: const Text(
          'Add Question',
        ),
      ),
      body: Column(
        children: [
          _buildHeader(),

          _buildFilters(),

          Expanded(
            child: StreamBuilder<List<TriviaQuestion>>(
              stream:
                  AdminService.instance.getAllQuestions(),
              builder: (context, snapshot) {
                if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(30),
                      child: Text(
                        'Unable to load questions. Check your administrator permissions.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                final allQuestions =
                    snapshot.data ?? [];

                final questions =
                    filterQuestions(allQuestions);

                if (questions.isEmpty) {
                  return _buildEmptyState();
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(
                    20,
                    10,
                    20,
                    100,
                  ),
                  itemCount: questions.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    return _QuestionCard(
                      question: questions[index],
                      onEdit: () {
                        openEditQuestion(
                          questions[index],
                        );
                      },
                      onDelete: () {
                        _confirmDelete(
                          questions[index],
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      color: AppColors.primaryBlue,
      child: const Column(
        children: [
          Icon(
            Icons.admin_panel_settings_rounded,
            color: AppColors.yellow,
            size: 48,
          ),
          SizedBox(height: 9),
          Text(
            'Admin Question Bank',
            style: TextStyle(
              color: Colors.white,
              fontSize: 21,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 5),
          Text(
            'Manage questions available to Pinoy Trivia students.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white70,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: searchController,
            onChanged: (value) {
              setState(() {
                searchText = value.trim();
              });
            },
            decoration: const InputDecoration(
              hintText: 'Search questions...',
              prefixIcon: Icon(
                Icons.search_rounded,
              ),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  items: categories.map(
                    (category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(
                          category,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    },
                  ).toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }

                    setState(() {
                      selectedCategory = value;
                    });
                  },
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: selectedDifficulty,
                  decoration: const InputDecoration(
                    labelText: 'Difficulty',
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                  items: difficulties.map(
                    (difficulty) {
                      return DropdownMenuItem(
                        value: difficulty,
                        child: Text(
                          difficulty,
                        ),
                      );
                    },
                  ).toList(),
                  onChanged: (value) {
                    if (value == null) {
                      return;
                    }

                    setState(() {
                      selectedDifficulty = value;
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(35),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.quiz_outlined,
              size: 65,
              color: AppColors.textSecondary,
            ),

            const SizedBox(height: 15),

            const Text(
              'No Questions Found',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),

            const SizedBox(height: 7),

            const Text(
              'Add a question or change the current filters.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textSecondary,
              ),
            ),

            const SizedBox(height: 18),

            FilledButton.icon(
              onPressed: openAddQuestion,
              icon: const Icon(
                Icons.add_rounded,
              ),
              label: const Text(
                'Add Question',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(
    TriviaQuestion question,
  ) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        bool deleting = false;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text(
                'Delete Question?',
              ),
              content: const Text(
                'This permanently removes the question from Firestore. You can disable a question instead if you may want to use it again later.',
              ),
              actions: [
                TextButton(
                  onPressed: deleting
                      ? null
                      : () {
                          Navigator.pop(dialogContext);
                        },
                  child: const Text(
                    'Cancel',
                  ),
                ),

                FilledButton(
                  onPressed: deleting
                      ? null
                      : () async {
                          setDialogState(() {
                            deleting = true;
                          });

                          try {
                            await AdminService.instance
                                .deleteQuestion(
                              question.id,
                            );

                            if (!dialogContext.mounted) {
                              return;
                            }

                            Navigator.pop(dialogContext);
                          } catch (error) {
                            if (!dialogContext.mounted) {
                              return;
                            }

                            setDialogState(() {
                              deleting = false;
                            });

                            if (!mounted) {
                              return;
                            }

                            ScaffoldMessenger.of(this.context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Unable to delete question.',
                                ),
                              ),
                            );
                          }
                        },
                  style: FilledButton.styleFrom(
                    backgroundColor:
                        AppColors.primaryRed,
                  ),
                  child: deleting
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Delete',
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final TriviaQuestion question;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _QuestionCard({
    required this.question,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Theme.of(context)
              .colorScheme
              .outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _StatusBadge(
                active: question.isActive,
              ),

              const SizedBox(width: 8),

              _DifficultyBadge(
                difficulty: question.difficulty,
              ),

              const Spacer(),

              PopupMenuButton<String>(
                onSelected: (value) async {
                  switch (value) {
                    case 'edit':
                      onEdit();
                      break;

                    case 'toggle':
                      try {
                        await AdminService.instance
                            .setQuestionActive(
                          questionId: question.id,
                          isActive: !question.isActive,
                        );
                      } catch (error) {
                        if (!context.mounted) {
                          return;
                        }

                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Unable to update question status.',
                            ),
                          ),
                        );
                      }
                      break;

                    case 'delete':
                      onDelete();
                      break;
                  }
                },
                itemBuilder: (context) {
                  return [
                    const PopupMenuItem(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(
                            Icons.edit_rounded,
                          ),
                          SizedBox(width: 10),
                          Text('Edit'),
                        ],
                      ),
                    ),

                    PopupMenuItem(
                      value: 'toggle',
                      child: Row(
                        children: [
                          Icon(
                            question.isActive
                                ? Icons.visibility_off_rounded
                                : Icons.visibility_rounded,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            question.isActive
                                ? 'Disable'
                                : 'Enable',
                          ),
                        ],
                      ),
                    ),

                    const PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(
                            Icons.delete_outline_rounded,
                            color: AppColors.primaryRed,
                          ),
                          SizedBox(width: 10),
                          Text(
                            'Delete',
                            style: TextStyle(
                              color: AppColors.primaryRed,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ];
                },
              ),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            question.question,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            question.category,
            style: const TextStyle(
              color: AppColors.primaryBlue,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),

          const SizedBox(height: 14),

          ...List.generate(
            question.choices.length,
            (index) {
              final correct =
                  index == question.correctAnswerIndex;

              return Padding(
                padding: const EdgeInsets.only(
                  bottom: 6,
                ),
                child: Row(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Icon(
                      correct
                          ? Icons.check_circle_rounded
                          : Icons.circle_outlined,
                      size: 17,
                      color: correct
                          ? const Color(0xFF27AE60)
                          : AppColors.textSecondary,
                    ),

                    const SizedBox(width: 7),

                    Expanded(
                      child: Text(
                        '${String.fromCharCode(65 + index)}. ${question.choices[index]}',
                        style: TextStyle(
                          fontWeight: correct
                              ? FontWeight.w800
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool active;

  const _StatusBadge({
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    final color = active
        ? const Color(0xFF27AE60)
        : Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: 0.12,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        active
            ? 'Active'
            : 'Inactive',
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _DifficultyBadge extends StatelessWidget {
  final String difficulty;

  const _DifficultyBadge({
    required this.difficulty,
  });

  @override
  Widget build(BuildContext context) {
    Color color;

    switch (difficulty) {
      case 'Hard':
        color = AppColors.primaryRed;
        break;

      case 'Medium':
        color = const Color(0xFFF39C12);
        break;

      default:
        color = const Color(0xFF27AE60);
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(
          alpha: 0.12,
        ),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        difficulty,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}