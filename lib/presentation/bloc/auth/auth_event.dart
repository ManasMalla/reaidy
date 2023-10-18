import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class OnAppInit extends AuthEvent {}

class OnSignInWithGoogle extends AuthEvent {}
