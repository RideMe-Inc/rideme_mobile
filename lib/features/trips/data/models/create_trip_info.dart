import 'package:rideme_mobile/features/trips/domain/entities/create_trip_info.dart';

class CreateTripInfoModel extends CreateTripInfo {
  const CreateTripInfoModel({
    required super.tripID,
    required super.polyline,
    required super.pricing,
    required super.destinations,
    required super.pickupAddress,
    required super.pickupLat,
    required super.pickupLng,
    required super.discountApplied,
  });

  //fromJson
  factory CreateTripInfoModel.fromJson(Map<String, dynamic> json) {
    return CreateTripInfoModel(
      tripID: json['trip_id'],
      polyline: json['polyline'],
      pricing: json["prices"] != null
          ? json['prices']
              .map<PricingModel>((e) => PricingModel.fromJson(e))
              .toList()
          : null,
      destinations: json["stops"] != null
          ? json['stops']
              .map<DestinationModel>((e) => DestinationModel.fromJson(e))
              .toList()
          : null,
      pickupAddress: json['pickup_address'],
      pickupLat: json['pickup_lat'],
      pickupLng: json['pickup_lng'],
      discountApplied: json['discount_applied'],
    );
  }
}

//destinations

class DestinationModel extends Destination {
  const DestinationModel({
    required super.id,
    required super.lat,
    required super.lng,
    required super.phone,
    required super.address,
    required super.destinationType,
    required super.startedAt,
    required super.endedAt,
  });

  //fromJson
  factory DestinationModel.fromJson(Map<String, dynamic> json) {
    return DestinationModel(
      id: json['id'],
      lat: json['lat'],
      lng: json['lng'],
      phone: json['phone'],
      address: json['address'],
      destinationType: json['destination_type'],
      startedAt: json['started_at'],
      endedAt: json['ended_at'],
    );
  }
}

//pricing

class PricingModel extends Pricing {
  const PricingModel({
    required super.id,
    required super.charge,
    required super.isAvailable,
    required super.vehicleType,
    required super.expiration,
    required super.description,
    required super.cost,
    required super.tag,
  });

  //fromJson
  factory PricingModel.fromJson(Map<String, dynamic> json) {
    return PricingModel(
      id: json['id'],
      charge: json['charge'],
      isAvailable: json['is_available'],
      vehicleType: json['vehicle_type'],
      expiration: json['expiration'],
      description: json['description'],
      tag: json['tag'],
      cost: num.parse(json['cost'].toString()),
    );
  }
}
