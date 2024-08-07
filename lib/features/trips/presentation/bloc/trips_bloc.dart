import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideme_mobile/features/trips/domain/entities/all_trips_details.dart';

import 'package:rideme_mobile/features/trips/domain/usecases/edit_trip.dart';

import 'package:equatable/equatable.dart';
import 'package:rideme_mobile/features/trips/domain/entities/all_trips_info.dart';
import 'package:rideme_mobile/features/trips/domain/entities/create_trip_info.dart';

import 'package:rideme_mobile/features/trips/domain/entities/geo_data.dart';
import 'package:rideme_mobile/features/trips/domain/entities/places_info.dart';
import 'package:rideme_mobile/features/trips/domain/entities/tracking_info.dart';
import 'package:rideme_mobile/features/trips/domain/entities/trip_destination_info.dart';

import 'package:rideme_mobile/features/trips/domain/usecases/cancel_trip.dart';
import 'package:rideme_mobile/features/trips/domain/usecases/create_trip.dart';
import 'package:rideme_mobile/features/trips/domain/usecases/fetch_pricing.dart';
import 'package:rideme_mobile/features/trips/domain/usecases/get_all_trips.dart';
import 'package:rideme_mobile/features/trips/domain/usecases/get_geo_id.dart';
import 'package:rideme_mobile/features/trips/domain/usecases/get_trip_info.dart';
import 'package:rideme_mobile/features/trips/domain/usecases/initiate_tracking.dart';
import 'package:rideme_mobile/features/trips/domain/usecases/rate_trip.dart';
import 'package:rideme_mobile/features/trips/domain/usecases/report_trip.dart';
import 'package:rideme_mobile/features/trips/domain/usecases/search_place.dart';
import 'package:rideme_mobile/features/trips/domain/usecases/terminate_tracking.dart';

part 'trips_event.dart';
part 'trips_state.dart';

class TripsBloc extends Bloc<TripsEvent, TripsState> {
  final CancelTrip cancelTrip;
  final CreateTrip createTrip;
  final GetAllTrips getAllTrips;
  final RateTrip rateTrip;
  final ReportTrip reportTrip;
  final GetTripInfo getTripInfo;
  final SearchPlace searchPlace;
  final GetGeoID getGeoID;
  final FetchPricing fetchPricing;
  final InitiateTracking initiateTracking;
  final TerminateTracking terminateTracking;
  final EditTrip editTrip;

  TripsBloc({
    required this.cancelTrip,
    required this.createTrip,
    required this.getAllTrips,
    required this.rateTrip,
    required this.getTripInfo,
    required this.reportTrip,
    required this.searchPlace,
    required this.getGeoID,
    required this.fetchPricing,
    required this.initiateTracking,
    required this.terminateTracking,
    required this.editTrip,
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

    //!SEARCH PLACES

    on<SearchPlacesEvent>(
      (event, emit) async {
        emit(SearchPlacesLoading());

        final response = await searchPlace(event.params['body']);

        emit(
          response.fold(
            (error) => SearchPlacesError(message: error),
            (response) => SearchPlacesLoaded(
              places: response,
              isPickUP: event.params['isPickUP'],
              dropOffIndex: event.params['dropOffIndex'],
            ),
          ),
        );
      },
      transformer: restartable(),
    );
    //clear results

    on<ClearSearchResultsEvent>((event, emit) async {
      emit(SearchPlacesLoading());
    });

    //!GET GEO ID
    on<GetGeoIDEvent>(
      (event, emit) async {
        emit(
          GetGeoIDLoading(
            isPickup: event.isPickUp,
            index: event.index,
          ),
        );

        final response = await getGeoID(event.params);

        emit(
          response.fold(
            (error) => GetGeoIDError(message: error),
            (response) => GetGeoIDLoaded(
              geoDataInfo: response,
              placedID: event.params['queryParams']['google_map_id'],
              isPickUP: event.isPickUp,
            ),
          ),
        );
      },
      transformer: restartable(),
    );

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
}
