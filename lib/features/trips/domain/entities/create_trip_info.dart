import 'package:equatable/equatable.dart';

class CreateTripInfo extends Equatable {
  final int tripID;
  final String polyline, pickupAddress;
  final String? discountApplied;
  final num pickupLat, pickupLng;
  final List<Pricing> pricing;
  final List<Destination> destinations;

  const CreateTripInfo({
    required this.tripID,
    required this.polyline,
    required this.pricing,
    required this.destinations,
    required this.pickupAddress,
    required this.pickupLat,
    required this.pickupLng,
    required this.discountApplied,
  });

//tripinfo to map
  Map<String, dynamic> toMap() => {
        "id": tripID,
        "polyline": polyline,
        "pricing": pricing.map((e) => e.toMap()).toList(),
        "destinations": destinations.map((e) => e.toMap()).toList(),
        "pickup_address": pickupAddress,
        "pickup_lat": pickupLat,
        "pickup_lng": pickupLng,
        "discount_applied": discountApplied,
      };

  @override
  List<Object?> get props => [
        tripID,
        polyline,
        pricing,
        destinations,
        pickupAddress,
        pickupLat,
        pickupLng,
        discountApplied,
      ];
}

//destinations
class Destination extends Equatable {
  final num id, lat, lng;
  final String? phone, address, destinationType, startedAt, endedAt;

  const Destination({
    required this.id,
    required this.lat,
    required this.lng,
    required this.phone,
    required this.address,
    required this.destinationType,
    required this.startedAt,
    required this.endedAt,
  });

  //toMap
  Map<String, dynamic> toMap() => {
        "id": id,
        "phone": phone,
        "address": address,
        "lat": lat,
        "lng": lng,
        "destination_type": destinationType,
        "started_at": startedAt,
        "ended_at": endedAt,
      };

  @override
  List<Object?> get props => [
        id,
        lat,
        lng,
        phone,
        address,
        destinationType,
        startedAt,
        endedAt,
      ];
}

//pricing
class Pricing extends Equatable {
  final num id, charge, cost;
  final bool isAvailable;
  final String deliveryType, vehicleType, expiration, description;

  const Pricing({
    required this.id,
    required this.charge,
    required this.isAvailable,
    required this.deliveryType,
    required this.vehicleType,
    required this.expiration,
    required this.description,
    required this.cost,
  });

  //pricing toMap
  Map<String, dynamic> toMap() => {
        "id": id,
        "charge": charge,
        "is_available": isAvailable,
        "delivery_type": deliveryType,
        "vehicle_type": vehicleType,
        "expiration": expiration,
        "description": description,
        "cost": cost,
      };

  @override
  List<Object?> get props => [
        id,
        charge,
        isAvailable,
        deliveryType,
        vehicleType,
        expiration,
        cost,
      ];
}
