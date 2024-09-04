import 'package:dartz/dartz.dart';
import 'package:rideme_mobile/core/location/domain/entity/geo_hash.dart';
import 'package:rideme_mobile/core/usecase/usecase.dart';
import 'package:rideme_mobile/features/home/domain/repositories/home_repository.dart';

class FetchTopPlaces extends UseCases<List<GeoData>, Map<String, dynamic>> {
  final HomeRepository repository;

  FetchTopPlaces({required this.repository});

  @override
  Future<Either<String, List<GeoData>>> call(
          Map<String, dynamic> params) async =>
      await repository.fetchTopPlaces(params);
}
