import 'package:equatable/equatable.dart';

class Driver extends Equatable {
  final String? firstName,
      phone,
      vehicleMake,
      vehicleModel,
      vehicleColor,
      vehicleRegistrationNumber,
      profileURL;
  final num? rating;

  const Driver({
    required this.firstName,
    required this.phone,
    required this.vehicleColor,
    required this.vehicleMake,
    required this.vehicleModel,
    required this.vehicleRegistrationNumber,
    required this.profileURL,
    required this.rating,
  });

  @override
  List<Object?> get props => [
        firstName,
        phone,
        vehicleColor,
        vehicleMake,
        vehicleModel,
        vehicleRegistrationNumber,
        profileURL,
        rating
      ];

  Map<String, dynamic> toMap() => {
        "first_name": firstName,
        "phone": phone,
        "vehicle_make": vehicleMake,
        "vehicle_model": vehicleModel,
        "vehicle_color": vehicleColor,
        "vehicle_registration_number": vehicleRegistrationNumber,
        "profile_url": profileURL,
        'rating': rating,
      };
}
