import 'package:dartz/dartz.dart';
import 'package:reaidy/data/failure.dart';
import 'package:reaidy/domain/entities/course.dart';

abstract class CoursesRepository {
  Future<Either<Failure, List<Course>>> fetchAllCourses();
  Future<Either<Failure, List<Course>>> fetchUserEnrolledCourses(String userId);

  Future<Either<Failure, void>> enrollCourse(String id, String courseId);

  Future<Either<Failure, void>> markSubtopicAsCompleted(
      String userId, String courseId, String topicId);
}
