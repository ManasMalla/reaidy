import 'package:equatable/equatable.dart';

class Interview extends Equatable {
  final String id;
  final String technology;
  final String levelOfInterview;
  final String interviewType;
  final bool isInterviewCompleted;
  final bool isResultPublished;
  final int numberOfQuestions;
  final DateTime createdAt;
  const Interview({
    required this.id,
    required this.technology,
    required this.levelOfInterview,
    required this.interviewType,
    required this.isInterviewCompleted,
    required this.isResultPublished,
    required this.numberOfQuestions,
    required this.createdAt,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}
