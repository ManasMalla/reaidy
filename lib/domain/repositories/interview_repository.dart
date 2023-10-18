import 'package:dartz/dartz.dart';
import 'package:reaidy/data/failure.dart';
import 'package:reaidy/domain/entities/interview.dart';

abstract class InterviewRepository {
  Future<Either<Failure, List<Interview>>> fetchPastInterviews(String userId);
}
