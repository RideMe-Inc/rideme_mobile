import 'package:dartz/dartz.dart';
import 'package:rideme_mobile/core/usecase/usecase.dart';

import 'package:rideme_mobile/features/trips/domain/repository/trips_repository.dart';

class CancelTrip extends UseCases<String, Map<String, dynamic>> {
  final TripsRepository repository;

  CancelTrip({required this.repository});
  @override
  Future<Either<String, String>> call(Map<String, dynamic> params) async {
    return await repository.cancelTrip(params);
  }
}
