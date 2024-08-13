import 'package:dartz/dartz.dart';
import 'package:rideme_mobile/core/usecase/usecase.dart';
import 'package:rideme_mobile/features/trips/domain/entities/create_trip_info.dart';
import 'package:rideme_mobile/features/trips/domain/repository/trips_repository.dart';

class FetchPricing extends UseCases<CreateTripInfo, Map<String, dynamic>> {
  final TripsRepository repository;

  FetchPricing({required this.repository});
  @override
  Future<Either<String, CreateTripInfo>> call(
      Map<String, dynamic> params) async {
    return await repository.fetchPricing(params);
  }
}
