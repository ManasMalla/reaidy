import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:reaidy/data/failure.dart';
import 'package:reaidy/domain/entities/interview.dart';
import 'package:reaidy/domain/entities/interview_response.dart';
import 'package:reaidy/domain/repositories/interview_repository.dart';

class InterviewUsecase {
  final InterviewRepository interviewRepository;
  const InterviewUsecase({required this.interviewRepository});
  Future<Either<Failure, List<Interview>>> getUserInterviews(String id) async {
    final result = interviewRepository.fetchPastInterviews(id);
    return result;
  }

  Future<Either<Failure, Map<String, dynamic>>> fetchInterviewById(
      String id) async {
    final result = interviewRepository.fetchInterviewById(id);
    return result;
  }

  Future<Either<Failure, InterviewResponse>> createInterview(
    String technology,
    String intervieeId,
    String name,
    String levelOfDifficulty,
    int numberOfQuestions,
  ) async {
    final result = interviewRepository.createInterview(
        technology, intervieeId, name, levelOfDifficulty, numberOfQuestions);
    return result;
  }

  Future<Either<Failure, List<InterviewResponse>>> continueInterview(
    String interviewId,
    String userResponse,
    String name,
    InterviewResponse previousResponse,
  ) {
    final result = interviewRepository.continueInterview(
        interviewId, userResponse, name, previousResponse);
    return result;
  }

  Future<Either<Failure, void>> finishInterview(String interviewId) {
    final result = interviewRepository.finishInterview(interviewId);
    return result;
  }
}
