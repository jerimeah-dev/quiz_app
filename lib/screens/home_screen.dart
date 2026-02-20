import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/notifiers/quiz_notifier.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz App'), centerTitle: true),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.quiz, size: 80, color: Theme.of(context).primaryColor),
            const SizedBox(height: 32),
            Text(
              'Welcome to Quiz App',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Text(
              'Test your knowledge with 10 questions',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 48),
            ElevatedButton(
              onPressed: () {
                context.read<QuizNotifier>().startQuiz();
                context.go('/quiz');
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 16,
                ),
              ),
              child: Selector<QuizNotifier, bool>(
                selector: (_, q) => q.isStarted,
                builder: (_, started, _) {
                  return Text(started ? 'Resume Quiz' : 'Start Quiz');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
