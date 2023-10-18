import 'dart:convert';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reaidy/domain/entities/google_oauth_result.dart';
import 'package:reaidy/domain/usecases/google_auth_usecase.dart';
import 'package:reaidy/domain/usecases/google_one_tap_auth_usecase.dart';
import 'package:reaidy/domain/usecases/login_usecase.dart';
import 'package:reaidy/presentation/bloc/auth/auth_event.dart';
import 'package:reaidy/presentation/bloc/auth/auth_state.dart';
import 'package:reaidy/presentation/injector.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;

  AuthBloc({
    required this.loginUsecase,
  }) : super(LoadingAuthState()) {
    on<OnAppInit>((event, emit) async {
      await Future.delayed(
        const Duration(seconds: 2),
        () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (prefs.containsKey("sub") && prefs.containsKey("email")) {
            final result = GoogleOAuthResult(
              identifier: prefs.getString("sub")!,
              email: prefs.getString("email")!,
            );
            final response = await Injector.loginRepository.login(result);
            response.fold(
              (failure) => emit(
                FailureAuthState(message: failure.message),
              ),
              (user) {
                emit(SuccessAuthState(user: user));
              },
            );
          } else {
            emit(UnauthorizedAuthState());
          }
          //TODO check if authorized
          emit(UnauthorizedAuthState());
        },
      );
    });
    on<OnSignInWithGoogle>((event, emit) async {
      emit(LoadingAuthState());
      final response = await loginUsecase.login();
      response.fold(
        (failure) => emit(
          FailureAuthState(message: failure.message),
        ),
        (user) {
          emit(SuccessAuthState(user: user));
        },
      );
    });
  }
}
