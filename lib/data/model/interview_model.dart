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
  final double communication;
  final double technical;
  final double overall;
  const InterviewModel({
    required this.id,
    required this.technology,
    required this.levelOfInterview,
    required this.interviewType,
    required this.isInterviewCompleted,
    required this.isResultPublished,
    required this.numberOfQuestions,
    required this.createdAt,
    required this.communication,
    required this.technical,
    required this.overall,
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
        communication: json["result"].isEmpty
            ? 0.0
            : json["result"]
                .where((e) => e["name"] == "communication_score")
                .first["score"]
                .toDouble(),
        technical: json["result"].isEmpty
            ? 0.0
            : json["result"]
                .where((e) => e["name"] == "technical_score")
                .first["score"]
                .toDouble(),
        overall: json["result"].isEmpty
            ? 0.0
            : json["result"]
                .where((e) => e["name"] == "average_technical_score")
                .first["score"]
                .toDouble(),
      );

  Interview toEntity() => Interview(
        id: id,
        technology: technology,
        levelOfInterview: levelOfInterview,
        interviewType: interviewType,
        isInterviewCompleted: isInterviewCompleted,
        isResultPublished: isResultPublished,
        numberOfQuestions: numberOfQuestions,
        createdAt: DateTime.fromMillisecondsSinceEpoch(createdAt),
        communication: communication.toInt(),
        technical: technical.toInt(),
        overall: overall.toInt(),
      );
}
