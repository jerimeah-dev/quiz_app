import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../notifiers/quiz_notifier.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: _ResultsAppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ScoreCard(),
            SizedBox(height: 32),
            _StatsCard(),
            SizedBox(height: 32),
            _QuestionReviewList(),
            SizedBox(height: 16),
            _RetakeButton(),
          ],
        ),
      ),
    );
  }
}

class _ResultsAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _ResultsAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Results'),
      centerTitle: true,
      leading: const SizedBox(),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _ScoreCard extends StatelessWidget {
  const _ScoreCard();

  @override
  Widget build(BuildContext context) {
    return Selector<QuizNotifier, (int, int, double)>(
      selector: (_, q) => (
        q.quiz.correctAnswers,
        q.quiz.totalQuestions,
        q.quiz.scorePercentage,
      ),
      child: const Column(
        children: [Text('Quiz Completed!'), SizedBox(height: 20)],
      ),
      builder: (_, data, child) {
        final (correct, total, percent) = data;

        return Card(
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                child!,
                Text(
                  '$correct/$total',
                  style: Theme.of(context).textTheme.displayMedium,
                ),
                Text('${percent.toStringAsFixed(1)}% Correct'),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatsCard extends StatelessWidget {
  const _StatsCard();

  @override
  Widget build(BuildContext context) {
    return Selector<QuizNotifier, (int, int)>(
      selector: (_, q) => (q.quiz.correctAnswers, q.quiz.totalQuestions),
      builder: (_, data, __) {
        final (correct, total) = data;

        return Card(
          child: Column(
            children: [
              _StatRow('Correct Answers', '$correct'),
              const Divider(),
              _StatRow('Wrong Answers', '${total - correct}'),
              const Divider(),
              _StatRow('Total Questions', '$total'),
            ],
          ),
        );
      },
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _QuestionReviewList extends StatelessWidget {
  const _QuestionReviewList();

  @override
  Widget build(BuildContext context) {
    final total = context.read<QuizNotifier>().quiz.totalQuestions;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: total,
      itemBuilder: (_, index) => _QuestionCard(index),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final int index;
  const _QuestionCard(this.index);

  @override
  Widget build(BuildContext context) {
    return Selector<
      QuizNotifier,
      (String question, String user, String correct, bool isCorrect)
    >(
      selector: (_, q) {
        final question = q.quiz.questions[index];

        final userIndex = q.quiz.userAnswers[question.id];

        final userText = userIndex != null
            ? question.options[userIndex]
            : 'Not answered';

        final correctText = question.options[question.correctOptionIndex];

        final isCorrect = userIndex == question.correctOptionIndex;

        return (question.question, userText, correctText, isCorrect);
      },
      builder: (_, data, __) {
        final (questionText, userText, correctText, isCorrect) = data;

        return Card(
          color: isCorrect ? Colors.green[50] : Colors.red[50],
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  questionText,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                Text('Your answer: $userText'),

                if (!isCorrect) ...[
                  const SizedBox(height: 4),
                  Text(
                    'Correct answer: $correctText',
                    style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RetakeButton extends StatelessWidget {
  const _RetakeButton();

  @override
  Widget build(BuildContext context) {
    final quiz = context.read<QuizNotifier>();

    return OutlinedButton.icon(
      onPressed: () {
        quiz.resetQuiz();
      },
      icon: const Icon(Icons.refresh),
      label: const Text('Retake Quiz'),
    );
  }
}
