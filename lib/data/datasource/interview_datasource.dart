import 'dart:convert';

import 'package:http/http.dart';
import 'package:reaidy/data/datasource/constants.dart';
import 'package:reaidy/data/model/interview_model.dart';
import 'package:reaidy/data/server_exception.dart';
import 'package:reaidy/domain/entities/interview.dart';
import 'package:reaidy/domain/entities/interview_response.dart';

abstract class InterviewDataSource {
  Future<List<InterviewModel>> fetchPastInterviews(String userId);
  Future<Map<String, dynamic>> fetchInterviewById(String userId);
  Future<InterviewResponse> createInterview(
    String technology,
    String intervieeId,
    String name,
    String levelOfDifficulty,
    int numberOfQuestions,
  );

  Future<List<InterviewResponse>> continueInterview(String interviewId,
      String userResponse, String name, InterviewResponse previousResponse);

  Future<void> finishInterview(String interviewId);
}

class InterviewDataSourceImpl implements InterviewDataSource {
  final Client client;
  const InterviewDataSourceImpl({required this.client});
  @override
  Future<List<InterviewModel>> fetchPastInterviews(String userId) async {
    final response = await client
        .get(Uri.parse("$baseUrl/api/interview/user-interviews/$userId"));
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result["success"]) {
        return result["data"].map<InterviewModel>((e) {
          return InterviewModel.fromJson(e);
        }).toList();
      } else {
        throw ServerException(result["message"]);
      }
    } else {
      throw const ServerException("Oops! Please try after some time.");
    }
  }

  @override
  Future<Map<String, dynamic>> fetchInterviewById(String interviewId) async {
    final response = await client.get(
        Uri.parse("$baseUrl/api/interview/get-interview-by-id/$interviewId"));
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result["success"]) {
        return result["data"];
      } else {
        throw ServerException(result["message"]);
      }
    } else {
      throw const ServerException("Oops! Please try after some time.");
    }
  }

  @override
  Future<InterviewResponse> createInterview(
      String technology,
      String intervieeId,
      String name,
      String levelOfDifficulty,
      int numberOfQuestions) async {
    final response = await client.post(
      Uri.parse("$baseUrl/api/interview/new-interview"),
      body: json.encode({
        "technology": technology,
        "interviewee": intervieeId,
        "name": name,
        "levelOfInterview": levelOfDifficulty,
        "noOfQuestions": numberOfQuestions,
      }),
      headers: {
        "Content-Type": "application/json",
      },
    );
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result["success"]) {
        return InterviewResponse(
          interviewId: result["data"]["result"]["_id"],
          response: result["data"]["interviewResponse"]["body"]["content"],
          role: result["data"]["interviewResponse"]["body"]["role"],
          index: 0,
          totalQuestions: result["data"]["result"]["noOfQuestions"],
          topic: result["data"]["result"]["technology"],
          interviewee: name,
        );
      } else {
        throw ServerException(result["message"]);
      }
    } else {
      throw const ServerException("Oops! Please try after some time.");
    }
  }

  @override
  Future<List<InterviewResponse>> continueInterview(
      String interviewId,
      String userResponse,
      String name,
      InterviewResponse previousResponse) async {
    final response = await client.post(
      Uri.parse("$baseUrl/api/interview/continue-interview"),
      body: json.encode({
        "interviewId": interviewId,
        "userResponse": userResponse,
      }),
      headers: {
        "Content-Type": "application/json",
      },
    );
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result["success"]) {
        print(result);
        return [
          InterviewResponse(
            interviewId: interviewId,
            response: result["data"]["userResponse"]["content"],
            role: result["data"]["userResponse"]["role"],
            index: previousResponse.index,
            totalQuestions: previousResponse.totalQuestions,
            topic: previousResponse.topic,
            interviewee: name,
          ),
          InterviewResponse(
            interviewId: interviewId,
            response: result["data"]["body"]["content"],
            role: result["data"]["body"]["role"],
            index: previousResponse.index + 1,
            totalQuestions: previousResponse.totalQuestions,
            topic: previousResponse.topic,
            interviewee: name,
          )
        ];
      } else {
        throw ServerException(result["message"]);
      }
    } else {
      throw const ServerException("Oops! Please try after some time.");
    }
  }

  @override
  Future<void> finishInterview(String interviewId) async {
    final response = await client.post(
      Uri.parse("$baseUrl/api/interview/result"),
      body: json.encode({
        "interviewId": interviewId,
      }),
      headers: {
        "Content-Type": "application/json",
      },
    );
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result["success"]) {
        return;
      } else {
        throw ServerException(result["message"]);
      }
    } else {
      print(response.statusCode);
      print(response.body);
      throw const ServerException("Oops! Please try after some time.");
    }
  }
}
