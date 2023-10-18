import 'package:equatable/equatable.dart';
import 'package:reaidy/domain/entities/user.dart';

abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadingAuthState extends AuthState {}

class SuccessAuthState extends AuthState {
  final User user;
  SuccessAuthState({required this.user});
  @override
  // TODO: implement props
  List<Object?> get props => [user];
}

class FailureAuthState extends AuthState {
  final String message;
  FailureAuthState({required this.message});
  @override
  List<Object?> get props => [message];
}

class UnauthorizedAuthState extends AuthState {}
