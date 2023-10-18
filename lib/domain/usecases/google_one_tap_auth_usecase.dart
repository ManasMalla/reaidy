import 'package:dartz/dartz.dart';
import 'package:google_one_tap_sign_in/google_one_tap_sign_in.dart';
import 'package:reaidy/domain/entities/google_oauth_result.dart';
import 'package:reaidy/domain/usecases/oath_usecase.dart';

import '../../data/failure.dart';
import '../repositories/google_auth_repository.dart';

class GoogleOneTapAuthUseCase implements OAuthUseCase {
  final GoogleAuthRepository googleOneTapAuthRepository;
  const GoogleOneTapAuthUseCase({required this.googleOneTapAuthRepository});

  @override
  Future<Either<Failure, GoogleOAuthResult>> signInUser() {
    return googleOneTapAuthRepository.signIn();
  }
}
