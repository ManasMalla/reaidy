import 'package:equatable/equatable.dart';
import 'package:reaidy/domain/entities/topic.dart';

class Course extends Equatable {
  final String id;
  final String title;
  final String description;
  final String image;
  final String thumbnail;
  final int sort;
  final List<dynamic> benefits;
  final List<dynamic> outComes;
  final List<String> requirements;
  final List<dynamic> courseFor;
  final bool comingSoon;
  final bool isActive;
  final List<Topic> topics;
  final List<String> completedTopics;

  const Course({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.thumbnail,
    required this.sort,
    required this.benefits,
    required this.outComes,
    required this.requirements,
    required this.courseFor,
    required this.comingSoon,
    required this.isActive,
    required this.topics,
    required this.completedTopics,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}
