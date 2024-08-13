import 'package:dartz/dartz.dart';
import 'package:rideme_mobile/core/usecase/usecase.dart';
import 'package:rideme_mobile/features/trips/domain/entities/geo_data.dart';
import 'package:rideme_mobile/features/trips/domain/repository/trips_repository.dart';

class GetGeoID extends UseCases<GeoDataInfo, Map<String, dynamic>> {
  final TripsRepository repository;

  GetGeoID({required this.repository});
  @override
  Future<Either<String, GeoDataInfo>> call(Map<String, dynamic> params) async {
    return await repository.getGeoID(params);
  }
}
