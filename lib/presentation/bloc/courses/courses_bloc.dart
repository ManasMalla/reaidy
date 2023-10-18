import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reaidy/domain/usecases/courses_usecase.dart';
import 'package:reaidy/presentation/bloc/courses/courses_event.dart';
import 'package:reaidy/presentation/bloc/courses/courses_state.dart';

class CoursesBloc extends Bloc<CoursesEvent, CoursesState> {
  final CoursesUsecase coursesUsecase;

  CoursesBloc({
    required this.coursesUsecase,
  }) : super(CoursesListLoadingState()) {
    on<FetchCoursesList>((event, emit) async {
      emit(CoursesListLoadingState());
      final userEnrolledCoursesResponse =
          await coursesUsecase.fetchUserEnrolledCourses(event.userId);
      final allCoursesResponse = await coursesUsecase.fetchAllCourses();
      allCoursesResponse.fold(
        (failure) => emit(
          CoursesFailureState(message: failure.message),
        ),
        (allCourses) {
          userEnrolledCoursesResponse.fold(
            (failure) => emit(
              CoursesFailureState(message: failure.message),
            ),
            (userEnrolledCourses) {
              emit(
                SuccessCoursesListState(
                    allCourses: allCourses, userCourses: userEnrolledCourses),
              );
            },
          );
        },
      );
    });
  }
}
