import 'package:rideme_mobile/features/trips/domain/entities/driver.dart';

class DriverModel extends Driver {
  const DriverModel({
    required super.firstName,
    required super.phone,
    required super.vehicleRegistrationNumber,
    required super.profileURL,
    required super.rating,
    required super.vehicleColor,
    required super.vehicleMake,
    required super.vehicleModel,
  });

  factory DriverModel.fromJson(Map<String, dynamic> json) {
    return DriverModel(
      firstName: json["first_name"],
      phone: json["phone"],
      vehicleRegistrationNumber: json["vehicle_registration_number"],
      profileURL: json["profile_url"],
      rating: json['rating'],
      vehicleColor: json['vehicle_color'],
      vehicleMake: json['vehicle_make'],
      vehicleModel: json['vehicle_model'],
    );
  }
}
