import 'package:dartz/dartz.dart';
import 'package:rideme_mobile/core/usecase/usecase.dart';
import 'package:rideme_mobile/features/trips/domain/entities/trip_destination_info.dart';
import 'package:rideme_mobile/features/trips/domain/repository/trips_repository.dart';

class CreateTrip extends UseCases<TripDetailsInfo, Map<String, dynamic>> {
  final TripsRepository repository;

  CreateTrip({required this.repository});

  @override
  Future<Either<String, TripDetailsInfo>> call(
      Map<String, dynamic> params) async {
    return await repository.createTrip(params);
  }
}
