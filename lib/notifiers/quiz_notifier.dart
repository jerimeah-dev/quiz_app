import 'package:flutter/foundation.dart';
import '../models/quiz_models.dart';

final List<Question> sampleQuestions = [
  Question(
    id: 1,
    question: 'What is the capital of France?',
    options: ['London', 'Berlin', 'Paris', 'Madrid'],
    correctOptionIndex: 2,
  ),
  Question(
    id: 2,
    question: 'Which planet is known as the Red Planet?',
    options: ['Venus', 'Mars', 'Jupiter', 'Saturn'],
    correctOptionIndex: 1,
  ),
  Question(
    id: 3,
    question: 'What is the largest ocean on Earth?',
    options: ['Atlantic', 'Indian', 'Arctic', 'Pacific'],
    correctOptionIndex: 3,
  ),
  Question(
    id: 4,
    question: 'Who painted the Mona Lisa?',
    options: [
      'Vincent van Gogh',
      'Leonardo da Vinci',
      'Pablo Picasso',
      'Michelangelo',
    ],
    correctOptionIndex: 1,
  ),
  Question(
    id: 5,
    question: 'What is the chemical symbol for Gold?',
    options: ['Go', 'Gd', 'Au', 'Ag'],
    correctOptionIndex: 2,
  ),
  Question(
    id: 6,
    question: 'Which country is home to the Great Wall?',
    options: ['Japan', 'Korea', 'China', 'Vietnam'],
    correctOptionIndex: 2,
  ),
  Question(
    id: 7,
    question: 'What is the smallest prime number?',
    options: ['0', '1', '2', '3'],
    correctOptionIndex: 2,
  ),
  Question(
    id: 8,
    question: 'Which tree is known to live the longest?',
    options: ['Oak', 'Bristlecone Pine', 'Redwood', 'Cypress'],
    correctOptionIndex: 1,
  ),
  Question(
    id: 9,
    question: 'What is the currency of Japan?',
    options: ['Won', 'Pound', 'Yen', 'Rupee'],
    correctOptionIndex: 2,
  ),
  Question(
    id: 10,
    question: 'Which element has the atomic number 1?',
    options: ['Helium', 'Hydrogen', 'Lithium', 'Beryllium'],
    correctOptionIndex: 1,
  ),
];

class QuizNotifier extends ChangeNotifier {
  late Quiz _quiz;
  int _currentQuestionIndex = 0;
  bool get canGoNext => getCurrentAnswer() != null;

  QuizNotifier() {
    _quiz = Quiz(questions: sampleQuestions);
  }

  Quiz get quiz => _quiz;
  int get currentQuestionIndex => _currentQuestionIndex;

  Question get currentQuestion {
    if (_currentQuestionIndex >= _quiz.questions.length) {
      return _quiz.questions.last;
    }
    return _quiz.questions[_currentQuestionIndex];
  }

  bool get hasNextQuestion =>
      _currentQuestionIndex < _quiz.questions.length - 1;
  bool get isLastQuestion =>
      _currentQuestionIndex == _quiz.questions.length - 1;
  bool get isQuizComplete => _quiz.isAllAnswered;

  void selectAnswer(int optionIndex) {
    _quiz.selectAnswer(currentQuestion.id, optionIndex);
    notifyListeners();
  }

  void nextQuestion() {
    if (!canGoNext) return;
    if (hasNextQuestion) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (_currentQuestionIndex > 0) {
      _currentQuestionIndex--;
      notifyListeners();
    }
  }

  void submitQuiz() {
    notifyListeners();
  }

  void resetQuiz() {
    _quiz = Quiz(questions: sampleQuestions);
    _currentQuestionIndex = 0;
    notifyListeners();
  }

  int? getCurrentAnswer() {
    return _quiz.userAnswers[currentQuestion.id];
  }
}
