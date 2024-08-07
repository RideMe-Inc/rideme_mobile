import 'package:dartz/dartz.dart';
import 'package:rideme_mobile/core/usecase/usecase.dart';
import 'package:rideme_mobile/features/authentication/domain/entity/init_auth_info.dart';
import 'package:rideme_mobile/features/authentication/domain/repository/authentication_repository.dart';

class InitAuth extends UseCases<InitAuthInfo, Map<String, dynamic>> {
  final AuthenticationRepository repository;

  InitAuth({required this.repository});
  @override
  Future<Either<String, InitAuthInfo>> call(Map<String, dynamic> params) async {
    return await repository.initAuth(params);
  }
}
