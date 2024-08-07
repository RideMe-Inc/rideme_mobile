import 'package:rideme_mobile/features/trips/domain/entities/tracking_info.dart';

class TrackingInfoModel extends TrackingInfo {
  const TrackingInfoModel({
    required super.lat,
    required super.lng,
    required super.heading,
    required super.rating,
    required super.riderID,
    required super.name,
    required super.status,
    required super.vehicleType,
    required super.timeToArrival,
  });

  //fromJson
  factory TrackingInfoModel.fromJson(Map<String, dynamic> json) {
    return TrackingInfoModel(
      lat: json['lat'],
      lng: json['lng'],
      heading: json['heading'],
      rating: json['rating'],
      riderID: json['rider_id'],
      name: json['name'],
      status: json['status'],
      vehicleType: json['vehicle_type'],
      timeToArrival: json['time_to_arrival'],
    );
  }
}
