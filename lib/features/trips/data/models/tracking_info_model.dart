import 'package:rideme_mobile/features/trips/domain/entities/tracking_info.dart';

class TrackingInfoModel extends TrackingInfo {
  const TrackingInfoModel({
    required super.lat,
    required super.lng,
    required super.heading,
    required super.rating,
    required super.driverID,
    required super.name,
    required super.status,
    required super.vehicleType,
    required super.timeToArrival,
    required super.driverLat,
    required super.driverLng,
    required super.tripId,
  });

  //fromJson
  factory TrackingInfoModel.fromJson(Map<String, dynamic> json) {
    return TrackingInfoModel(
      lat: json['lat'],
      lng: json['lng'],
      heading: json['heading'],
      rating: json['rating'],
      driverID: json['driver_id'],
      name: json['name'],
      status: json['status'],
      vehicleType: json['vehicle_type'],
      timeToArrival: json['time_to_arrival'],
      driverLat: json['driver_lat'],
      driverLng: json['driver_lng'],
      tripId: json["trip_id"] != null ? json['trip_id'].toString() : null,
    );
  }
}
