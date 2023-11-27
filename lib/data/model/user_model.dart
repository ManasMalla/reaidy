import 'package:equatable/equatable.dart';
import 'package:reaidy/domain/entities/user.dart';

class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String userRole;
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
  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.userRole,
    this.isMailVerified = false,
    this.isAccountVerified = false,
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
    this.coinsUsage = const [],
  });

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json["_id"],
        name: json["name"],
        email: json["mail"],
        userRole: json["role"]["role"],
        isMailVerified: json["isMailVerified"],
        isAccountVerified: json["isAccountVerified"],
        profilePictureUrl: json["pic"] ?? "https://github.com/ManasMalla.png",
        skills:
            (json["skills"] as List<dynamic>).map((e) => e.toString()).toList(),
        googleId: json["gId"],
        isDeleted: json["isDeleted"],
        createdAt: json["createdAt"],
        lastModified: json["lastModified"],
        updatedAt: json["updatedAt"],
        branch: json["branch"] ?? "",
        college: json["college"] ?? "",
        designation: json["designation"] ?? "",
        year: json["year"] ?? 4,
        communicationSkills: json["communicationSkills"] ?? 0,
        technicalSkills: json["technicalSkills"] ?? 0,
        overallRating: json["overallRating"] ?? 0,
        referralCode: json["referalCode"],
        coins: json["coins"] ?? 0,
        coinsUsage: json["coinUsage"] ?? [],
      );
  User toEntity() => User(
      id: id,
      name: name,
      email: email,
      userRole: userRole,
      isMailVerified: isMailVerified,
      isAccountVerified: isAccountVerified,
      profilePictureUrl: profilePictureUrl,
      skills: skills,
      googleId: googleId,
      isDeleted: isDeleted,
      createdAt: createdAt,
      lastModified: lastModified,
      updatedAt: updatedAt,
      branch: branch,
      college: college,
      designation: designation,
      year: year,
      communicationSkills: communicationSkills,
      technicalSkills: technicalSkills,
      overallRating: overallRating,
      referralCode: referralCode,
      coins: coins,
      coinsUsage: coinsUsage);

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}
