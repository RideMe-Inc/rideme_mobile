import 'package:dartz/dartz.dart';
import 'package:rideme_mobile/features/user/domain/entities/user.dart';

abstract class UserRepository {
  //get user profile
  Future<Either<String, User>> getUserProfile(Map<String, dynamic> params);

  //delete account
  Future<Either<String, String>> deleteAccount(Map<String, dynamic> params);

  // edit profile
  Future<Either<String, User>> editProfile(Map<String, dynamic> params);
}
