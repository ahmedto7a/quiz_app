// import 'package:flutter/material.dart';
//
// import '../models/question.dart';
// import '../models/quiz_user.dart';
// import '../services/quiz_service.dart';
//
//
// class QuizProvider extends ChangeNotifier {
//   int totalTime = 0;
//   List<Question> questions = [];
//   List<QuizUser> users = [];
//
//   QuizProvider() {
//     QuizService.getAllQuestions().then((value) {
//       questions = value;
//       notifyListeners();
//     });
//
//     QuizService.getTotalTime().then((value) {
//       totalTime = value;
//       notifyListeners();
//     });
//   }
//
//   Future<void> getAllUsers() async {
//     users = await QuizService.getAllUsers();
//     notifyListeners();
//   }
//
//   Future<void> updateHighscore(int currentScore) async {
//     await QuizService.updateHighscore(currentScore);
//   }
// }

/// ////////////////////////////////////////////
///
///
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/question.dart';
import '../services/quiz_service.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc() : super(QuizInitialState()) {

    on<FetchQuestionsEvent>(_fetchQuestions);
    on<FetchTotalTimeEvent>(_fetchTotalTime);
    on<UpdateHighscoreEvent>(_updateHighscore);
  }

  void _fetchQuestions(FetchQuestionsEvent event, Emitter<QuizState> emit) async {
    try {
      final questions = await QuizService.getAllQuestions();
      final totalTime = await QuizService.getTotalTime();
      emit(QuizLoadedState(questions, totalTime));
    } catch (e) {
      emit(QuizErrorState("Failed to fetch questions and total time."));
    }
  }

  // void _fetchAllUsers(FetchQuestionsEvent event, Emitter<QuizState> emit) async {
  //   try {
  //     final questions = await QuizService.getAllQuestions();
  //     final totalTime = await QuizService.getTotalTime();
  //     emit(QuizLoadedState(questions, totalTime));
  //   } catch (e) {
  //     emit(QuizErrorState("Failed to fetch questions and total time."));
  //   }
  // }

  void _fetchTotalTime(FetchTotalTimeEvent event, Emitter<QuizState> emit) async {
    try {
      final totalTime = await QuizService.getTotalTime();
      emit(QuizTotalTimeLoadedState(totalTime));
    } catch (e) {
      emit(QuizErrorState("Failed to fetch total time."));
    }
  }

  void _updateHighscore(UpdateHighscoreEvent event, Emitter<QuizState> emit) async {
    try {
      await QuizService.updateHighscore(event.currentScore);
    } catch (e) {
      emit(QuizErrorState("Failed to update highscore."));
    }
  }
}


class QuizTotalTimeLoadedState extends QuizState {
  final int totalTime;

  QuizTotalTimeLoadedState(this.totalTime);

  @override
  List<Object?> get props => [totalTime];
}

abstract class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object?> get props => [];
}

abstract class QuizEvent {}

class FetchQuestionsEvent extends QuizEvent {}

class FetchTotalTimeEvent extends QuizEvent {}

class FetchAllUser extends QuizEvent {}


class UpdateHighscoreEvent extends QuizEvent {
  final int currentScore;

  UpdateHighscoreEvent(this.currentScore);
}
// abstract class QuizState {}

class QuizInitialState extends QuizState {}

class QuizLoadingState extends QuizState {}

class QuizLoadedState extends QuizState {
  final List<Question> questions;
  final int totalTime;

  QuizLoadedState(this.questions, this.totalTime);
}

class QuizErrorState extends QuizState {
  final String errorMessage;

  QuizErrorState(this.errorMessage);
}
