import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:reaidy/data/datasource/courses_datasource.dart';
import 'package:reaidy/data/datasource/interview_datasource.dart';
import 'package:reaidy/data/failure.dart';
import 'package:reaidy/data/server_exception.dart';
import 'package:reaidy/domain/entities/course.dart';
import 'package:reaidy/domain/entities/interview.dart';
import 'package:reaidy/domain/repositories/courses_repository.dart';

class CoursesRepositoryImpl implements CoursesRepository {
  final CoursesDataSource coursesDataSource;
  const CoursesRepositoryImpl({required this.coursesDataSource});

  @override
  Future<Either<Failure, List<Course>>> fetchAllCourses() async {
    try {
      final result = await coursesDataSource.fetchAllCourses();
      return Right(
          result.map((coursesModel) => coursesModel.toEntity()).toList());
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
  Future<Either<Failure, List<Course>>> fetchUserEnrolledCourses(
      String userId) async {
    try {
      final result = await coursesDataSource.fetchUserEnrolledCourses(userId);
      return Right(
          result.map((coursesModel) => coursesModel.toEntity()).toList());
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
