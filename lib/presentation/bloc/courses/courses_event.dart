import 'package:equatable/equatable.dart';

abstract class CoursesEvent extends Equatable {
  const CoursesEvent();
  @override
  List<Object?> get props => [];
}

class FetchCoursesList extends CoursesEvent {
  final String userId;
  const FetchCoursesList({required this.userId});
}

class EnrollCourse extends CoursesEvent {
  final String userId;
  final String courseId;
  const EnrollCourse({
    required this.userId,
    required this.courseId,
  });
}

class MarkSubtopicAsCompleted extends CoursesEvent {
  final String userId;
  final String courseId;
  final String topicId;
  final Function() callback;
  const MarkSubtopicAsCompleted({
    required this.userId,
    required this.courseId,
    required this.topicId,
    required this.callback,
  });
}
