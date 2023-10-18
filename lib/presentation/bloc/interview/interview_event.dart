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
