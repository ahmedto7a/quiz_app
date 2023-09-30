
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz/screens/quiz_screen.dart';
import '../bloc/quiz_bloc.dart';
import '../components/action_button.dart';
import '../components/gradient_box.dart';
import '../components/rank_auth_button.dart';
import '../models/question.dart';

class ResultScreen extends StatelessWidget {
  final int score;
  final List<Question> questions;
  final int totalTime;

  ResultScreen({
    required this.score,
    required this.questions,
    required this.totalTime,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<QuizBloc, QuizState>(
        builder: (context, state) {
          return SizedBox.expand(
            child: GradientBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Result: $score / ${questions.length}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                    ),
                  ),
                  SizedBox(height: 40),
                  ActionButton(
                    title: 'Play Again',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => QuizScreen(
                            totalTime: totalTime,
                            questions: questions,
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: 40),
                  RankAuthButton()
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
