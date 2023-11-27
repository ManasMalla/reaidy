import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:http/http.dart';
import 'package:reaidy/data/failure.dart';
import 'package:reaidy/domain/entities/user.dart';
import 'package:reaidy/domain/repositories/login_repository.dart';
import 'package:reaidy/domain/usecases/oath_usecase.dart';

class LoginUsecase {
  final OAuthUseCase googleAuthUseCase;
  final LoginRepository loginRepository;
  const LoginUsecase({
    required this.googleAuthUseCase,
    required this.loginRepository,
  });
  Future<Either<Failure, User>> login() async {
    final googleSignInRequest = await googleAuthUseCase.signInUser();
    return await googleSignInRequest.fold(
      (failure) => Left(failure),
      (googleAuthResult) async => await loginRepository.login(googleAuthResult),
    );
  }

  Future<Either<Failure, User>> updateUser(
      String googleId, Map<String, dynamic> userData) async {
    return loginRepository.updateUser(googleId: googleId, userData: userData);
  }
}
