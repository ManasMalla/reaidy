import 'package:equatable/equatable.dart';
import 'package:reaidy/domain/entities/user.dart';
import 'package:reaidy/domain/entities/user_role.dart';

abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class LoadingAuthState extends AuthState {}

class SuccessAuthState extends AuthState {
  final User user;
  const SuccessAuthState({required this.user});
  @override
  // TODO: implement props
  List<Object?> get props => [user];
}

class FailureAuthState extends AuthState {
  final String message;
  const FailureAuthState({required this.message});
  @override
  List<Object?> get props => [message];
}

class UnauthorizedAuthState extends AuthState {}

class RegisterNewUserState extends AuthState {
  final List<UserRole> userRoles;
  final String displayName;
  const RegisterNewUserState({
    required this.userRoles,
    required this.displayName,
  });
}
