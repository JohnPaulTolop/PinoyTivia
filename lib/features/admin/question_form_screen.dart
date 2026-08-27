import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../models/trivia_question.dart';
import '../../services/admin_service.dart';

class QuestionFormScreen extends StatefulWidget {
  final TriviaQuestion? question;

  const QuestionFormScreen({
    super.key,
    this.question,
  });

  bool get isEditing => question != null;

  @override
  State<QuestionFormScreen> createState() =>
      _QuestionFormScreenState();
}

class _QuestionFormScreenState extends State<QuestionFormScreen> {
  static const List<String> categories = [
    'Philippine History',
    'Geography',
    'Culture',
    'Language',
    'Literature',
    'Famous Filipinos',
    'National Symbols',
    'General Knowledge',
  ];

  static const List<String> difficulties = [
    'Easy',
    'Medium',
    'Hard',
  ];

  final TextEditingController questionController =
      TextEditingController();

  final TextEditingController explanationController =
      TextEditingController();

  final List<TextEditingController> choiceControllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];

  String selectedCategory = categories.first;
  String selectedDifficulty = difficulties.first;

  int correctAnswerIndex = 0;

  bool isActive = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();

    final question = widget.question;

    if (question == null) {
      return;
    }

    questionController.text = question.question;
    explanationController.text = question.explanation;

    selectedCategory = categories.contains(
      question.category,
    )
        ? question.category
        : categories.first;

    selectedDifficulty = difficulties.contains(
      question.difficulty,
    )
        ? question.difficulty
        : difficulties.first;

    correctAnswerIndex = question.correctAnswerIndex;
    isActive = question.isActive;

    for (
      int index = 0;
      index < choiceControllers.length;
      index++
    ) {
      if (index < question.choices.length) {
        choiceControllers[index].text =
            question.choices[index];
      }
    }
  }

  @override
  void dispose() {
    questionController.dispose();
    explanationController.dispose();

    for (final controller in choiceControllers) {
      controller.dispose();
    }

    super.dispose();
  }

  Future<void> saveQuestion() async {
    if (isSaving) {
      return;
    }

    final questionText =
        questionController.text.trim();

    final explanation =
        explanationController.text.trim();

    final choices = choiceControllers
        .map(
          (controller) =>
              controller.text.trim(),
        )
        .toList();

    if (questionText.isEmpty) {
      _showMessage(
        'Please enter the question.',
      );
      return;
    }

    if (choices.any(
      (choice) => choice.isEmpty,
    )) {
      _showMessage(
        'Please complete all four answer choices.',
      );
      return;
    }

    final normalizedChoices = choices
        .map(
          (choice) =>
              choice.toLowerCase(),
        )
        .toSet();

    if (normalizedChoices.length != 4) {
      _showMessage(
        'Answer choices must be different from each other.',
      );
      return;
    }

    if (correctAnswerIndex < 0 ||
        correctAnswerIndex >= choices.length) {
      _showMessage(
        'Please select the correct answer.',
      );
      return;
    }

    if (explanation.isEmpty) {
      _showMessage(
        'Please enter an explanation for the correct answer.',
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    final question = TriviaQuestion(
      id: widget.question?.id ?? '',
      question: questionText,
      choices: choices,
      correctAnswerIndex: correctAnswerIndex,
      explanation: explanation,
      category: selectedCategory,
      difficulty: selectedDifficulty,
      isActive: isActive,
    );

    try {
      if (widget.isEditing) {
        await AdminService.instance.updateQuestion(
          question,
        );
      } else {
        await AdminService.instance.addQuestion(
          question,
        );
      }

      if (!mounted) {
        return;
      }

      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isEditing
                ? 'Question updated successfully.'
                : 'Question added successfully.',
          ),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }

      _showMessage(
        'Unable to save the question. Check your administrator access and internet connection.',
      );
    } finally {
      if (mounted) {
        setState(() {
          isSaving = false;
        });
      }
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
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          widget.isEditing
              ? 'Edit Question'
              : 'Add Question',
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(
            20,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.stretch,
            children: [
              // ==================================================
              // QUESTION DETAILS
              // ==================================================

              _SectionCard(
                title: 'Question Details',
                child: Column(
                  children: [
                    TextField(
                      controller:
                          questionController,
                      enabled: !isSaving,
                      maxLines: 4,
                      minLines: 2,
                      textCapitalization:
                          TextCapitalization
                              .sentences,
                      decoration:
                          const InputDecoration(
                        labelText:
                            'Question',
                        hintText:
                            'Enter the trivia question',
                        prefixIcon: Icon(
                          Icons
                              .help_outline_rounded,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    DropdownButtonFormField<
                        String>(
                      initialValue:
                          selectedCategory,
                      isExpanded: true,
                      decoration:
                          const InputDecoration(
                        labelText:
                            'Category',
                        prefixIcon: Icon(
                          Icons
                              .category_rounded,
                        ),
                      ),
                      items:
                          categories.map(
                        (category) {
                          return DropdownMenuItem<
                              String>(
                            value:
                                category,
                            child: Text(
                              category,
                              overflow:
                                  TextOverflow
                                      .ellipsis,
                            ),
                          );
                        },
                      ).toList(),
                      onChanged: isSaving
                          ? null
                          : (value) {
                              if (value ==
                                  null) {
                                return;
                              }

                              setState(
                                () {
                                  selectedCategory =
                                      value;
                                },
                              );
                            },
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    DropdownButtonFormField<
                        String>(
                      initialValue:
                          selectedDifficulty,
                      decoration:
                          const InputDecoration(
                        labelText:
                            'Difficulty',
                        prefixIcon: Icon(
                          Icons
                              .speed_rounded,
                        ),
                      ),
                      items:
                          difficulties.map(
                        (difficulty) {
                          return DropdownMenuItem<
                              String>(
                            value:
                                difficulty,
                            child: Text(
                              difficulty,
                            ),
                          );
                        },
                      ).toList(),
                      onChanged: isSaving
                          ? null
                          : (value) {
                              if (value ==
                                  null) {
                                return;
                              }

                              setState(
                                () {
                                  selectedDifficulty =
                                      value;
                                },
                              );
                            },
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 18,
              ),

              // ==================================================
              // ANSWER CHOICES
              // ==================================================

              _SectionCard(
                title: 'Answer Choices',
                child: RadioGroup<int>(
                  groupValue:
                      correctAnswerIndex,
                  onChanged: (value) {
                    if (value == null ||
                        isSaving) {
                      return;
                    }

                    setState(() {
                      correctAnswerIndex =
                          value;
                    });
                  },
                  child: Column(
                    children:
                        List.generate(
                      4,
                      (index) {
                        final isCorrect =
                            index ==
                                correctAnswerIndex;

                        return Padding(
                          padding:
                              EdgeInsets.only(
                            bottom:
                                index == 3
                                    ? 0
                                    : 14,
                          ),
                          child: Container(
                            padding:
                                const EdgeInsets
                                    .all(
                              10,
                            ),
                            decoration:
                                BoxDecoration(
                              color: isCorrect
                                  ? const Color(
                                      0xFFEAF8EF,
                                    )
                                  : Colors
                                      .transparent,
                              borderRadius:
                                  BorderRadius
                                      .circular(
                                14,
                              ),
                              border:
                                  Border.all(
                                color: isCorrect
                                    ? const Color(
                                        0xFF27AE60,
                                      )
                                    : Theme.of(
                                        context,
                                      )
                                        .colorScheme
                                        .outlineVariant,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .center,
                              children: [
                                Radio<int>(
                                  value:
                                      index,
                                  enabled:
                                      !isSaving,
                                  activeColor:
                                      const Color(
                                    0xFF27AE60,
                                  ),
                                ),

                                const SizedBox(
                                  width: 4,
                                ),

                                Expanded(
                                  child:
                                      TextField(
                                    controller:
                                        choiceControllers[
                                            index],
                                    enabled:
                                        !isSaving,
                                    textCapitalization:
                                        TextCapitalization
                                            .sentences,
                                    decoration:
                                        InputDecoration(
                                      labelText:
                                          'Choice ${String.fromCharCode(65 + index)}',
                                      hintText:
                                          isCorrect
                                              ? 'Correct answer'
                                              : 'Answer choice',
                                      suffixIcon:
                                          isCorrect
                                              ? const Icon(
                                                  Icons
                                                      .check_circle_rounded,
                                                  color:
                                                      Color(
                                                    0xFF27AE60,
                                                  ),
                                                )
                                              : null,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 10,
              ),

              const Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons
                        .check_circle_rounded,
                    size: 18,
                    color: Color(
                      0xFF27AE60,
                    ),
                  ),
                  SizedBox(
                    width: 7,
                  ),
                  Expanded(
                    child: Text(
                      'Select the radio button beside the correct answer.',
                      style: TextStyle(
                        color: AppColors
                            .textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 18,
              ),

              // ==================================================
              // EXPLANATION
              // ==================================================

              _SectionCard(
                title: 'Explanation',
                child: TextField(
                  controller:
                      explanationController,
                  enabled: !isSaving,
                  maxLines: 5,
                  minLines: 3,
                  textCapitalization:
                      TextCapitalization
                          .sentences,
                  decoration:
                      const InputDecoration(
                    hintText:
                        'Explain why the selected answer is correct.',
                    prefixIcon: Icon(
                      Icons
                          .lightbulb_outline_rounded,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 18,
              ),

              // ==================================================
              // QUESTION STATUS
              // ==================================================

              _SectionCard(
                title: 'Question Status',
                child: SwitchListTile(
                  contentPadding:
                      EdgeInsets.zero,
                  value: isActive,
                  activeThumbColor:
                      const Color(
                    0xFF27AE60,
                  ),
                  onChanged: isSaving
                      ? null
                      : (value) {
                          setState(() {
                            isActive =
                                value;
                          });
                        },
                  title: Text(
                    isActive
                        ? 'Active'
                        : 'Inactive',
                    style: const TextStyle(
                      fontWeight:
                          FontWeight.w800,
                    ),
                  ),
                  subtitle: Text(
                    isActive
                        ? 'Students can receive this question in quizzes.'
                        : 'This question will be hidden from student quizzes.',
                  ),
                  secondary: Icon(
                    isActive
                        ? Icons
                            .visibility_rounded
                        : Icons
                            .visibility_off_rounded,
                    color: isActive
                        ? const Color(
                            0xFF27AE60,
                          )
                        : Colors.grey,
                  ),
                ),
              ),

              const SizedBox(
                height: 25,
              ),

              // ==================================================
              // SAVE BUTTON
              // ==================================================

              FilledButton.icon(
                onPressed:
                    isSaving
                        ? null
                        : saveQuestion,
                icon: isSaving
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2,
                          color:
                              Colors.white,
                        ),
                      )
                    : Icon(
                        widget.isEditing
                            ? Icons
                                .save_as_rounded
                            : Icons
                                .add_circle_rounded,
                      ),
                label: Text(
                  isSaving
                      ? 'Saving...'
                      : widget.isEditing
                          ? 'Update Question'
                          : 'Add Question',
                ),
              ),

              const SizedBox(
                height: 12,
              ),

              OutlinedButton.icon(
                onPressed: isSaving
                    ? null
                    : () {
                        Navigator.of(
                          context,
                        ).pop();
                      },
                icon: const Icon(
                  Icons.close_rounded,
                ),
                label: const Text(
                  'Cancel',
                ),
              ),

              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================
// SECTION CARD
// ============================================================

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(
        18,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surface,
        borderRadius:
            BorderRadius.circular(
          20,
        ),
        border: Border.all(
          color: Theme.of(context)
              .colorScheme
              .outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color:
                  AppColors.primaryBlue,
              fontSize: 17,
              fontWeight:
                  FontWeight.w900,
            ),
          ),

          const SizedBox(
            height: 15,
          ),

          child,
        ],
      ),
    );
  }
}