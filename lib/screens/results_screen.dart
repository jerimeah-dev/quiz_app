import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../notifiers/quiz_notifier.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        centerTitle: true,
        leading: const SizedBox(),
      ),
      body: Consumer<QuizNotifier>(
        builder: (context, quizNotifier, _) {
          final quiz = quizNotifier.quiz;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Text(
                          'Quiz Completed!',
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          '${quiz.correctAnswers}/${quiz.totalQuestions}',
                          style: Theme.of(context).textTheme.displayMedium
                              ?.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${quiz.scorePercentage.toStringAsFixed(1)}% Correct',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                Text(
                  'Statistics',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        _StatRow(
                          label: 'Correct Answers',
                          value: '${quiz.correctAnswers}',
                        ),
                        const Divider(),
                        _StatRow(
                          label: 'Wrong Answers',
                          value: '${quiz.totalQuestions - quiz.correctAnswers}',
                        ),
                        const Divider(),
                        _StatRow(
                          label: 'Total Questions',
                          value: '${quiz.totalQuestions}',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                Text(
                  'Question Review',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: quiz.questions.length,
                  itemBuilder: (context, index) {
                    final question = quiz.questions[index];
                    final userAnswerIndex = quiz.userAnswers[question.id];
                    final isCorrect =
                        userAnswerIndex == question.correctOptionIndex;

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      color: isCorrect ? Colors.green[50] : Colors.red[50],
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  isCorrect ? Icons.check_circle : Icons.cancel,
                                  color: isCorrect ? Colors.green : Colors.red,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Q${index + 1}: ${question.question}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            _AnswerDisplay(
                              label: 'Your Answer:',
                              answer: userAnswerIndex != null
                                  ? question.options[userAnswerIndex]
                                  : 'Not answered',
                              isCorrect: isCorrect,
                            ),
                            if (!isCorrect) ...[
                              const SizedBox(height: 8),
                              _AnswerDisplay(
                                label: 'Correct Answer:',
                                answer: question
                                    .options[question.correctOptionIndex],
                                isCorrect: true,
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                ElevatedButton.icon(
                  onPressed: () {
                    quizNotifier.resetQuiz();
                    context.go('/');
                  },
                  icon: const Icon(Icons.home),
                  label: const Text('Back to Home'),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () {
                    quizNotifier.resetQuiz();
                    context.go('/quiz');
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retake Quiz'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class _AnswerDisplay extends StatelessWidget {
  final String label;
  final String answer;
  final bool isCorrect;

  const _AnswerDisplay({
    required this.label,
    required this.answer,
    required this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(
            border: Border.all(color: isCorrect ? Colors.green : Colors.red),
            borderRadius: BorderRadius.circular(4),
          ),
          child: Text(answer, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}
