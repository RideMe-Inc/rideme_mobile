import 'package:dartz/dartz.dart';
import 'package:rideme_mobile/core/location/domain/entity/geo_hash.dart';
import 'package:rideme_mobile/core/location/domain/entity/places_info.dart';

abstract class LocationRepository {
  // search places

  Future<Either<String, Places>> searchPlace(Map<String, dynamic> params);

  //get geo id
  Future<Either<String, GeoData>> getGeoID(Map<String, dynamic> params);

  //cache location
  Future<bool> cacheLocation(GeoData? geoData);

  //retrieve locations
  List<GeoData> retrieveRecentLocations();

  Future<Either<String, String>> saveAddress(Map<String, dynamic> params);

  Future<Either<String, String>> editSavedAddress(Map<String, dynamic> params);
}
