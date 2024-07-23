import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:dartz/dartz.dart';
import 'package:rideme_mobile/core/usecase/usecase.dart';
import 'package:rideme_mobile/features/permissions/domain/repository/permissions_repo.dart';

class RequestAllNecessaryPermissions
    extends UseCases<TrackingStatus, NoParams> {
  final PermissionsRepository repository;

  RequestAllNecessaryPermissions({required this.repository});
  @override
  Future<Either<String, TrackingStatus>> call(NoParams params) async {
    return await repository.requestAllNecessaryPermissions();
  }
}
