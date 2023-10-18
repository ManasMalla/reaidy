import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:reaidy/data/failure.dart';
import 'package:reaidy/domain/entities/interview.dart';
import 'package:reaidy/domain/repositories/interview_repository.dart';

class InterviewUsecase {
  final InterviewRepository interviewRepository;
  const InterviewUsecase({required this.interviewRepository});
  Future<Either<Failure, List<Interview>>> getUserInterviews(String id) async {
    final result = interviewRepository.fetchPastInterviews(id);
    return result;
  }
}
