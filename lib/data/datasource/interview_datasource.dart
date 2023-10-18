import 'dart:convert';

import 'package:http/http.dart';
import 'package:reaidy/data/model/interview_model.dart';
import 'package:reaidy/data/server_exception.dart';
import 'package:reaidy/domain/entities/interview.dart';

abstract class InterviewDataSource {
  Future<List<InterviewModel>> fetchPastInterviews(String userId);
}

class InterviewDataSourceImpl implements InterviewDataSource {
  final Client client;
  const InterviewDataSourceImpl({required this.client});
  @override
  Future<List<InterviewModel>> fetchPastInterviews(String userId) async {
    final response = await client.get(Uri.parse(
        "https://hr-bot-nodejs-server-production.up.railway.app/api/interview/user-interviews/${userId}"));
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
}
