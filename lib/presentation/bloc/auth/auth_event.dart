import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class OnAppInit extends AuthEvent {}

class OnSignInWithGoogle extends AuthEvent {}

class UpdateUserData extends AuthEvent {
  final String googleId;
  final Map<String, dynamic> userData;
  const UpdateUserData({
    required this.googleId,
    required this.userData,
  });
}
