import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../notifiers/quiz_notifier.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: _QuizAppBar(),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _Header(),
            SizedBox(height: 48),
            _QuestionText(),
            SizedBox(height: 32),
            Expanded(child: _OptionsList()),
            SizedBox(height: 24),
            _NavigationButtons(),
          ],
        ),
      ),
    );
  }
}

class _QuizAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _QuizAppBar();

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('Quiz'),
      centerTitle: true,
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => context.pop(),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Selector<QuizNotifier, ({int index, int total})>(
      selector: (_, q) =>
          (index: q.currentQuestionIndex, total: q.quiz.totalQuestions),
      child: const Text('Quiz Progress', style: TextStyle(fontSize: 30)),
      builder: (_, view, child) {
        final number = view.index + 1;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            child!,
            const SizedBox(height: 12),
            LinearProgressIndicator(value: number / view.total),
            const SizedBox(height: 8),
            Text('Question $number / ${view.total}'),
          ],
        );
      },
    );
  }
}

class _QuestionText extends StatelessWidget {
  const _QuestionText();

  @override
  Widget build(BuildContext context) {
    return Selector<QuizNotifier, String>(
      selector: (_, q) => q.currentQuestion.question,
      builder: (_, text, _) {
        return Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        );
      },
    );
  }
}

class _OptionsList extends StatelessWidget {
  const _OptionsList();

  @override
  Widget build(BuildContext context) {
    final question = context.read<QuizNotifier>().currentQuestion;

    return ListView.builder(
      itemCount: question.options.length,
      itemBuilder: (_, i) => _OptionTile(i),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final int index;
  const _OptionTile(this.index);

  @override
  Widget build(BuildContext context) {
    return Selector<QuizNotifier, (bool selected, bool disabled, String text)>(
      selector: (_, q) {
        final question = q.currentQuestion;

        return (
          q.getCurrentAnswer() == index,
          q.isQuizComplete,
          question.options[index],
        );
      },
      builder: (_, data, __) {
        final (selected, disabled, text) = data;

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: selected
                  ? Theme.of(context).primaryColor
                  : Colors.grey[200],
              foregroundColor: selected ? Colors.white : Colors.black,
              padding: const EdgeInsets.all(16),
            ),
            onPressed: disabled
                ? null
                : () => context.read<QuizNotifier>().selectAnswer(index),
            child: Text(text, style: const TextStyle(fontSize: 16)),
          ),
        );
      },
    );
  }
}

class _NavigationButtons extends StatelessWidget {
  const _NavigationButtons();

  @override
  Widget build(BuildContext context) {
    return Selector<
      QuizNotifier,
      ({int index, bool canNext, bool last, bool complete})
    >(
      selector: (_, q) => (
        index: q.currentQuestionIndex,
        canNext: q.canGoNext,
        last: q.isLastQuestion,
        complete: q.isQuizComplete,
      ),
      builder: (_, view, __) {
        final quiz = context.read<QuizNotifier>();

        return Row(
          children: [
            if (view.index > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: view.complete ? null : quiz.previousQuestion,
                  child: const Text('Previous'),
                ),
              )
            else
              const Spacer(),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: view.canNext
                    ? () {
                        if (view.last) {
                          quiz.submitQuiz();
                          context.go('/results');
                        } else {
                          quiz.nextQuestion();
                        }
                      }
                    : null,
                child: Text(view.last ? 'Submit' : 'Next'),
              ),
            ),
          ],
        );
      },
    );
  }
}
