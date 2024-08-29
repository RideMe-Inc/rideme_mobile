import 'package:dartz/dartz.dart';
import 'package:rideme_mobile/features/user/domain/entities/user.dart';

abstract class UserRepository {
  //get user profile
  Future<Either<String, User>> getUserProfile(Map<String, dynamic> params);
}
