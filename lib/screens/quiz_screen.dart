import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:quiz_app/models/quiz_models.dart';
import '../notifiers/quiz_notifier.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final quizNotifier = context.read<QuizNotifier>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/'),
        ),
      ),

      body:
          Selector<
            QuizNotifier,
            ({
              Question question,
              int index,
              int total,
              int? selected,
              bool isLast,
              bool isComplete,
            })
          >(
            selector: (_, q) => (
              question: q.currentQuestion,
              index: q.currentQuestionIndex,
              total: q.quiz.totalQuestions,
              selected: q.getCurrentAnswer(),
              isLast: q.isLastQuestion,
              isComplete: q.isQuizComplete,
            ),

            builder: (context, view, _) {
              final questionNumber = view.index + 1;

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    LinearProgressIndicator(
                      value: questionNumber / view.total,
                      minHeight: 8,
                    ),

                    const SizedBox(height: 16),

                    Text(
                      'Question $questionNumber / ${view.total}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),

                    const SizedBox(height: 24),

                    Text(
                      view.question.question,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 32),

                    Expanded(
                      child: ListView.builder(
                        itemCount: view.question.options.length,
                        itemBuilder: (context, i) {
                          final isSelected = view.selected == i;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isSelected
                                    ? Theme.of(context).primaryColor
                                    : Colors.grey[200],
                                foregroundColor: isSelected
                                    ? Colors.white
                                    : Colors.black,
                                padding: const EdgeInsets.all(16),
                              ),

                              onPressed: view.isComplete
                                  ? null
                                  : () => context
                                        .read<QuizNotifier>()
                                        .selectAnswer(i),

                              child: Text(
                                view.question.options[i],
                                style: const TextStyle(fontSize: 16),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 24),

                    Row(
                      children: [
                        if (view.index > 0)
                          Expanded(
                            child: OutlinedButton(
                              onPressed: view.isComplete
                                  ? null
                                  : () => context
                                        .read<QuizNotifier>()
                                        .previousQuestion(),
                              child: const Text('Previous'),
                            ),
                          )
                        else
                          const Spacer(),

                        const SizedBox(width: 16),

                        Expanded(
                          child: ElevatedButton(
                            onPressed: view.isLast
                                ? () => context.go('/results')
                                : quizNotifier.canGoNext
                                ? () {
                                    quizNotifier.nextQuestion();
                                  }
                                : null,
                            child: Text(view.isLast ? 'Submit' : 'Next'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
    );
  }
}
