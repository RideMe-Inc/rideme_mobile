import 'package:equatable/equatable.dart';

class User extends Equatable {
  final num? id, rating;
  final bool? requestedDeletion;
  final String? firstName, lastName, phone, email, profileUrl, status;

  const User({
    required this.id,
    required this.rating,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.email,
    required this.profileUrl,
    required this.status,
    required this.requestedDeletion,
  });

  Map<String, dynamic> toMap() => {
        "id": id,
        "rating": rating,
        "first_name": firstName,
        "last_name": lastName,
        "phone": phone,
        "email": email,
        "profile_url": profileUrl,
        "status": status,
        "requested_deletion": requestedDeletion,
      };

  @override
  List<Object?> get props => [
        id,
        rating,
        firstName,
        lastName,
        phone,
        email,
        profileUrl,
        status,
        requestedDeletion,
      ];
}
