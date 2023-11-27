import 'package:dartz/dartz.dart';
import 'package:reaidy/data/failure.dart';
import 'package:reaidy/domain/entities/interview.dart';
import 'package:reaidy/domain/entities/interview_response.dart';

abstract class InterviewRepository {
  Future<Either<Failure, List<Interview>>> fetchPastInterviews(String userId);
  Future<Either<Failure, Map<String, dynamic>>> fetchInterviewById(
      String interviewId);

  Future<Either<Failure, InterviewResponse>> createInterview(
      String technology,
      String intervieeId,
      String name,
      String levelOfDifficulty,
      int numberOfQuestions);

  Future<Either<Failure, List<InterviewResponse>>> continueInterview(
      String interviewId,
      String userResponse,
      String name,
      InterviewResponse previousResponse);

  Future<Either<Failure, void>> finishInterview(String interviewId);
}
