import 'package:rideme_mobile/features/trips/domain/entities/geo_data.dart';

class GeoDataInfoModel extends GeoDataInfo {
  const GeoDataInfoModel({
    required super.id,
    required super.lat,
    required super.lng,
    required super.address,
    required super.geoHash,
  });

  //fromJson
  factory GeoDataInfoModel.fromJson(Map<String, dynamic> json) {
    return GeoDataInfoModel(
      id: json['id'],
      lat: json['lat'],
      lng: json['lng'],
      address: json['address'],
      geoHash: json['geo_hash'],
    );
  }
}
