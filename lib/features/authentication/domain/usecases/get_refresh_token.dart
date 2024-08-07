import 'package:dartz/dartz.dart';
import 'package:rideme_mobile/core/usecase/usecase.dart';
import 'package:rideme_mobile/features/authentication/domain/entity/authorization.dart';
import 'package:rideme_mobile/features/authentication/domain/repository/authentication_repository.dart';

class GetRefreshToken extends UseCases<Authorization, Map<String, dynamic>> {
  final AuthenticationRepository repository;

  GetRefreshToken({required this.repository});
  @override
  Future<Either<String, Authorization>> call(
      Map<String, dynamic> params) async {
    return await repository.getRefreshToken(params);
  }
}
