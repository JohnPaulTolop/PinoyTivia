import '../models/trivia_question.dart';
import 'dart:math';

class TriviaData {
  static const List<TriviaQuestion> questions = [
    // =========================================================
    // PHILIPPINE HISTORY - EASY
    // =========================================================

    TriviaQuestion(
      question: 'Who is the national hero of the Philippines?',
      choices: [
        'Andres Bonifacio',
        'Dr. Jose Rizal',
        'Emilio Aguinaldo',
        'Apolinario Mabini',
      ],
      correctAnswerIndex: 1,
      explanation:
          'Dr. Jose Rizal is widely recognized as the national hero of the Philippines because of his writings and contribution to the reform movement.',
      category: 'Philippine History',
      difficulty: 'Easy',
    ),

    TriviaQuestion(
      question: 'Who wrote Noli Me Tangere?',
      choices: [
        'Andres Bonifacio',
        'Dr. Jose Rizal',
        'Emilio Jacinto',
        'Marcelo H. del Pilar',
      ],
      correctAnswerIndex: 1,
      explanation:
          'Noli Me Tangere was written by Dr. Jose Rizal and published in 1887.',
      category: 'Philippine History',
      difficulty: 'Easy',
    ),

    TriviaQuestion(
      question: 'Who became the first president of the Philippines?',
      choices: [
        'Manuel Quezon',
        'Sergio Osmeña',
        'Emilio Aguinaldo',
        'Manuel Roxas',
      ],
      correctAnswerIndex: 2,
      explanation:
          'Emilio Aguinaldo became the first president of the First Philippine Republic.',
      category: 'Philippine History',
      difficulty: 'Easy',
    ),

    TriviaQuestion(
      question: 'On what date is Philippine Independence Day celebrated?',
      choices: [
        'June 12',
        'June 19',
        'August 21',
        'November 30',
      ],
      correctAnswerIndex: 0,
      explanation:
          'Philippine Independence Day is celebrated every June 12.',
      category: 'Philippine History',
      difficulty: 'Easy',
    ),

    TriviaQuestion(
      question: 'Who founded the Katipunan?',
      choices: [
        'Jose Rizal',
        'Andres Bonifacio',
        'Antonio Luna',
        'Emilio Aguinaldo',
      ],
      correctAnswerIndex: 1,
      explanation:
          'Andres Bonifacio was one of the founders and became the Supremo of the Katipunan.',
      category: 'Philippine History',
      difficulty: 'Easy',
    ),

    // =========================================================
    // PHILIPPINE HISTORY - MEDIUM
    // =========================================================

    TriviaQuestion(
      question: 'In what year was Noli Me Tangere published?',
      choices: [
        '1887',
        '1891',
        '1896',
        '1872',
      ],
      correctAnswerIndex: 0,
      explanation:
          'Noli Me Tangere was first published in Berlin, Germany in 1887.',
      category: 'Philippine History',
      difficulty: 'Medium',
    ),

    TriviaQuestion(
      question: 'Who was known as the Brains of the Revolution?',
      choices: [
        'Antonio Luna',
        'Apolinario Mabini',
        'Emilio Jacinto',
        'Gregorio del Pilar',
      ],
      correctAnswerIndex: 1,
      explanation:
          'Apolinario Mabini was known as the Brains of the Revolution because of his role as adviser and political thinker.',
      category: 'Philippine History',
      difficulty: 'Medium',
    ),

    TriviaQuestion(
      question: 'Where was Jose Rizal executed?',
      choices: [
        'Cavite',
        'Bagumbayan',
        'Malolos',
        'Calamba',
      ],
      correctAnswerIndex: 1,
      explanation:
          'Jose Rizal was executed at Bagumbayan, now known as Rizal Park, on December 30, 1896.',
      category: 'Philippine History',
      difficulty: 'Medium',
    ),

    TriviaQuestion(
      question: 'What secret society fought Spanish colonial rule?',
      choices: [
        'La Liga Filipina',
        'Katipunan',
        'Propaganda Movement',
        'Malolos Congress',
      ],
      correctAnswerIndex: 1,
      explanation:
          'The Katipunan was a revolutionary secret society that sought Philippine independence from Spain.',
      category: 'Philippine History',
      difficulty: 'Medium',
    ),

    TriviaQuestion(
      question: 'Who was called the Great Plebeian?',
      choices: [
        'Andres Bonifacio',
        'Jose Rizal',
        'Antonio Luna',
        'Manuel Quezon',
      ],
      correctAnswerIndex: 0,
      explanation:
          'Andres Bonifacio became known as the Great Plebeian because of his working-class background.',
      category: 'Philippine History',
      difficulty: 'Medium',
    ),

    // =========================================================
    // GEOGRAPHY
    // =========================================================

    TriviaQuestion(
      question: 'What is the capital city of the Philippines?',
      choices: [
        'Cebu City',
        'Davao City',
        'Manila',
        'Quezon City',
      ],
      correctAnswerIndex: 2,
      explanation:
          'Manila is the official capital city of the Philippines.',
      category: 'Philippine Geography',
      difficulty: 'Easy',
    ),

    TriviaQuestion(
      question: 'Which is the largest island in the Philippines?',
      choices: [
        'Mindanao',
        'Luzon',
        'Palawan',
        'Samar',
      ],
      correctAnswerIndex: 1,
      explanation:
          'Luzon is the largest island in the Philippines.',
      category: 'Philippine Geography',
      difficulty: 'Easy',
    ),

    TriviaQuestion(
      question: 'Which volcano is famous for its near-perfect cone shape?',
      choices: [
        'Taal Volcano',
        'Mount Pinatubo',
        'Mayon Volcano',
        'Mount Apo',
      ],
      correctAnswerIndex: 2,
      explanation:
          'Mayon Volcano in Albay is famous for its almost perfectly symmetrical cone.',
      category: 'Philippine Geography',
      difficulty: 'Easy',
    ),

    TriviaQuestion(
      question: 'What is the highest mountain in the Philippines?',
      choices: [
        'Mount Pulag',
        'Mount Arayat',
        'Mount Apo',
        'Mount Makiling',
      ],
      correctAnswerIndex: 2,
      explanation:
          'Mount Apo is the highest mountain in the Philippines.',
      category: 'Philippine Geography',
      difficulty: 'Medium',
    ),

    TriviaQuestion(
      question: 'In which province can the Chocolate Hills be found?',
      choices: [
        'Bohol',
        'Cebu',
        'Palawan',
        'Leyte',
      ],
      correctAnswerIndex: 0,
      explanation:
          'The famous Chocolate Hills are located in the province of Bohol.',
      category: 'Philippine Geography',
      difficulty: 'Medium',
    ),

    // =========================================================
    // CULTURE
    // =========================================================

    TriviaQuestion(
      question: 'What Filipino gesture is used to show respect to elders?',
      choices: [
        'Bayanihan',
        'Mano po',
        'Harana',
        'Fiesta',
      ],
      correctAnswerIndex: 1,
      explanation:
          'Mano po is a traditional Filipino gesture where a younger person places an elder\'s hand on their forehead.',
      category: 'Filipino Culture',
      difficulty: 'Easy',
    ),

    TriviaQuestion(
      question: 'What does bayanihan represent?',
      choices: [
        'Competition',
        'Community cooperation',
        'Traditional dance',
        'Courtship',
      ],
      correctAnswerIndex: 1,
      explanation:
          'Bayanihan represents community cooperation and helping one another.',
      category: 'Filipino Culture',
      difficulty: 'Easy',
    ),

    TriviaQuestion(
      question: 'What is a traditional Filipino serenade called?',
      choices: [
        'Kundiman',
        'Harana',
        'Tinikling',
        'Balagtasan',
      ],
      correctAnswerIndex: 1,
      explanation:
          'Harana is the Filipino tradition of serenading someone, commonly associated with courtship.',
      category: 'Filipino Culture',
      difficulty: 'Medium',
    ),

    // =========================================================
    // LANGUAGE
    // =========================================================

    TriviaQuestion(
      question: 'What does "Salamat" mean?',
      choices: [
        'Welcome',
        'Goodbye',
        'Thank you',
        'Good morning',
      ],
      correctAnswerIndex: 2,
      explanation:
          'Salamat is the Filipino word commonly used to say thank you.',
      category: 'Filipino Language',
      difficulty: 'Easy',
    ),

    TriviaQuestion(
      question: 'What does "Mabuhay" commonly express?',
      choices: [
        'Long live / Welcome',
        'Good night',
        'Sorry',
        'Please',
      ],
      correctAnswerIndex: 0,
      explanation:
          'Mabuhay can mean "long live" and is also commonly used as a welcoming Filipino expression.',
      category: 'Filipino Language',
      difficulty: 'Easy',
    ),

    // =========================================================
    // LITERATURE
    // =========================================================

    TriviaQuestion(
      question: 'Who is known as the Prince of Tagalog Poets?',
      choices: [
        'Francisco Balagtas',
        'Jose Rizal',
        'Nick Joaquin',
        'Jose Corazon de Jesus',
      ],
      correctAnswerIndex: 0,
      explanation:
          'Francisco Balagtas is one of the most influential Filipino literary figures and is known as the Prince of Tagalog Poets.',
      category: 'Philippine Literature',
      difficulty: 'Medium',
    ),

    TriviaQuestion(
      question: 'Who wrote Florante at Laura?',
      choices: [
        'Jose Rizal',
        'Francisco Balagtas',
        'Lope K. Santos',
        'Jose Corazon de Jesus',
      ],
      correctAnswerIndex: 1,
      explanation:
          'Florante at Laura was written by Francisco Balagtas.',
      category: 'Philippine Literature',
      difficulty: 'Easy',
    ),

    // =========================================================
    // FAMOUS FILIPINOS
    // =========================================================

    TriviaQuestion(
      question: 'Who is known as the Father of the Philippine Language?',
      choices: [
        'Manuel L. Quezon',
        'Emilio Aguinaldo',
        'Jose P. Laurel',
        'Manuel Roxas',
      ],
      correctAnswerIndex: 0,
      explanation:
          'Manuel L. Quezon is known as the Father of the Philippine National Language.',
      category: 'Famous Filipinos',
      difficulty: 'Easy',
    ),

    TriviaQuestion(
      question: 'Who was known as the Sublime Paralytic?',
      choices: [
        'Emilio Jacinto',
        'Apolinario Mabini',
        'Andres Bonifacio',
        'Antonio Luna',
      ],
      correctAnswerIndex: 1,
      explanation:
          'Apolinario Mabini was called the Sublime Paralytic because of his intellectual contributions despite his physical disability.',
      category: 'Famous Filipinos',
      difficulty: 'Medium',
    ),

    // =========================================================
    // NATIONAL SYMBOLS
    // =========================================================

    TriviaQuestion(
      question: 'What is the national flower of the Philippines?',
      choices: [
        'Rose',
        'Sampaguita',
        'Gumamela',
        'Orchid',
      ],
      correctAnswerIndex: 1,
      explanation:
          'Sampaguita is recognized as the national flower of the Philippines.',
      category: 'National Symbols',
      difficulty: 'Easy',
    ),

    TriviaQuestion(
      question: 'What is the national tree of the Philippines?',
      choices: [
        'Narra',
        'Mango',
        'Coconut',
        'Acacia',
      ],
      correctAnswerIndex: 0,
      explanation:
          'Narra is recognized as the national tree of the Philippines.',
      category: 'National Symbols',
      difficulty: 'Easy',
    ),

    // =========================================================
    // GENERAL KNOWLEDGE
    // =========================================================

    TriviaQuestion(
      question: 'What currency is used in the Philippines?',
      choices: [
        'Dollar',
        'Peso',
        'Yen',
        'Ringgit',
      ],
      correctAnswerIndex: 1,
      explanation:
          'The official currency of the Philippines is the Philippine peso.',
      category: 'General Knowledge',
      difficulty: 'Easy',
    ),

    TriviaQuestion(
      question: 'What are the three main island groups of the Philippines?',
      choices: [
        'Luzon, Visayas, Mindanao',
        'Luzon, Palawan, Cebu',
        'Manila, Visayas, Mindanao',
        'Luzon, Samar, Leyte',
      ],
      correctAnswerIndex: 0,
      explanation:
          'The Philippines is commonly divided into Luzon, Visayas, and Mindanao.',
      category: 'General Knowledge',
      difficulty: 'Medium',
    ),
  ];

  static List<TriviaQuestion> getQuestions({
    required String category,
    required String difficulty,
  }) {
    return questions
        .where(
          (question) =>
              question.category == category &&
              question.difficulty == difficulty,
        )
        .toList();
  }
  static List<TriviaQuestion> getDailyQuestions() {
  final now = DateTime.now();

  final seed =
      (now.year * 10000) +
      (now.month * 100) +
      now.day;

  final random = Random(seed);

  final dailyQuestions =
      List<TriviaQuestion>.from(
    questions,
  );

  dailyQuestions.shuffle(
    random,
  );

  return dailyQuestions.take(10).toList();
}
}