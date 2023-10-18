import 'package:dartz/dartz.dart';
import 'package:google_one_tap_sign_in/google_one_tap_sign_in.dart';
import 'package:reaidy/domain/entities/google_oauth_result.dart';

import '../../data/failure.dart';

abstract class OAuthUseCase {
  Future<Either<Failure, GoogleOAuthResult>> signInUser();
}
