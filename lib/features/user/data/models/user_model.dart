import 'package:rideme_mobile/features/user/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.rating,
    required super.firstName,
    required super.lastName,
    required super.phone,
    required super.email,
    required super.profileUrl,
    required super.status,
    required super.requestedDeletion,
  });

  factory UserModel.fromJson(Map<String, dynamic>? json) {
    return UserModel(
      id: json?['id'],
      rating: json?['rating'],
      firstName: json?['first_name'],
      lastName: json?['last_name'],
      phone: json?['phone'],
      email: json?['email'],
      profileUrl: json?['profile_url'],
      status: json?['status'],
      requestedDeletion: json?['requested_deletion'],
    );
  }
}
