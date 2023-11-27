import 'package:equatable/equatable.dart';

abstract class InterviewEvent extends Equatable {
  const InterviewEvent();
  @override
  List<Object?> get props => [];
}

class FetchPastInterviews extends InterviewEvent {
  final String intervieweeId;
  const FetchPastInterviews({required this.intervieweeId});
}

class FetchSpecificInterview extends InterviewEvent {
  final String interviewId;
  const FetchSpecificInterview({required this.interviewId});
}

class OnCreateInterview extends InterviewEvent {
  final String technology;
  final String intervieweeId;
  final String name;
  final String levelOfDifficulty;
  final int numberOfQuestions;
  const OnCreateInterview({
    required this.technology,
    required this.intervieweeId,
    required this.name,
    required this.levelOfDifficulty,
    required this.numberOfQuestions,
  });
}

class ResetCreateInterviewState extends InterviewEvent {
  const ResetCreateInterviewState();
}

class FinishInterviewEvent extends InterviewEvent {
  final String interviewId;
  const FinishInterviewEvent({required this.interviewId});
}

class ContinueInterviewState extends InterviewEvent {
  final String interviewId;
  final String userResponse;
  const ContinueInterviewState({
    required this.interviewId,
    required this.userResponse,
  });
}
