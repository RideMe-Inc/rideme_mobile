import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/extensions/date_extension.dart';
import 'package:rideme_mobile/features/trips/data/models/create_trip_info.dart';
import 'package:rideme_mobile/features/trips/data/models/trip_destnation_info_model.dart';
import 'package:rideme_mobile/features/trips/domain/entities/all_trips_details.dart';
import 'package:rideme_mobile/features/trips/domain/entities/directions_object.dart';
import 'package:rideme_mobile/features/trips/domain/entities/tracking_info_notice.dart';
import 'package:rideme_mobile/features/trips/domain/entities/trip_destination_data.dart';

import 'package:rideme_mobile/features/trips/domain/usecases/edit_trip.dart';

import 'package:equatable/equatable.dart';
import 'package:rideme_mobile/features/trips/domain/entities/all_trips_info.dart';
import 'package:rideme_mobile/features/trips/domain/entities/create_trip_info.dart';

import 'package:rideme_mobile/features/trips/domain/entities/tracking_info.dart';
import 'package:rideme_mobile/features/trips/domain/entities/trip_destination_info.dart';

import 'package:rideme_mobile/features/trips/domain/usecases/cancel_trip.dart';
import 'package:rideme_mobile/features/trips/domain/usecases/create_trip.dart';
import 'package:rideme_mobile/features/trips/domain/usecases/fetch_pricing.dart';
import 'package:rideme_mobile/features/trips/domain/usecases/get_all_trips.dart';
import 'package:rideme_mobile/features/trips/domain/usecases/get_directions.dart';

import 'package:rideme_mobile/features/trips/domain/usecases/get_trip_info.dart';
import 'package:rideme_mobile/features/trips/domain/usecases/initiate_driver_lookup.dart';
import 'package:rideme_mobile/features/trips/domain/usecases/initiate_tracking.dart';
import 'package:rideme_mobile/features/trips/domain/usecases/rate_trip.dart';
import 'package:rideme_mobile/features/trips/domain/usecases/report_trip.dart';
import 'package:rideme_mobile/features/trips/domain/usecases/retry_booking.dart';
import 'package:rideme_mobile/features/trips/domain/usecases/terminate_driver_lookup.dart';

import 'package:rideme_mobile/features/trips/domain/usecases/terminate_tracking.dart';
import 'package:rideme_mobile/features/trips/presentation/provider/trip_provider.dart';

part 'trips_event.dart';
part 'trips_state.dart';

class TripsBloc extends Bloc<TripsEvent, TripsState> {
  final CancelTrip cancelTrip;
  final CreateTrip createTrip;
  final GetAllTrips getAllTrips;
  final RateTrip rateTrip;
  final ReportTrip reportTrip;
  final GetTripInfo getTripInfo;

  final FetchPricing fetchPricing;
  final InitiateTracking initiateTracking;
  final TerminateTracking terminateTracking;
  final EditTrip editTrip;
  final InitiateDriverLookup initiateDriverLookup;
  final TerminateDriverLookup terminateDriverLookup;
  final RetryBooking retryBooking;
  final GetDirections getDirections;

