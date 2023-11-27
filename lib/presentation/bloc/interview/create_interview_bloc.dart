import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reaidy/domain/usecases/interview_usecase.dart';
import 'package:reaidy/presentation/bloc/interview/interview_event.dart';
import 'package:reaidy/presentation/bloc/interview/interview_state.dart';

class CreateInterviewBloc extends Bloc<InterviewEvent, InterviewState> {
  final InterviewUsecase interviewUsecase;
  CreateInterviewBloc({required this.interviewUsecase})
      : super(const CreateInterviewState()) {
    on<ResetCreateInterviewState>(
        (event, emit) => emit(const CreateInterviewState()));
    on<OnCreateInterview>((event, emit) async {
      emit(InterviewListLoadingState());
      final result = await interviewUsecase.createInterview(
        event.technology,
        event.intervieweeId,
        event.name,
        event.levelOfDifficulty,
        event.numberOfQuestions,
      );
      result.fold(
        (failure) => emit(InterviewFailureState(message: failure.message)),
        (response) =>
            emit(CreatedInterviewState(interviewResponse: [response])),
      );
    });
    on<ContinueInterviewState>((event, emit) async {
      final list = (state as CreatedInterviewState).interviewResponse;
      emit(ServerLoadingInterviewState(interviewResponse: list));
      final result = await interviewUsecase.continueInterview(
        event.interviewId,
        event.userResponse,
        (list.lastOrNull ?? list.first).interviewee,
        list.lastOrNull ?? list.first,
      );
      result.fold(
        (failure) => emit(InterviewFailureState(message: failure.message)),
        (response) => emit(
          CreatedInterviewState(
            interviewResponse: list..addAll(response),
          ),
        ),
      );
    });
    on<FinishInterviewEvent>((event, emit) async {
      emit(InterviewListLoadingState());
      final finishInterviewResult =
          await interviewUsecase.finishInterview(event.interviewId);
      finishInterviewResult.fold((failure) {
        emit(InterviewFailureState(message: failure.message));
      }, (_) async {
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
    });
  }
}
