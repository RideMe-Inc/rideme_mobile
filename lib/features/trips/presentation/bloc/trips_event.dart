part of 'trips_bloc.dart';

sealed class TripsEvent extends Equatable {
  const TripsEvent();

  @override
  List<Object> get props => [];
}

//!CANCEL TRIP
class CancelTripEvent extends TripsEvent {
  final Map<String, dynamic> params;

  const CancelTripEvent({required this.params});
}

//!CREATE TRIP
class CreateTripEvent extends TripsEvent {
  final Map<String, dynamic> params;

  const CreateTripEvent({required this.params});
}

//!EDIT TRIP
class EditTripEvent extends TripsEvent {
  final Map<String, dynamic> params;

  const EditTripEvent({required this.params});
}

//!GET ALL TRIP
class GetAllTripsEvent extends TripsEvent {
  final Map<String, dynamic> params;
  final List<AllTripDetails> currentList;

  const GetAllTripsEvent({
    required this.params,
    required this.currentList,
  });
}

//!GET TRIP INFO
class GetTripInfoEvent extends TripsEvent {
  final Map<String, dynamic> params;

  const GetTripInfoEvent({required this.params});
}

//!RATE TRIP
class RateTripEvent extends TripsEvent {
  final Map<String, dynamic> params;

  const RateTripEvent({required this.params});
}

//!REPORT TRIP
class ReportTripEvent extends TripsEvent {
  final Map<String, dynamic> params;

  const ReportTripEvent({required this.params});
}

//!CREATE TRIP OR FETCH PRICING
final class FetchPricingEvent extends TripsEvent {
  final Map<String, dynamic> params;

  const FetchPricingEvent({required this.params});
}

//!INITIATE TRACKING

final class InitiateTrackingEvent extends TripsEvent {
  final Map<String, dynamic> params;

  const InitiateTrackingEvent({required this.params});
}

//!TERMINATE TRACKING

final class TerminateTrackingEvent extends TripsEvent {
  final Map<String, dynamic> params;

  const TerminateTrackingEvent({required this.params});
}
