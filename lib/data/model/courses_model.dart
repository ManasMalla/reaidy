import 'package:reaidy/domain/entities/course.dart';
import 'package:reaidy/domain/entities/topic.dart';

class CoursesModel {
  final String id;
  final String title;
  final String description;
  final String image;
  final String? thumbnail;
  final int sort;
  final List<dynamic> benefits;
  final List<dynamic> outComes;
  final List<String> requirements;
  final List<dynamic> courseFor;
  final bool comingSoon;
  final bool isActive;
  final List<Topic> topics;
  final List<String> completedTopics;

  const CoursesModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.thumbnail,
    required this.sort,
    required this.topics,
    this.benefits = const [],
    this.outComes = const [],
    this.requirements = const [],
    this.courseFor = const [],
    this.comingSoon = false,
    this.isActive = true,
    required this.completedTopics,
  });

  factory CoursesModel.fromJson(
      Map<String, dynamic> json, List<Topic> subtopics) {
    return CoursesModel(
      id: json['course']?['_id'] ?? json['_id'],
      title: json['course']?['title'] ?? json['title'],
      description: json['description'] ?? "",
      image: json['course']?['image'] ?? json['image'],
      thumbnail: json['thumbnail'],
      sort: json['sort'] ?? 0,
      benefits: json['benefits'] ?? [],
      outComes: json['outComes'] ?? [],
      requirements: (json['requirements'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      courseFor: json['CourseFor'] ?? [],
      comingSoon: json['comingSoon'] ?? false,
      isActive: json['isActive'] ?? true,
      topics: subtopics,
      completedTopics: (json['completedTopics'] as List<dynamic>? ?? [])
          .map<String>((e) => e["topicId"])
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['_id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['image'] = image;
    data['thumbnail'] = thumbnail;
    data['sort'] = sort;
    data['benefits'] = benefits;
    data['outComes'] = outComes;
    data['requirements'] = requirements;
    data['CourseFor'] = courseFor;
    data['comingSoon'] = comingSoon;
    data['isActive'] = isActive;
    return data;
  }

  Course toEntity() => Course(
        id: id,
        title: title,
        description: description,
        image: image,
        thumbnail: thumbnail ?? image,
        sort: sort,
        benefits: benefits,
        outComes: outComes,
        requirements: requirements,
        courseFor: courseFor,
        comingSoon: comingSoon,
        isActive: isActive,
        topics: topics,
        completedTopics: completedTopics,
      );
}
