import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:quiz_app/screens/home_screen.dart';
import 'package:quiz_app/screens/quiz_screen.dart';
import 'package:quiz_app/screens/results_screen.dart';
import 'notifiers/quiz_notifier.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(create: (_) => QuizNotifier(), child: App());
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final quizNotifier = context.read<QuizNotifier>();

    final router = GoRouter(
      refreshListenable: quizNotifier,
      redirect: (context, state) {
        final isResultRoute = state.matchedLocation == '/results';
        final isHomeRoute = state.matchedLocation == '/';
        final quizStarted = quizNotifier.isStarted;
        if (!isHomeRoute && !quizStarted) {
          return '/';
        }
        if (isResultRoute && quizStarted && !quizNotifier.isQuizComplete) {
          return '/quiz';
        }

        return null;
      },
      routes: [
        GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
        GoRoute(path: '/quiz', builder: (_, __) => const QuizScreen()),
        GoRoute(path: '/results', builder: (_, __) => const ResultsScreen()),
      ],
    );

    return MaterialApp.router(routerConfig: router);
  }
}
