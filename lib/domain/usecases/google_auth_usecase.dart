import 'package:dartz/dartz.dart';
import 'package:reaidy/domain/entities/google_oauth_result.dart';
import 'package:reaidy/domain/usecases/oath_usecase.dart';

import '../../data/failure.dart';
import '../repositories/google_auth_repository.dart';

class GoogleAuthUseCase implements OAuthUseCase {
  final GoogleAuthRepository googleAuthRepository;
  const GoogleAuthUseCase({required this.googleAuthRepository});

  @override
  Future<Either<Failure, GoogleOAuthResult>> signInUser() {
    return googleAuthRepository.signIn();
  }
}
