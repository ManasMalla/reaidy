import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:reaidy/data/datasource/interview_datasource.dart';
import 'package:reaidy/data/failure.dart';
import 'package:reaidy/data/server_exception.dart';
import 'package:reaidy/domain/entities/interview.dart';
import 'package:reaidy/domain/entities/interview_response.dart';
import 'package:reaidy/domain/repositories/interview_repository.dart';

class InterviewRepositoryImpl implements InterviewRepository {
  final InterviewDataSource interviewDataSource;
  final FlutterTts flutterTts;
  const InterviewRepositoryImpl(
      {required this.interviewDataSource, required this.flutterTts});
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

  @override
  Future<Either<Failure, Map<String, dynamic>>> fetchInterviewById(
      String interviewId) async {
    try {
      final result = await interviewDataSource.fetchInterviewById(interviewId);
      return Right(result);
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

  @override
  Future<Either<Failure, InterviewResponse>> createInterview(
      String technology,
      String intervieeId,
      String name,
      String levelOfDifficulty,
      int numberOfQuestions) async {
    try {
      final result = await interviewDataSource.createInterview(
        technology,
        intervieeId,
        name,
        levelOfDifficulty,
        numberOfQuestions,
      );
      await flutterTts.setLanguage("en-US");
      flutterTts.speak(result.response.split("Lucy:").last);
      return Right(result);
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

  @override
  Future<Either<Failure, List<InterviewResponse>>> continueInterview(
      String interviewId,
      String userResponse,
      String name,
      InterviewResponse previousResponse) async {
    try {
      final result = await interviewDataSource.continueInterview(
        interviewId,
        userResponse,
        name,
        previousResponse,
      );

      await flutterTts.setLanguage("en-US");
      flutterTts.speak(result
          .where((element) => element.role.toLowerCase() == "assistant")
          .first
          .response
          .split("Lucy:")
          .last);
      return Right(result);
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

  @override
  Future<Either<Failure, void>> finishInterview(String interviewId) async {
    try {
      final result = await interviewDataSource.finishInterview(interviewId);
      return Right(result);
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
