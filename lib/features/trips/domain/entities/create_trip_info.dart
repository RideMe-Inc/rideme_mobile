import 'package:equatable/equatable.dart';

class CreateTripInfo extends Equatable {
  final int? tripID;
  final String? polyline, pickupAddress;
  final String? discountApplied;
  final num? pickupLat, pickupLng;
  final List<Pricing> pricing;
  final List<Destination>? destinations;

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
        "prices": pricing.map((e) => e.toMap()).toList(),
        "stops": destinations?.map((e) => e.toMap()).toList(),
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
  final String? vehicleType, expiration, description, tag;

  const Pricing({
    required this.id,
    required this.charge,
    required this.isAvailable,
    required this.vehicleType,
    required this.expiration,
    required this.description,
    required this.cost,
    required this.tag,
  });

  //pricing toMap
  Map<String, dynamic> toMap() => {
        "id": id,
        "charge": charge,
        "is_available": isAvailable,
        "vehicle_type": vehicleType,
        "expiration": expiration,
        "description": description,
        "cost": cost,
        "tag": tag,
      };

  @override
  List<Object?> get props => [
        id,
        charge,
        isAvailable,
        vehicleType,
        expiration,
        cost,
        tag,
      ];
}