  TripsBloc({
    required this.cancelTrip,
    required this.createTrip,
    required this.getAllTrips,
    required this.rateTrip,
    required this.getTripInfo,
    required this.reportTrip,
    required this.fetchPricing,
    required this.initiateTracking,
    required this.terminateTracking,
    required this.editTrip,
    required this.initiateDriverLookup,
    required this.terminateDriverLookup,
    required this.retryBooking,
    required this.getDirections,
  }) : super(TripsInitial()) {
    //! CANCEL TRIP

    on<CancelTripEvent>((event, emit) async {
      emit(CancelTripLoading());

      final response = await cancelTrip(event.params);

      emit(
        response.fold(
          (error) => GenericTripsError(errorMessage: error),
          (response) => CancelTripLoaded(message: response),
        ),
      );
    });

    //! CREATE TRIP

    on<CreateTripEvent>((event, emit) async {
      emit(CreateTripLoading());

      final response = await createTrip(event.params);

      emit(
        response.fold(
          (error) => GenericTripsError(errorMessage: error),
          (response) => CreateTripLoaded(tripDestination: response),
        ),
      );
    });

    //! EDIT TRIP

    on<EditTripEvent>((event, emit) async {
      emit(EditTripLoading());

      final response = await editTrip(event.params);

      emit(
        response.fold(
          (error) => GenericTripsError(errorMessage: error),
          (response) => EditTripLoaded(tripDestination: response),
        ),
      );
    });

    //! GET  ALL TRIPS

    on<GetAllTripsEvent>((event, emit) async {
      emit(GetAllTripLoading());

      final response = await getAllTrips(event.params);

      emit(
        response.fold(
          (error) => GenericTripsError(errorMessage: error),
          (response) => GetAllTripLoaded(allTripsInfo: response, tripDetails: [
            ...event.currentList,
            ...response.allTripsData!.list
          ]),
        ),
      );
    });

    //! GET TRIP INFO

    on<GetTripInfoEvent>((event, emit) async {
      emit(GetTripLoading());

      final response = await getTripInfo(event.params);

      emit(
        response.fold(
          (error) => GenericTripsError(errorMessage: error),
          (response) => GetTripLoaded(tripDetailsInfo: response),
        ),
      );
    });

    //! RATE TRIPS

    on<RateTripEvent>((event, emit) async {
      emit(RateTripLoading());

      final response = await rateTrip(event.params);

      emit(
        response.fold(
          (error) => GenericTripsError(errorMessage: error),
          (response) => RateTripLoaded(rate: response),
        ),
      );
    });

    //! REPORT TRIPS

    on<ReportTripEvent>((event, emit) async {
      emit(ReportTripLoading());

      final response = await reportTrip(event.params);

      emit(
        response.fold(
          (error) => GenericTripsError(errorMessage: error),
          (response) => ReportTripLoaded(report: response),
        ),
      );
    });

    //!FETCH PRICING
    on<FetchPricingEvent>((event, emit) async {
      emit(FetchPricingLoading());

      final response = await fetchPricing(event.params);

      emit(
        response.fold(
          (error) => FetchPricingError(message: error),
          (response) => FetchPricingLoaded(
            createTripInfo: response,
          ),
        ),
      );
    });

    //!RETRY BOOKING
    on<RetryBookingEvent>((event, emit) async {
      emit(RetryBookingLoading());

      final response = await retryBooking(event.params);

      emit(
        response.fold(
          (error) => RetryBookingError(message: error),
          (response) => RetryBookingLoaded(
            createTripInfo: response,
          ),
        ),
      );
    });

    //!INTITIATE TRACKING
    on<InitiateTrackingEvent>((event, emit) async {
      await emit.forEach(initiateTracking.call(event.params), onData: (data) {
        emit(InitiateTrackingLoading());
        return data.fold(
          (error) => InitiateTrackingError(
            message: error,
          ),
          (response) => InitiateTrackingLoaded(
            trackingInfo: response,
          ),
        );
      });
    });

    //!TERMINATE TRACKING
    on<TerminateTrackingEvent>((event, emit) async {
      await terminateTracking(event.params);
    });

    //!INTITIATE DRIVER LOOKUP
    on<InitiateDriverLookupEvent>((event, emit) async {
      await emit.forEach(initiateDriverLookup.call(event.params),
          onData: (data) {
        emit(InitiateDriverLookupLoading());
        return data.fold(
          (error) => InitiateDriverLookupError(
            message: error,
          ),
          (response) => InitiateDriverLookupLoaded(
            trackingInfo: response,
          ),
        );
      });
    });

    //!TERMINATE TRACKING
    on<TerminateDriverLookupEvent>((event, emit) async {
      await terminateDriverLookup(event.params);
    });

    //!GET DIRECTIONS
    on<GetDirectionsEvent>((event, emit) async {
      emit(GetDirectionsLoading());

      final response = await getDirections(event.params);

      emit(
        response.fold(
          (error) => GetDirectionsError(error: error),
          (response) => GetDirectionsLoaded(directions: response),
        ),
      );
    });
  }

