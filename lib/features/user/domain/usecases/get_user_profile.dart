import 'package:dartz/dartz.dart';
import 'package:rideme_mobile/core/usecase/usecase.dart';
import 'package:rideme_mobile/features/user/domain/entities/user.dart';
import 'package:rideme_mobile/features/user/domain/repositories/user_repository.dart';

class GetUserProfile extends UseCases<User, Map<String, dynamic>> {
  final UserRepository repository;

  GetUserProfile({required this.repository});
  @override
  Future<Either<String, User>> call(Map<String, dynamic> params) async =>
      await repository.getUserProfile(params);
}
