import 'dart:convert';

import 'package:http/http.dart';
import 'package:reaidy/data/model/courses_model.dart';
import 'package:reaidy/data/server_exception.dart';

abstract class CoursesDataSource {
  Future<List<CoursesModel>> fetchAllCourses();
  Future<List<CoursesModel>> fetchUserEnrolledCourses(String userId);
}

class CoursesDataSourceImpl implements CoursesDataSource {
  final Client client;
  const CoursesDataSourceImpl({required this.client});
  @override
  Future<List<CoursesModel>> fetchAllCourses() async {
    final response = await client.get(Uri.parse(
        "https://hr-bot-nodejs-server-production.up.railway.app/api/course/all-courses"));
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result["success"]) {
        return result["data"].map<CoursesModel>((e) {
          return CoursesModel.fromJson(e);
        }).toList();
      } else {
        throw ServerException(result["message"]);
      }
    } else {
      throw const ServerException("Oops! Please try after some time.");
    }
  }

  @override
  Future<List<CoursesModel>> fetchUserEnrolledCourses(String userId) async {
    final response = await client.get(Uri.parse(
        "https://hr-bot-nodejs-server-production.up.railway.app/api/enroll/user-enrolled-courses/$userId"));
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result["success"]) {
        return result["data"].map<CoursesModel>((e) {
          return CoursesModel.fromJson(e);
        }).toList();
      } else {
        throw ServerException(result["message"]);
      }
    } else {
      throw const ServerException("Oops! Please try after some time.");
    }
  }
}
