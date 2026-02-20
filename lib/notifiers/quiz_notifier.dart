import 'package:flutter/foundation.dart';
import '../models/quiz_models.dart';

final List<Question> sampleQuestions = [
  Question(
    id: 1,
    question: 'What is the main purpose of the BuildContext in Flutter?',
    options: [
      'Stores widget state permanently',
      'Access location in the widget tree and inherited data',
      'Handles navigation automatically',
      'Caches widgets for performance',
    ],
    correctOptionIndex: 1,
  ),
  Question(
    id: 2,
    question:
        'Which method is called every time Flutter needs to redraw a widget?',
    options: ['initState()', 'didChangeDependencies()', 'build()', 'dispose()'],
    correctOptionIndex: 2,
  ),
  Question(
    id: 3,
    question:
        'What is the difference between StatelessWidget and StatefulWidget?',
    options: [
      'Stateless is faster only',
      'Stateful stores mutable state separately using State object',
      'Stateless cannot have children',
      'Stateful cannot rebuild',
    ],
    correctOptionIndex: 1,
  ),
  Question(
    id: 4,
    question:
        'Which widget helps prevent unnecessary rebuilds of child widgets?',
    options: ['Expanded', 'Builder', 'const constructor', 'Scaffold'],
    correctOptionIndex: 2,
  ),
  Question(
    id: 5,
    question:
        'What happens when notifyListeners() is called in ChangeNotifier?',
    options: [
      'App restarts',
      'All widgets rebuild',
      'Listening widgets rebuild',
      'State is cleared',
    ],
    correctOptionIndex: 2,
  ),
  Question(
    id: 6,
    question: 'Which is TRUE about the Flutter rendering pipeline?',
    options: [
      'Widgets render directly to screen',
      'Build → Layout → Paint → Compositing',
      'Paint happens before layout',
      'Only layout phase exists',
    ],
    correctOptionIndex: 1,
  ),
  Question(
    id: 7,
    question: 'When should you use FutureBuilder?',
    options: [
      'For synchronous data only',
      'To cache widgets',
      'To react to async computation results',
      'To manage animations',
    ],
    correctOptionIndex: 2,
  ),
  Question(
    id: 8,
    question: 'What is the benefit of using keys in Flutter widgets?',
    options: [
      'Improve network speed',
      'Prevent rebuilds entirely',
      'Preserve widget identity during tree changes',
      'Enable hot reload',
    ],
    correctOptionIndex: 2,
  ),
  Question(
    id: 9,
    question: 'Which approach reduces rebuild scope for better performance?',
    options: [
      'setState() at root widget',
      'Using Selector/Consumer for partial rebuilds',
      'Calling build() manually',
      'Using more StatefulWidgets',
    ],
    correctOptionIndex: 1,
  ),
  Question(
    id: 10,
    question: 'What does const in Flutter widgets primarily provide?',
    options: [
      'Async behavior',
      'Memory allocation at runtime',
      'Compile-time canonicalization and fewer rebuilds',
      'Bigger widget trees',
    ],
    correctOptionIndex: 2,
  ),
];

class QuizNotifier extends ChangeNotifier {
  Quiz _quiz = Quiz(questions: sampleQuestions);
  int _currentQuestionIndex = 0;
  bool isSubmitted = false;
  bool isStarted = false;

  bool get canGoNext => getCurrentAnswer() != null;
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
  bool get isQuizComplete => _quiz.isAllAnswered && isSubmitted;

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
    isSubmitted = true;
    notifyListeners();
  }

  void resetQuiz() {
    isSubmitted = false;
    isStarted = false;
    _quiz = Quiz(questions: sampleQuestions);
    _currentQuestionIndex = 0;
    notifyListeners();
  }

  void startQuiz() {
    isStarted = true;
    notifyListeners();
  }

  int? getCurrentAnswer() {
    return _quiz.userAnswers[currentQuestion.id];
  }
}
