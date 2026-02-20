class Question {
  final int id;
  final String question;
  final List<String> options;
  final int correctOptionIndex;

  Question({
    required this.id,
    required this.question,
    required this.options,
    required this.correctOptionIndex,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'],
      question: json['question'],
      options: List<String>.from(json['options']),
      correctOptionIndex: json['correctOptionIndex'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'question': question,
      'options': options,
      'correctOptionIndex': correctOptionIndex,
    };
  }
}

class Quiz {
  final List<Question> questions;
  final Map<int, int> userAnswers;

  Quiz({required this.questions, Map<int, int>? userAnswers})
    : userAnswers = userAnswers ?? <int, int>{};

  int get totalQuestions => questions.length;

  int get correctAnswers {
    int correct = 0;
    for (var question in questions) {
      if (userAnswers[question.id] == question.correctOptionIndex) {
        correct++;
      }
    }
    return correct;
  }

  double get scorePercentage {
    if (totalQuestions == 0) return 0;
    return (correctAnswers / totalQuestions) * 100;
  }

  bool isAnswered(int questionId) {
    return userAnswers.containsKey(questionId);
  }

  void selectAnswer(int questionId, int optionIndex) {
    userAnswers[questionId] = optionIndex;
  }

  bool get isAllAnswered =>
      questions.every((q) => userAnswers.containsKey(q.id));
}
