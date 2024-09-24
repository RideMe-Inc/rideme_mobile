import 'package:dartz/dartz.dart';
import 'package:rideme_mobile/core/location/domain/repositories/location_repository.dart';
import 'package:rideme_mobile/core/usecase/usecase.dart';

class EditSavedAddress extends UseCases<String, Map<String, dynamic>> {
  final LocationRepository repository;

  EditSavedAddress({required this.repository});
  @override
  Future<Either<String, String>> call(Map<String, dynamic> params) async =>
      await repository.editSavedAddress(params);
}
