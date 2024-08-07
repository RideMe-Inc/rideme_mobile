import 'package:dartz/dartz.dart';
import 'package:rideme_mobile/core/usecase/usecase.dart';
import 'package:rideme_mobile/features/trips/domain/entities/places_info.dart';
import 'package:rideme_mobile/features/trips/domain/repository/trips_repository.dart';

class SearchPlace extends UseCases<Places, Map<String, dynamic>> {
  final TripsRepository repository;

  SearchPlace({required this.repository});
  @override
  Future<Either<String, Places>> call(Map<String, dynamic> params) async {
    return repository.searchPlace(params);
  }
}
