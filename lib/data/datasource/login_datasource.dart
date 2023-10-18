import 'dart:convert';

import 'package:http/http.dart';
import 'package:reaidy/data/model/user_model.dart';
import 'package:reaidy/data/server_exception.dart';
import 'package:reaidy/domain/entities/google_oauth_result.dart';

abstract class LoginDataSource {
  Future<UserModel> login(GoogleOAuthResult googleOAuthResult);
}

class LoginDataSourceImpl implements LoginDataSource {
  final Client client;
  const LoginDataSourceImpl({required this.client});
  @override
  Future<UserModel> login(GoogleOAuthResult googleAuthResult) async {
    final request = await client.post(
        Uri.parse(
            "https://hr-bot-nodejs-server-production.up.railway.app/api/user/login"),
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "mail": googleAuthResult.email,
          "gId": googleAuthResult.identifier,
        }));
    if (request.statusCode == 200) {
      final response = json.decode(request.body);
      if (response["success"]) {
        return UserModel.fromJson(response["data"]);
      } else {
        throw ServerException(response["message"]);
      }
    } else {
      throw const ServerException("Oops! Please try after some time.");
    }
  }
}
