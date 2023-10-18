import 'package:equatable/equatable.dart';
import 'package:reaidy/domain/entities/interview.dart';

class InterviewModel extends Equatable {
  final String id;
  final String technology;
  final String levelOfInterview;
  final String interviewType;
  final bool isInterviewCompleted;
  final bool isResultPublished;
  final int numberOfQuestions;
  final int createdAt;
  const InterviewModel({
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

  factory InterviewModel.fromJson(Map<String, dynamic> json) => InterviewModel(
        id: json["_id"],
        technology: json["technology"],
        levelOfInterview: json["levelOfInterview"],
        interviewType: json["interviewType"],
        isInterviewCompleted: json["isInterviewCompleted"],
        isResultPublished: json["isResultPublished"],
        numberOfQuestions: json["noOfQuestions"],
        createdAt: json["createdAt"],
      );

  Interview toEntity() => Interview(
        id: id,
        technology: technology,
        levelOfInterview: levelOfInterview,
        interviewType: interviewType,
        isInterviewCompleted: isInterviewCompleted,
        isResultPublished: isResultPublished,
        numberOfQuestions: numberOfQuestions,
        createdAt: DateTime.fromMicrosecondsSinceEpoch(createdAt),
      );
}
