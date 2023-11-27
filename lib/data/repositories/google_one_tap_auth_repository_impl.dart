import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'dart:convert' show json, base64, ascii;

import 'package:dartz/dartz.dart';
import 'package:reaidy/data/failure.dart';
import 'package:reaidy/domain/entities/google_oauth_result.dart';
import 'package:reaidy/domain/repositories/google_auth_repository.dart';
import 'package:google_one_tap_sign_in/google_one_tap_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleOneTapAuthRepositoryImpl implements GoogleAuthRepository {
  const GoogleOneTapAuthRepositoryImpl();
  @override
  Future<Either<Failure, GoogleOAuthResult>> signIn() async {
    try {
      final request = await GoogleOneTapSignIn.startSignIn(
          webClientId:
              "654679328512-icojr7ogsote0f21jdmvfdpboteh2h6q.apps.googleusercontent.com");
      if (request == null) {
        return const Left(
            Failure(message: "Oops! Failed to retrive credentials."));
      }
      final response = json.decode(ascii.decode(base64.decode(
        base64.normalize(request.idToken.toString().split(".")[1]),
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
    } on SocketException {
      return const Left(Failure(message: "Internet Not Connected"));
    } on Exception {
      return const Left(Failure(message: "Oops! Please try after some time."));
    }
  }
}
