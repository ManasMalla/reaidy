import 'package:equatable/equatable.dart';
import 'package:reaidy/domain/entities/interview.dart';
import 'package:reaidy/domain/entities/interview_response.dart';

class InterviewState extends Equatable {
  const InterviewState();
  @override
  List<Object?> get props => [];
}

class InterviewListLoadingState extends InterviewState {}

class PastInterviewListState extends InterviewState {
  final List<Interview> interviews;
  const PastInterviewListState({required this.interviews});
}

class InterviewFailureState extends InterviewState {
  final String message;
  const InterviewFailureState({required this.message});
}

class SpecificInterviewState extends InterviewState {
  final Map<String, dynamic> interview;
  const SpecificInterviewState({required this.interview});
}

class CreatedInterviewState extends InterviewState {
  final List<InterviewResponse> interviewResponse;
  const CreatedInterviewState({required this.interviewResponse});
  @override
  // TODO: implement props
  List<Object?> get props => [interviewResponse];
}

class ServerLoadingInterviewState extends CreatedInterviewState {
  const ServerLoadingInterviewState({required super.interviewResponse});
  @override
  // TODO: implement props
  List<Object?> get props => [super.interviewResponse];
}

class CreateInterviewState extends InterviewState {
  const CreateInterviewState();
}
