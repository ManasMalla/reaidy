import 'package:equatable/equatable.dart';

class InterviewResponse extends Equatable {
  final String interviewId;
  final String response;
  final String role;
  final int index;
  final int totalQuestions;
  final String topic;
  final String interviewee;

  const InterviewResponse({
    required this.interviewId,
    required this.response,
    required this.role,
    required this.index,
    required this.totalQuestions,
    required this.topic,
    required this.interviewee,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [interviewId, response, index];
}