  //return destinations
  List<Map> returnDestinationMap(
      {required List<dynamic> locations,
      required List<TextEditingController> contacts}) {
    List<Map> someshit = [];

    for (int i = 0; i < locations.length; i++) {
      someshit.add({
        "customer_phone": contacts[i].text,
        "geo_data_id": locations[i]['id'],
        "destination_type": "drop-off",
      });
    }

    return someshit;
  }

  //check contacts availability
  bool allContactsAdded({required List<TextEditingController> contacts}) {
    bool holder = true;

    for (int i = 0; i < contacts.length; i++) {
      if (contacts[i].text.isEmpty) {
        holder = false;
        break;
      }
    }

    return holder;
  }

  //CHECK VALIDITY OF NUMBER

  bool isValidNumber(String phoneNumber) {
    final regex = RegExp(r'(\+)?(233)|(0)[25][0345679]\d{7}$');

    final match = regex.firstMatch(phoneNumber);

    if (match == null) {
      return false;
    }

    return true;
  }

  //parse Time String
  Duration parseTimeString(String timeString) {
    List<String> parts = timeString.split(':');
    int hours = int.parse(parts[0]);
    int minutes = int.parse(parts[1]);
    int seconds = int.parse(parts[2]);

    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  //get geo data ids for making request for pricing
  List<Map<String, dynamic>> getGeoDataIds(List<dynamic> data) {
    List<Map<String, dynamic>> ids = [];

    for (var element in data) {
      ids.add({
        "geo_data_id": element['id'],
      });
    }

    return ids;
  }

  //pricing data parsing

  CreateTripInfo decodePricingInfo(String jsonString) {
    return CreateTripInfoModel.fromJson(jsonDecode(jsonString));
  }

  //update markers for polyline on pricing page

  Set<Marker> updateMarkersForPolyLine(CreateTripInfo createTripInfo) {
    Set<Marker> marker = {};

    marker.add(
      Marker(
        markerId: MarkerId(createTripInfo.pickupAddress ?? ''),
        infoWindow: InfoWindow(
          title: createTripInfo.pickupAddress,
        ),
        position: LatLng(
          createTripInfo.pickupLat?.toDouble() ?? 0,
          createTripInfo.pickupLng?.toDouble() ?? 0,
        ),
      ),
    );

    for (var location in createTripInfo.destinations!) {
      marker.add(
        Marker(
          markerId: MarkerId(location.address!),
          infoWindow: InfoWindow(
            title: location.address ?? '',
          ),
          position: LatLng(
            location.lat.toDouble(),
            location.lng.toDouble(),
          ),
        ),
      );
    }

    return marker;
  }

//trip info data parsing

  TripDetails decodeTripDetailsInfo(String jsonString) {
    return TripDestinationDataModel.fromJson(jsonDecode(jsonString));
  }

//sort under date

  List<MapEntry<DateTime, List<AllTripDetails>>> getCategorizedTripsHistory(
      List<AllTripDetails> bills) {
    Map<DateTime, List<AllTripDetails>> history = {};

    for (final data in bills) {
      final keys = history.keys;
      final key = keys.firstWhere(
        (element) => element.isSameDate(
            DateTime.parse(data.createdAt ?? DateTime.now().toString())),
        orElse: () =>
            DateTime.parse(data.createdAt ?? DateTime.now().toString()),
      );
      if (history.containsKey(key)) {
        history[key]!.add(data);
      } else {
        history[key] = [data];
      }
    }

    List<MapEntry<DateTime, List<AllTripDetails>>> historyList = history.entries
        .map(
          (e) => e,
        )
        .toList();
    return historyList;
  }

  //get order page tracking intent
  TrackingInfoNotice getSearchTrackInfo(
    TrackingInfo? trackingInfo,
    BuildContext context,
  ) {
    switch (trackingInfo?.status ?? 'searching') {
      case 'searching':
        return TrackingInfoNotice(
          header: context.appLocalizations.checkingForCar,
          subtitle: context.appLocalizations.checkingForCarInfo,
        );

      case 'driver-found':
        return TrackingInfoNotice(
          header: context.appLocalizations.availableDriverFound,
          subtitle: context.appLocalizations.availableDriverFoundInfo,
        );

      case 'driver-not-found':
        return TrackingInfoNotice(
          header: context.appLocalizations.driverNotFound,
          subtitle: context.appLocalizations.driverNotFoundInfo,
        );

      case 'driver-assigned':
        return TrackingInfoNotice(
          header: context.appLocalizations.driverNotFound,
          subtitle: context.appLocalizations.driverNotFoundInfo,
        );

      default:
        return TrackingInfoNotice(
          header: context.appLocalizations.checkingForCar,
          subtitle: context.appLocalizations.checkingForCarInfo,
        );
    }
  }

  //scheduled string notice

  String scheduleInfoString(String date, BuildContext context) {
    DateTime tripDate =
        DateTime.parse(date).toLocal(); // Parse and convert to local time

    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime tomorrow = today.add(const Duration(days: 1));

    // Formatting for time
    String timeString =
        DateFormat('h:mma').format(tripDate).toLowerCase(); // format to 10:23am

    // Compare dates
    if (tripDate.year == today.year &&
        tripDate.month == today.month &&
        tripDate.day == today.day) {
      return context.appLocalizations.tripScheduleNotice('today', timeString);
    } else if (tripDate.year == tomorrow.year &&
        tripDate.month == tomorrow.month &&
        tripDate.day == tomorrow.day) {
      return context.appLocalizations
          .tripScheduleNotice('tomorrow', timeString);
    } else {
      String dateString =
          DateFormat('d MMM').format(tripDate); // format to 12th Sept

      return context.appLocalizations
          .tripScheduleNotice(dateString, timeString);
    }
  }

  //tracking strings
  String getTrackingStrings(
      {required String status,
      required String? arrivedAt,
      required BuildContext context}) {
    switch (status) {
      case 'assigned':
        return arrivedAt == null
            ? context.appLocalizations.drivingToPickup
            : context.appLocalizations.driverAtPickup;

      case 'started':
        return context.appLocalizations.drivingToDestination;

      case 'completed':
        return context.appLocalizations.driverAtDestination;
      default:
        return context.appLocalizations.drivingToPickup;
    }
  }

  String convertToKM({required LatLng pickup, required LatLng dropOff}) {
    const radius = 6371; // Radius of the earth in km
    final dLat = degToRad(pickup.latitude - dropOff.latitude); // degToRad below
    final dLon = degToRad(pickup.longitude - dropOff.longitude);
    final a = sin(dLat / 2) * sin(dLat / 2) +
        cos(degToRad(dropOff.latitude)) *
            cos(degToRad(pickup.latitude)) *
            sin(dLon / 2) *
            sin(dLon / 2);
    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    final distance = radius * c; // Distance in km

    return distance.toStringAsFixed(2);
  }

  //degree to radians

  double degToRad(deg) {
    return (deg * pi) / 180;
  }

  Future<bool> reCallDirectionsApi(
      {required BuildContext context, required LatLng riderLocation}) async {
    bool callGoogle = false;
    List<LatLng> polyCoordinates = context.read<TripProvider>().polyCoordinates;

    final latLngPosition =
        LatLng(riderLocation.latitude, riderLocation.longitude);

    if (polyCoordinates.length > 1) {
      for (int i = 0; i < polyCoordinates.length; i++) {
        if (i + 1 == polyCoordinates.length) {
          return false;
        }
        final distanceKm1 = double.parse(
            convertToKM(pickup: latLngPosition, dropOff: polyCoordinates[i]));
        final distanceKm2 = double.parse(convertToKM(
            pickup: latLngPosition, dropOff: polyCoordinates[i + 1]));

        if (distanceKm1 > distanceKm2) {
          //meaning he is on the right path

          polyCoordinates.removeRange(i, i + 1);
        } else {
          //there is a deviation. check for upward adjustment

          if (distanceKm1 > 0.05) {
            callGoogle = true;
          } else {
            break;
          }
        }
      }
    }

    context.read<TripProvider>().updatePolyCoordinates = polyCoordinates;

    if (!context.mounted) return false;

    return callGoogle;
  }
}
