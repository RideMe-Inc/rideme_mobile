import 'dart:async';
import 'dart:convert';

import 'package:rideme_mobile/core/enums/endpoints.dart';

import 'package:rideme_mobile/core/mixins/remote_request_mixin.dart';

import 'package:rideme_mobile/core/urls/urls.dart';
import 'package:rideme_mobile/features/trips/data/models/all_trips_info.dart';
import 'package:rideme_mobile/features/trips/data/models/create_trip_info.dart';

import 'package:rideme_mobile/features/trips/data/models/tracking_info_model.dart';
import 'package:rideme_mobile/features/trips/data/models/trip_destnation_info_model.dart';
import 'package:http/http.dart' as http;
import 'package:web_socket_client/web_socket_client.dart';

abstract class TripRemoteDataSource {
  Future<AllTripsInfoModel> getAllTrips(Map<String, dynamic> params);

  Future<TripDetailsInfoModel> createTrip(Map<String, dynamic> params);

  Future<TripDetailsInfoModel> editTrip(Map<String, dynamic> params);

  Future<TripDetailsInfoModel> getTripDetails(Map<String, dynamic> params);

  Future<String> cancelTrip(Map<String, dynamic> params);

  Future<String> reportTrip(Map<String, dynamic> params);

  Future<String> rateTrip(Map<String, dynamic> params);

  //fetch pricing
  Future<CreateTripInfoModel> createOrFetchPricing(Map<String, dynamic> params);

  //send event for tracking
  Stream<TrackingInfoModel> initiateTracking(Map<String, dynamic> params);

  //terminate tracking
  Future<String> terminateTracking(Map<String, dynamic> params);

  //apply coupon
  Future<String> applyCoupon(Map<String, dynamic> params);
}

class TripRemoteDataSourceImpl
    with RemoteRequestMixin
    implements TripRemoteDataSource {
  final http.Client client;
  final URLS urls;

  final WebSocket socket;

  TripRemoteDataSourceImpl({
    required this.urls,
    required this.client,
    required this.socket,
  });

  //! CANCEL TRIP
  @override
  Future<String> cancelTrip(Map<String, dynamic> params) async {
    final decodedResponse = await delete(
      client: client,
      urls: urls,
      endpoint: Endpoints.tripDetails,
      params: params,
    );

    return decodedResponse['message'];
  }

  //! CREATE TRIP
  @override
  Future<TripDetailsInfoModel> createTrip(Map<String, dynamic> params) async {
    final decodedResponse = await post(
      client: client,
      urls: urls,
      endpoint: Endpoints.bookTrip,
      params: params,
    );

    return TripDetailsInfoModel.fromJson(decodedResponse);
  }

  //! EDIT TRIP
  @override
  Future<TripDetailsInfoModel> editTrip(Map<String, dynamic> params) async {
    final decodedResponse = await patch(
      client: client,
      urls: urls,
      endpoint: Endpoints.tripDetails,
      params: params,
    );

    return TripDetailsInfoModel.fromJson(decodedResponse);
  }

  //! GET ALL TRIPS
  @override
  Future<AllTripsInfoModel> getAllTrips(Map<String, dynamic> params) async {
    final decodedResponse = await patch(
      client: client,
      urls: urls,
      endpoint: Endpoints.trip,
      params: params,
    );

    return AllTripsInfoModel.fromJson(decodedResponse);
  }

  //! GET TRIP DETAILS
  @override
  Future<TripDetailsInfoModel> getTripDetails(
      Map<String, dynamic> params) async {
    final decodedResponse = await get(
      client: client,
      urls: urls,
      endpoint: Endpoints.tripDetails,
      params: params,
    );

    return TripDetailsInfoModel.fromJson(decodedResponse);
  }

  //! RATE TRIP
  @override
  Future<String> rateTrip(Map<String, dynamic> params) async {
    final decodedResponse = await post(
      client: client,
      urls: urls,
      endpoint: Endpoints.rateTrip,
      params: params,
    );

    return decodedResponse['message'];
  }

  //! REPORT TRIP
  @override
  Future<String> reportTrip(Map<String, dynamic> params) async {
    final decodedResponse = await post(
      client: client,
      urls: urls,
      endpoint: Endpoints.reportTrip,
      params: params,
    );

    return decodedResponse['message'];
  }

  //CREATE OR FETCH PRICING

  @override
  Future<CreateTripInfoModel> createOrFetchPricing(
      Map<String, dynamic> params) async {
    final decodedResponse = await post(
      client: client,
      urls: urls,
      endpoint: Endpoints.trip,
      params: params,
    );

    return CreateTripInfoModel.fromJson(decodedResponse['trip']);
  }

  //INITIATE TRACKING

  @override
  Stream<TrackingInfoModel> initiateTracking(
      Map<String, dynamic> params) async* {
    StreamController<TrackingInfoModel> controller =
        StreamController<TrackingInfoModel>();
    //send message to socket
    socket.send(jsonEncode(params));

    //listen to tracking event

    socket.messages.listen((event) {
      final decodedResponse = json.decode(event);
      if (decodedResponse['event'] ==
          'track-trips/${params['data']['trip_id']}') {
        controller.add(TrackingInfoModel.fromJson(decodedResponse['data']));
      }
    });

    yield* controller.stream;
  }

  @override
  Future<String> terminateTracking(Map<String, dynamic> params) async {
    //send message to socket
    socket.send(jsonEncode(params));

    return '';
  }

  //apply coupon

  @override
  Future<String> applyCoupon(Map<String, dynamic> params) async {
    final decodedResponse = await post(
      client: client,
      urls: urls,
      endpoint: Endpoints.applyCoupon,
      params: params,
    );

    return decodedResponse['message'];
  }
}
