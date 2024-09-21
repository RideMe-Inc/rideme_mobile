import 'package:equatable/equatable.dart';

class TrackingInfo extends Equatable {
  final num? lat,
      lng,
      heading,
      rating,
      driverID,
      driverLat,
      driverLng,
      totalStops,
      completedStopsCount;
  final String? name,
      status,
      vehicleType,
      timeToArrival,
      tripId,
      arrivedAt,
      pickedUpAt,
      completedAt;

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
    required this.arrivedAt,
    required this.completedAt,
    required this.pickedUpAt,
    required this.completedStopsCount,
    required this.totalStops,
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
        arrivedAt,
        completedAt,
        pickedUpAt,
        completedStopsCount,
        totalStops,
      ];
}
