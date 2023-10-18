import 'package:equatable/equatable.dart';
import 'package:reaidy/domain/entities/course.dart';

class CoursesState extends Equatable {
  const CoursesState();
  @override
  List<Object?> get props => [];
}

class CoursesListLoadingState extends CoursesState {}

class SuccessCoursesListState extends CoursesState {
  final List<Course> allCourses;
  final List<Course> userCourses;
  const SuccessCoursesListState({
    required this.allCourses,
    required this.userCourses,
  });
}

class CoursesFailureState extends CoursesState {
  final String message;
  const CoursesFailureState({required this.message});
}
