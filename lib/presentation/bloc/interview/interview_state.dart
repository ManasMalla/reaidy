import 'package:equatable/equatable.dart';
import 'package:reaidy/domain/entities/interview.dart';

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
