import 'package:dartz/dartz.dart';
import 'package:rideme_mobile/core/location/domain/entity/geo_hash.dart';

abstract class HomeRepository {
  //fetch top places
  Future<Either<String, List<GeoData>>> fetchTopPlaces(
      Map<String, dynamic> params);
}
