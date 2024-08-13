import 'package:dartz/dartz.dart';
import 'package:rideme_mobile/core/usecase/usecase.dart';
import 'package:rideme_mobile/features/trips/domain/entities/all_trips_info.dart';
import 'package:rideme_mobile/features/trips/domain/repository/trips_repository.dart';

class GetAllTrips extends UseCases<AllTripsInfo, Map<String, dynamic>> {
  final TripsRepository repository;

  GetAllTrips({required this.repository});
  @override
  Future<Either<String, AllTripsInfo>> call(Map<String, dynamic> params) async {
    return await repository.getAllTrips(params);
  }
}
