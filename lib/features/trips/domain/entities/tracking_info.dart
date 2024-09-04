import 'package:equatable/equatable.dart';

class TrackingInfo extends Equatable {
  final num? lat, lng, heading, rating, driverID, driverLat, driverLng;
  final String? name, status, vehicleType, timeToArrival, tripId;

  const TrackingInfo({
    required this.lat,
    required this.lng,
    required this.heading,
    required this.rating,
    required this.driverID,
    required this.name,
    required this.status,
    required this.vehicleType,
    required this.timeToArrival,
    required this.tripId,
    required this.driverLat,
    required this.driverLng,
  });

  @override
  List<Object?> get props => [
        lat,
        lng,
        heading,
        rating,
        driverID,
        name,
        status,
        vehicleType,
        timeToArrival,
        driverLat,
        driverLng,
        tripId,
      ];
}
