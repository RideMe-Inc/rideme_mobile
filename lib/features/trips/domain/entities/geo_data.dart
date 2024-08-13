import 'package:equatable/equatable.dart';

class GeoDataInfo extends Equatable {
  final num? id, lat, lng;
  final String address, geoHash;

  const GeoDataInfo({
    required this.id,
    required this.lat,
    required this.lng,
    required this.address,
    required this.geoHash,
  });

  @override
  List<Object?> get props => [
        id,
        lat,
        lng,
        address,
        geoHash,
      ];
}
