import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:reaidy/data/datasource/interview_datasource.dart';
import 'package:reaidy/data/failure.dart';
import 'package:reaidy/data/server_exception.dart';
import 'package:reaidy/domain/entities/interview.dart';
import 'package:reaidy/domain/repositories/interview_repository.dart';

class InterviewRepositoryImpl implements InterviewRepository {
  final InterviewDataSource interviewDataSource;
  const InterviewRepositoryImpl({required this.interviewDataSource});
  @override
  Future<Either<Failure, List<Interview>>> fetchPastInterviews(
      String userId) async {
    try {
      final result = await interviewDataSource.fetchPastInterviews(userId);
      return Right(
          result.map((interviewModel) => interviewModel.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(
        Failure(message: e.message),
      );
    } on SocketException {
      return const Left(
        Failure(message: "No Internet Connection"),
      );
    }
  }
}
