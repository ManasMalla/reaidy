import 'package:dartz/dartz.dart';
import 'package:reaidy/data/failure.dart';
import 'package:reaidy/domain/entities/google_oauth_result.dart';
import 'package:reaidy/domain/entities/user.dart';

abstract class LoginRepository {
  Future<Either<Failure, User>> login(GoogleOAuthResult googleAuthResult);

  Future<Either<Failure, User>> updateUser(
      {required String googleId, required Map<String, dynamic> userData});
}
