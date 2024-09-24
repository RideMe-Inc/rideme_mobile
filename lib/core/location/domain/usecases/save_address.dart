import 'package:dartz/dartz.dart';
import 'package:rideme_mobile/core/location/domain/repositories/location_repository.dart';
import 'package:rideme_mobile/core/usecase/usecase.dart';

class SaveAddress extends UseCases<String, Map<String, dynamic>> {
  final LocationRepository repository;

  SaveAddress({required this.repository});
  @override
  Future<Either<String, String>> call(Map<String, dynamic> params) async =>
      await repository.saveAddress(params);
}
