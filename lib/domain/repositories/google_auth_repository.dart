import 'package:dartz/dartz.dart';
import 'package:google_one_tap_sign_in/google_one_tap_sign_in.dart';
import 'package:reaidy/data/failure.dart';
import 'package:reaidy/domain/entities/google_oauth_result.dart';

abstract class GoogleAuthRepository {
  Future<Either<Failure, GoogleOAuthResult>> signIn();
}
