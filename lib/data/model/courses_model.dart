import 'package:reaidy/domain/entities/course.dart';

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

  const CoursesModel({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.thumbnail,
    required this.sort,
    this.benefits = const [],
    this.outComes = const [],
    this.requirements = const [],
    this.courseFor = const [],
    this.comingSoon = false,
    this.isActive = true,
  });

  factory CoursesModel.fromJson(Map<String, dynamic> json) {
    return CoursesModel(
      id: json['_id'] ?? json['course']['_id'],
      title: json['title'] ?? json['course']['title'],
      description: json['description'] ?? "",
      image: json['image'] ?? json['course']['image'],
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
      isActive: isActive);
}
