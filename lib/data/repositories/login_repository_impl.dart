import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:reaidy/data/datasource/login_datasource.dart';
import 'package:reaidy/data/failure.dart';
import 'package:reaidy/data/server_exception.dart';
import 'package:reaidy/domain/entities/google_oauth_result.dart';
import 'package:reaidy/domain/entities/user.dart';
import 'package:reaidy/domain/repositories/login_repository.dart';

class LoginRepositoryImpl implements LoginRepository {
  final LoginDataSource loginDataSource;

  const LoginRepositoryImpl({
    required this.loginDataSource,
  });

  @override
  Future<Either<Failure, User>> login(
      GoogleOAuthResult googleAuthResult) async {
    try {
      final result = await loginDataSource.login(googleAuthResult);
      return Right(result.toEntity());
    } on LoginException catch (exception) {
      return Left(
        Failure(
          message: "Please register yourself",
          data: {
            "userRoles": exception.userRoles,
            "displayName": exception.displayName,
          },
        ),
      );
    } on ServerException catch (exception) {
      return Left(
        Failure(message: exception.message),
      );
    } on SocketException catch (exception) {
      return Left(
        Failure(message: exception.message),
      );
    }
  }

  @override
  Future<Either<Failure, User>> updateUser(
      {required String googleId,
      required Map<String, dynamic> userData}) async {
    try {
      final result = await loginDataSource.updateUser(
          googleId: googleId, userData: userData);
      return Right(result.toEntity());
    } on ServerException catch (exception) {
      return Left(
        Failure(message: exception.message),
      );
    } on SocketException catch (exception) {
      return Left(
        Failure(message: exception.message),
      );
    }
  }
}
