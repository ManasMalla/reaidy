import 'dart:io';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:reaidy/data/datasource/courses_datasource.dart';
import 'package:reaidy/data/datasource/interview_datasource.dart';
import 'package:reaidy/data/datasource/login_datasource.dart';
import 'package:reaidy/data/repositories/courses_repository.dart';
import 'package:reaidy/data/repositories/google_auth_repository_impl.dart';
import 'package:reaidy/data/repositories/google_one_tap_auth_repository_impl.dart';
import 'package:reaidy/data/repositories/interview_repository.dart';
import 'package:reaidy/data/repositories/login_repository_impl.dart';
import 'package:reaidy/domain/repositories/courses_repository.dart';
import 'package:reaidy/domain/repositories/google_auth_repository.dart';
import 'package:reaidy/domain/repositories/interview_repository.dart';
import 'package:reaidy/domain/repositories/login_repository.dart';
import 'package:reaidy/domain/usecases/courses_usecase.dart';
import 'package:reaidy/domain/usecases/google_auth_usecase.dart';
import 'package:reaidy/domain/usecases/google_one_tap_auth_usecase.dart';
import 'package:reaidy/domain/usecases/interview_usecase.dart';
import 'package:reaidy/domain/usecases/login_usecase.dart';
import 'package:reaidy/presentation/bloc/auth/auth_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:reaidy/presentation/bloc/courses/courses_bloc.dart';
import 'package:reaidy/presentation/bloc/interview/interview_bloc.dart';

class Injector {
  static const GoogleAuthRepository googleOneTapAuthRepository =
      GoogleOneTapAuthRepositoryImpl();
  static GoogleSignIn googleSignIn = GoogleSignIn();
  static GoogleAuthRepository googleAuthRepository =
      GoogleAuthRepositoryImpl(googleSignIn: googleSignIn);

  static const GoogleOneTapAuthUseCase googleOneTapAuthUseCase =
      GoogleOneTapAuthUseCase(
          googleOneTapAuthRepository: googleOneTapAuthRepository);
  static GoogleAuthUseCase googleAuthUseCase =
      GoogleAuthUseCase(googleAuthRepository: googleAuthRepository);
  static LoginDataSource loginDataSource =
      LoginDataSourceImpl(client: http.Client());
  static LoginRepository loginRepository =
      LoginRepositoryImpl(loginDataSource: loginDataSource);
  static LoginUsecase loginUsecase = LoginUsecase(
      googleAuthUseCase:
          (Platform.isAndroid ? googleOneTapAuthUseCase : googleAuthUseCase),
      loginRepository: loginRepository);
  static AuthBloc authBloc = AuthBloc(loginUsecase: loginUsecase);

  static InterviewDataSource interviewDataSource = InterviewDataSourceImpl(
    client: http.Client(),
  );
  static InterviewRepository interviewRepository = InterviewRepositoryImpl(
    interviewDataSource: interviewDataSource,
  );
  static InterviewUsecase interviewUsecase =
      InterviewUsecase(interviewRepository: interviewRepository);
  static InterviewBloc interviewBloc =
      InterviewBloc(interviewUsecase: interviewUsecase);

  static CoursesDataSource coursesDataSource = CoursesDataSourceImpl(
    client: http.Client(),
  );
  static CoursesRepository coursesRepository = CoursesRepositoryImpl(
    coursesDataSource: coursesDataSource,
  );
  static CoursesUsecase coursesUsecase =
      CoursesUsecase(coursesRepository: coursesRepository);
  static CoursesBloc coursesBloc = CoursesBloc(coursesUsecase: coursesUsecase);
}
