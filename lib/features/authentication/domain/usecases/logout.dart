import 'package:dartz/dartz.dart';
import 'package:rideme_mobile/core/usecase/usecase.dart';
import 'package:rideme_mobile/features/authentication/domain/repository/authentication_repository.dart';

class LogOut extends UseCases<String, Map<String, dynamic>> {
  final AuthenticationRepository repository;

  LogOut({required this.repository});
  @override
  Future<Either<String, String>> call(Map<String, dynamic> params) async {
    return await repository.logOut(params);
  }
}
