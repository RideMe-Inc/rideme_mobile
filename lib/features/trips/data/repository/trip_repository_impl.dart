import 'package:dartz/dartz.dart';
import 'package:rideme_mobile/core/exceptions/generic_exception_class.dart';
import 'package:rideme_mobile/core/network/networkinfo.dart';
import 'package:rideme_mobile/features/trips/data/datasource/remoteds.dart';
import 'package:rideme_mobile/features/trips/domain/entities/all_trips_info.dart';
import 'package:rideme_mobile/features/trips/domain/entities/create_trip_info.dart';

import 'package:rideme_mobile/features/trips/domain/entities/tracking_info.dart';
import 'package:rideme_mobile/features/trips/domain/entities/trip_destination_info.dart';
import 'package:rideme_mobile/features/trips/domain/repository/trips_repository.dart';

class TripsRepositoryImpl implements TripsRepository {
  final NetworkInfo networkInfo;
  final TripRemoteDataSource tripRemoteDataSource;

  TripsRepositoryImpl(
      {required this.networkInfo, required this.tripRemoteDataSource});

  // cancel trip

  @override
  Future<Either<String, String>> cancelTrip(Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await tripRemoteDataSource.cancelTrip(params);
        return Right(response);
      } catch (e) {
        if (e is ErrorException) {
          return Left(e.toString());
        }

        return const Left('An error occured');
      }
    } else {
      return Left(networkInfo.noNetowrkMessage);
    }
  }

  // create trip
  @override
  Future<Either<String, TripDetailsInfo>> createTrip(
      Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await tripRemoteDataSource.createTrip(params);
        return Right(response);
      } catch (e) {
        if (e is ErrorException) {
          return Left(e.toString());
        }

        return const Left('An error occured');
      }
    } else {
      return Left(networkInfo.noNetowrkMessage);
    }
  }

  // get all trips
  @override
  Future<Either<String, AllTripsInfo>> getAllTrips(
      Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await tripRemoteDataSource.getAllTrips(params);
        return Right(response);
      } catch (e) {
        if (e is ErrorException) {
          return Left(e.toString());
        }

        return const Left('An error occured');
      }
    } else {
      return Left(networkInfo.noNetowrkMessage);
    }
  }

  // get trip details

  @override
  Future<Either<String, TripDetailsInfo>> getTripDetails(
      Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await tripRemoteDataSource.getTripDetails(params);
        return Right(response);
      } catch (e) {
        if (e is ErrorException) {
          return Left(e.toString());
        }

        return const Left('An error occured');
      }
    } else {
      return Left(networkInfo.noNetowrkMessage);
    }
  }

  // rate trip
  @override
  Future<Either<String, String>> rateTrip(Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await tripRemoteDataSource.rateTrip(params);
        return Right(response);
      } catch (e) {
        if (e is ErrorException) {
          return Left(e.toString());
        }

        return const Left('An error occured');
      }
    } else {
      return Left(networkInfo.noNetowrkMessage);
    }
  }

  //report trip
  @override
  Future<Either<String, String>> reportTrip(Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await tripRemoteDataSource.reportTrip(params);
        return Right(response);
      } catch (e) {
        if (e is ErrorException) {
          return Left(e.toString());
        }

        return const Left('An error occured');
      }
    } else {
      return Left(networkInfo.noNetowrkMessage);
    }
  }

  //FETCH PRICING

  @override
  Future<Either<String, CreateTripInfo>> fetchPricing(
      Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response =
            await tripRemoteDataSource.createOrFetchPricing(params);
        return Right(response);
      } catch (e) {
        if (e is ErrorException) {
          return Left(e.toString());
        }

        return const Left('An error occured');
      }
    } else {
      return Left(networkInfo.noNetowrkMessage);
    }
  }

  //INITIATE TRACKING

  @override
  Stream<Either<String, TrackingInfo>> initiateTracking(
      Map<String, dynamic> params) async* {
    if (await networkInfo.isConnected) {
      try {
        final response = tripRemoteDataSource.initiateTracking(params);

        await for (var trackInfo in response) {
          yield Right(trackInfo);
        }
      } catch (e) {
        yield Left(e.toString());
      }
    } else {
      yield Left(networkInfo.noNetowrkMessage);
    }
  }

  //TERMINATE TRACKING

  @override
  Future<Either<String, String>> terminateTracking(
      Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await tripRemoteDataSource.terminateTracking(params);
        return Right(response);
      } catch (e) {
        if (e is ErrorException) {
          return Left(e.toString());
        }

        return const Left('An error occured');
      }
    } else {
      return Left(networkInfo.noNetowrkMessage);
    }
  }

  @override
  Future<Either<String, TripDetailsInfo>> editTrip(
      Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await tripRemoteDataSource.editTrip(params);
        return Right(response);
      } catch (e) {
        if (e is ErrorException) {
          return Left(e.toString());
        }

        return const Left('An error occured');
      }
    } else {
      return Left(networkInfo.noNetowrkMessage);
    }
  }

  @override
  Stream<Either<String, TrackingInfo>> initiateDriverLookup(
      Map<String, dynamic> params) async* {
    if (await networkInfo.isConnected) {
      try {
        final response = tripRemoteDataSource.initiateDriverLookup(params);

        await for (var trackInfo in response) {
          yield Right(trackInfo);
        }
      } catch (e) {
        yield Left(e.toString());
      }
    } else {
      yield Left(networkInfo.noNetowrkMessage);
    }
  }

  @override
  Future<Either<String, String>> terminateDriverLookup(
      Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response =
            await tripRemoteDataSource.terminateDriverLookup(params);
        return Right(response);
      } catch (e) {
        if (e is ErrorException) {
          return Left(e.toString());
        }

        return const Left('An error occured');
      }
    } else {
      return Left(networkInfo.noNetowrkMessage);
    }
  }

  @override
  Future<Either<String, CreateTripInfo>> retryBooking(
      Map<String, dynamic> params) async {
    if (await networkInfo.isConnected) {
      try {
        final response = await tripRemoteDataSource.retryBooking(params);
        return Right(response);
      } catch (e) {
        if (e is ErrorException) {
          return Left(e.toString());
        }

        return const Left('An error occured');
      }
    } else {
      return Left(networkInfo.noNetowrkMessage);
    }
  }
}
