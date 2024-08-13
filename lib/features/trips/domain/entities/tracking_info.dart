import 'package:equatable/equatable.dart';

class TrackingInfo extends Equatable {
  final num? lat, lng, heading, rating, riderID;
  final String name, status, vehicleType, timeToArrival;

  const TrackingInfo({
    required this.lat,
    required this.lng,
    required this.heading,
    required this.rating,
    required this.riderID,
    required this.name,
    required this.status,
    required this.vehicleType,
    required this.timeToArrival,
  });

  @override
  List<Object?> get props => [
        lat,
        lng,
        heading,
        rating,
        riderID,
        name,
        status,
        vehicleType,
        timeToArrival,
      ];
}
