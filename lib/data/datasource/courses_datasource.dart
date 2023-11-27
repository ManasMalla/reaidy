import 'dart:convert';

import 'package:http/http.dart';
import 'package:reaidy/data/datasource/constants.dart';
import 'package:reaidy/data/model/courses_model.dart';
import 'package:reaidy/data/model/subtopic_model.dart';
import 'package:reaidy/data/server_exception.dart';
import 'package:reaidy/domain/entities/topic.dart';

abstract class CoursesDataSource {
  Future<List<CoursesModel>> fetchAllCourses();
  Future<List<CoursesModel>> fetchUserEnrolledCourses(String userId);

  Future<void> enrollCourse(String userId, String courseId);
  Future<void> markSubtopicAsCompleted(
      String userId, String courseId, String topicId);
}

class CoursesDataSourceImpl implements CoursesDataSource {
  final Client client;
  const CoursesDataSourceImpl({required this.client});
  @override
  Future<List<CoursesModel>> fetchAllCourses() async {
    final response =
        await client.get(Uri.parse("$baseUrl/api/course/all-courses"));
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result["success"]) {
        return Future.wait(result["data"].map<Future<CoursesModel>>((e) async {
          final List<Topic> topicResult = await fetchSubtopics(e['_id']);
          return CoursesModel.fromJson(e, topicResult);
        }).toList());
      } else {
        throw ServerException(result["message"]);
      }
    } else {
      throw const ServerException("Oops! Please try after some time.");
    }
  }

  @override
  Future<List<CoursesModel>> fetchUserEnrolledCourses(String userId) async {
    final response = await client
        .get(Uri.parse("$baseUrl/api/enroll/user-enrolled-courses/$userId"));
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result["success"]) {
        final request = ((result["data"] as List<dynamic>).map((e) async {
          final List<Topic> topicResult =
              await fetchSubtopics(e['course']?['_id']);
          return CoursesModel.fromJson(
            e,
            topicResult,
          );
        }).toList());
        return Future.wait(request);
      } else {
        throw ServerException(result["message"]);
      }
    } else {
      throw const ServerException("Oops! Please try after some time.");
    }
  }

  @override
  Future<void> enrollCourse(String userId, String courseId) async {
    final response = await client.post(
      Uri.parse("$baseUrl/api/enroll/create"),
      headers: {"Content-Type": "application/json"},
      body: json.encode(
        {
          "userId": userId,
          "course": courseId,
        },
      ),
    );
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result["success"]) {
        return;
      } else {
        throw ServerException(result["message"]);
      }
    } else {
      print(userId);
      print(response.statusCode);
      print(response.body);
      throw const ServerException("Oops! Please try after some time.");
    }
  }

  Future<List<Topic>> fetchSubtopics(String courseId) async {
    final response =
        await client.get(Uri.parse("$baseUrl/api/course/courses/$courseId"));
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result["success"]) {
        final rawTopics = result["data"]["topics"];
        final topics = rawTopics.map<Topic>((e) {
          return Topic(
            id: e["_id"],
            title: e["title"],
            subtopic: (e["subTopics"] as List<dynamic>)
                .map((f) => SubtopicModel.fromJson(f).toEntity())
                .toList(),
          );
        }).toList();
        return topics;
      } else {
        throw ServerException(result["message"]);
      }
    } else {
      throw const ServerException("Oops! Please try after some time.");
    }
  }

  @override
  Future<void> markSubtopicAsCompleted(
      String userId, String courseId, String topicId) async {
    final response = await client.post(
      Uri.parse("$baseUrl/api/enroll/topic-completed"),
      headers: {"Content-Type": "application/json"},
      body: json
          .encode({"userId": userId, "courseId": courseId, "topic": topicId}),
    );
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result["success"]) {
        print("mark as enrolled");
        print(result["data"]);
        return;
      } else {
        throw ServerException(result["message"]);
      }
    } else {
      print("mark as enrolled");
      print(response.body);
      throw const ServerException("Oops! Please try after some time.");
    }
  }
}
