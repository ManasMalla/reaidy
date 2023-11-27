import 'package:reaidy/domain/entities/user_role.dart';

class ServerException implements Exception {
  final String message;
  const ServerException(this.message);
}

class LoginException implements Exception {
  final List<UserRole> userRoles;
  final String displayName;
  const LoginException(this.displayName, this.userRoles);
}
