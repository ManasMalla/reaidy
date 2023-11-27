import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reaidy/domain/usecases/google_auth_usecase.dart';
import 'package:reaidy/domain/usecases/google_one_tap_auth_usecase.dart';
import 'package:reaidy/domain/usecases/interview_usecase.dart';
import 'package:reaidy/domain/usecases/login_usecase.dart';
import 'package:reaidy/presentation/bloc/auth/auth_event.dart';
import 'package:reaidy/presentation/bloc/auth/auth_state.dart';
import 'package:reaidy/presentation/bloc/interview/interview_event.dart';
import 'package:reaidy/presentation/bloc/interview/interview_state.dart';

class InterviewBloc extends Bloc<InterviewEvent, InterviewState> {
  final InterviewUsecase interviewUsecase;

  InterviewBloc({
    required this.interviewUsecase,
  }) : super(InterviewListLoadingState()) {
    on<FetchPastInterviews>((event, emit) async {
      emit(InterviewListLoadingState());
      final response =
          await interviewUsecase.getUserInterviews(event.intervieweeId);
      response.fold(
        (failure) => emit(
          InterviewFailureState(message: failure.message),
        ),
        (interviews) {
          emit(PastInterviewListState(interviews: interviews));
        },
      );
    });
    on<FetchSpecificInterview>((event, emit) async {
      emit(InterviewListLoadingState());
      final response =
          await interviewUsecase.fetchInterviewById(event.interviewId);
      response.fold(
        (failure) => emit(
          InterviewFailureState(message: failure.message),
        ),
        (interviews) {
          emit(SpecificInterviewState(interview: interviews));
        },
      );
    });
  }
}
