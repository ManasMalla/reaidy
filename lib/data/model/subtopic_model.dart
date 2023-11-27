import 'package:reaidy/domain/entities/subtopic.dart';

class SubtopicModel {
  final String id;
  final String title;
  final String videoLink;
  final String description;
  final String videoType;
  final int startTime;
  final int endTime;
  final List<dynamic> content;

  SubtopicModel({
    required this.id,
    required this.title,
    required this.videoLink,
    required this.description,
    required this.videoType,
    required this.startTime,
    required this.endTime,
    required this.content,
  });

  factory SubtopicModel.fromJson(Map<String, dynamic> json) {
    return SubtopicModel(
      id: json['_id'],
      title: json['title'],
      videoLink: json['videoLink'],
      description: json['description'],
      videoType: json['videoType'],
      startTime: json['sTime'] ?? 0,
      endTime: json['eTime'] ?? 0,
      content: json['content'],
    );
  }

  Subtopic toEntity() {
    return Subtopic(
      id: id,
      title: title,
      videoLink: videoLink,
      description: description,
      videoType: videoType,
      startTime: startTime,
      endTime: endTime,
      content: content,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'videoLink': videoLink,
      'description': description,
      'videoType': videoType,
      'sTime': startTime,
      'eTime': endTime,
      'content': content,
    };
  }
}
