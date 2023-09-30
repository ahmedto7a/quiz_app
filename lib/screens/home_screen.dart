
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz/screens/quiz_screen.dart';
import '../bloc/quiz_bloc.dart';
import '../components/action_button.dart';
import '../components/gradient_box.dart';
import '../components/rank_auth_button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<QuizBloc, QuizState>(
        builder: (context, state) {
          if (state is QuizInitialState) {
            BlocProvider.of<QuizBloc>(context).add(FetchQuestionsEvent());
            BlocProvider.of<QuizBloc>(context).add(FetchTotalTimeEvent());
            return Center(child: CircularProgressIndicator());
          } else if (state is QuizLoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is QuizLoadedState) {
            final provider = state;
            return SizedBox.expand(
              child: GradientBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'QUIZ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                      ),
                    ),
                    SizedBox(height: 40),
                    ActionButton(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => QuizScreen(
                              totalTime: provider.totalTime,
                              questions: provider.questions,
                            ),
                          ),
                        );
                      },
                      title: 'Start',
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Total Questions: ${provider.questions.length}',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 70),
                    RankAuthButton()
                  ],
                ),
              ),
            );
          } else if (state is QuizErrorState) {
            return Center(child: Text(state.errorMessage));
          } else {
            return Center(child: Text('Unknown State'));
          }
        },
      ),
    );
  }
}
