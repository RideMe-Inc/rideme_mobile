import 'package:dartz/dartz.dart';

import 'package:rideme_mobile/features/trips/domain/entities/all_trips_info.dart';
import 'package:rideme_mobile/features/trips/domain/entities/create_trip_info.dart';

import 'package:rideme_mobile/features/trips/domain/entities/tracking_info.dart';
import 'package:rideme_mobile/features/trips/domain/entities/trip_destination_info.dart';

abstract class TripsRepository {
  Future<Either<String, AllTripsInfo>> getAllTrips(Map<String, dynamic> params);

  Future<Either<String, TripDetailsInfo>> createTrip(
      Map<String, dynamic> params);

  Future<Either<String, TripDetailsInfo>> editTrip(Map<String, dynamic> params);

  Future<Either<String, TripDetailsInfo>> getTripDetails(
      Map<String, dynamic> params);

  Future<Either<String, String>> cancelTrip(Map<String, dynamic> params);

  Future<Either<String, String>> reportTrip(Map<String, dynamic> params);

  Future<Either<String, String>> rateTrip(Map<String, dynamic> params);

  //fetch pricing
  Future<Either<String, CreateTripInfo>> fetchPricing(
      Map<String, dynamic> params);

  //send event for tracking
  Stream<Either<String, TrackingInfo>> initiateTracking(
      Map<String, dynamic> params);

  //terminate tracking
  Future<Either<String, String>> terminateTracking(Map<String, dynamic> params);

  //send event for tracking
  Stream<Either<String, TrackingInfo>> initiateDriverLookup(
      Map<String, dynamic> params);

  //terminate tracking
  Future<Either<String, String>> terminateDriverLookup(
      Map<String, dynamic> params);
}
