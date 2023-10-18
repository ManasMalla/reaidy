import 'package:dartz/dartz.dart';
import 'package:reaidy/data/failure.dart';
import 'package:reaidy/domain/entities/course.dart';
import 'package:reaidy/domain/repositories/courses_repository.dart';

class CoursesUsecase {
  final CoursesRepository coursesRepository;
  const CoursesUsecase({required this.coursesRepository});
  Future<Either<Failure, List<Course>>> fetchUserEnrolledCourses(
      String id) async {
    final result = coursesRepository.fetchUserEnrolledCourses(id);
    return result;
  }

  Future<Either<Failure, List<Course>>> fetchAllCourses() async {
    final result = coursesRepository.fetchAllCourses();
    return result;
  }
}
