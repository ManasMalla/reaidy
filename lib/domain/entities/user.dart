import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final bool isMailVerified;
  final bool isAccountVerified;
  final String profilePictureUrl;
  final List<String> skills;
  final String googleId;
  final bool isDeleted;
  final int createdAt;
  final int lastModified;
  final String updatedAt;
  final String branch;
  final String college;
  final String designation;
  final int year;
  final int communicationSkills;
  final int technicalSkills;
  final int overallRating;
  final String referralCode;
  final int coins;
  final List<dynamic> coinsUsage;
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.isMailVerified,
    required this.isAccountVerified,
    required this.profilePictureUrl,
    required this.skills,
    required this.googleId,
    required this.isDeleted,
    required this.createdAt,
    required this.lastModified,
    required this.updatedAt,
    required this.branch,
    required this.college,
    required this.designation,
    required this.year,
    required this.communicationSkills,
    required this.technicalSkills,
    required this.overallRating,
    required this.referralCode,
    required this.coins,
    required this.coinsUsage,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}
