import 'package:dartz/dartz.dart';
import 'package:rideme_mobile/core/exceptions/generic_exception_class.dart';
import 'package:rideme_mobile/core/location/domain/entity/geo_hash.dart';
import 'package:rideme_mobile/core/network/networkinfo.dart';
import 'package:rideme_mobile/features/home/data/datasources/remoteds.dart';
import 'package:rideme_mobile/features/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDatasource remoteDatasource;
  final NetworkInfo networkInfo;

  HomeRepositoryImpl(
      {required this.remoteDatasource, required this.networkInfo});

  @override
  Future<Either<String, List<GeoData>>> fetchTopPlaces(
      Map<String, dynamic> params) async {
    if (!(await networkInfo.isConnected)) {
      return Left(networkInfo.noNetowrkMessage);
    }

    try {
      final response = await remoteDatasource.fetchTopPlaces(params);
      return Right(response);
    } catch (e) {
      if (e is ErrorException) {
        return Left(e.toString());
      }

      return const Left('An error occured');
    }
  }
}
