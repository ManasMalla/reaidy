import 'dart:convert';
import 'dart:io';

import 'package:dartz/dartz.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:reaidy/data/failure.dart';
import 'package:reaidy/domain/entities/google_oauth_result.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/repositories/google_auth_repository.dart';

class GoogleAuthRepositoryImpl implements GoogleAuthRepository {
  final GoogleSignIn googleSignIn;
  const GoogleAuthRepositoryImpl({required this.googleSignIn});

  @override
  Future<Either<Failure, GoogleOAuthResult>> signIn() async {
    try {
      final request = await googleSignIn.signIn();
      final auth = await request?.authentication;
      if (auth == null) {
        return const Left(
            Failure(message: "Oops! Failed to retrive credentials."));
      } else {
        print(auth.idToken);
        final response = json.decode(ascii.decode(base64.decode(
          base64.normalize(auth.idToken.toString().split(".")[1]),
        )));
        final result = GoogleOAuthResult(
          identifier: response["sub"],
          displayName: response["name"],
          email: response["email"],
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString("sub", result.identifier);
        await prefs.setString("email", result.email);
        return Right(result);
      }
    } on SocketException {
      return const Left(Failure(message: "Internet Not Connected"));
    } on Exception {
      return const Left(Failure(message: "Oops! Please try after some time."));
    }
  }
}
