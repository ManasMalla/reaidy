import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:reaidy/data/datasource/constants.dart';
import 'package:reaidy/data/model/user_model.dart';
import 'package:reaidy/data/server_exception.dart';
import 'package:reaidy/domain/entities/google_oauth_result.dart';
import 'package:reaidy/domain/entities/user_role.dart';

abstract class LoginDataSource {
  Future<UserModel> login(GoogleOAuthResult googleOAuthResult);

  Future<UserModel> updateUser(
      {required String googleId, required Map<String, dynamic> userData});
}

class LoginDataSourceImpl implements LoginDataSource {
  final Client client;
  const LoginDataSourceImpl({required this.client});
  @override
  Future<UserModel> login(GoogleOAuthResult googleAuthResult) async {
    final request = await client.post(Uri.parse("$baseUrl/api/user/login"),
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
        if (response["message"] == "No data found") {
          //Register the user
          final userRoles = await getAllRoles();
          throw LoginException(googleAuthResult.displayName, userRoles);
        } else {
          throw ServerException(response["message"]);
        }
      }
    } else {
      throw const ServerException("Oops! Please try after some time.");
    }
  }

  Future<List<UserRole>> getAllRoles() async {
    final request = await client.get(
      Uri.parse("$baseUrl/api/role/all-roles"),
    );
    if (request.statusCode == 200) {
      final response = json.decode(request.body);
      if (response["success"]) {
        return response["data"]
            .map<UserRole>(
              (e) => UserRole(
                id: e["_id"],
                name: e["role"],
                description: e["description"],
              ),
            )
            .toList();
      } else {
        throw ServerException(response["message"]);
      }
    } else {
      throw const ServerException("Oops! Please try after some time.");
    }
  }

  void registerUser(
      GoogleOAuthResult googleAuthResult, UserRole userRole) async {
    //TODO Implement functionality

    // final request = await client.post(
    //     Uri.parse(
    //         "$baseUrl/api/user/login"),
    //     headers: {"Content-Type": "application/json"},
    //     body: json.encode({
    //       "mail": googleAuthResult.email,
    //       "gId": googleAuthResult.identifier,
    //     }));
    // if (request.statusCode == 200) {
    //   final response = json.decode(request.body);
    //   if (response["success"]) {
    //     return UserModel.fromJson(response["data"]);
    //   } else {
    //     if (response["message"] == "No data found") {
    //       //Register the user
    //       final userRoles = await getAllRoles();
    //       throw LoginException(userRoles);
    //     } else {
    //       throw ServerException(response["message"]);
    //     }
    //   }
    // } else {
    //   throw const ServerException("Oops! Please try after some time.");
    // }
  }

  @override
  Future<UserModel> updateUser(
      {required String googleId,
      required Map<String, dynamic> userData}) async {
    final request = await client.put(
      Uri.parse(
        "$baseUrl/api/user/users/${googleId}",
      ),
      headers: {"Content-Type": "application/json"},
      body: json.encode(userData),
    );
    if (request.statusCode == 200) {
      final response = json.decode(request.body);
      if (response["success"]) {
        return UserModel.fromJson(response["data"]);
      } else {
        throw ServerException(response["message"]);
      }
    } else {
      throw ServerException(
          "Oops, ${request.statusCode}! Please try after some time.");
    }
  }
}
