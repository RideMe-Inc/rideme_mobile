import 'package:dartz/dartz.dart';
import 'package:rideme_mobile/features/trips/domain/entities/tracking_info.dart';
import 'package:rideme_mobile/features/trips/domain/repository/trips_repository.dart';

class InitiateTracking {
  final TripsRepository repository;

  InitiateTracking({required this.repository});

  Stream<Either<String, TrackingInfo>> call(
      Map<String, dynamic> params) async* {
    yield* repository.initiateTracking(params);
  }
}
