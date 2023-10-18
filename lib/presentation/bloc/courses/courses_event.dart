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
