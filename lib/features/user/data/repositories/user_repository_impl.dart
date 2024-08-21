import 'package:dartz/dartz.dart';
import 'package:rideme_mobile/core/exceptions/generic_exception_class.dart';
import 'package:rideme_mobile/core/network/networkinfo.dart';
import 'package:rideme_mobile/features/user/data/datasources/localds.dart';
import 'package:rideme_mobile/features/user/data/datasources/remoteds.dart';
import 'package:rideme_mobile/features/user/domain/entities/user.dart';
import 'package:rideme_mobile/features/user/domain/repositories/user_repository.dart';

class UserRepositoryImpl implements UserRepository {
  final NetworkInfo networkInfo;
  final UserLocalDatasource localDatasource;
  final UserRemoteDatasource remoteDatasource;

  UserRepositoryImpl(
      {required this.networkInfo,
      required this.localDatasource,
      required this.remoteDatasource});

  @override
  Future<Either<String, User>> getUserProfile(
      Map<String, dynamic> params) async {
    if (!(await networkInfo.isConnected)) {
      return Left(networkInfo.noNetowrkMessage);
    }

    try {
      final response = await remoteDatasource.getUserProfile(params);
      return Right(response);
    } catch (e) {
      if (e is ErrorException) {
        return Left(e.toString());
      }

      return const Left('An error occured');
    }
  }
}
