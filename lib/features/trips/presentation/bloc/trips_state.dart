part of 'trips_bloc.dart';

sealed class TripsState extends Equatable {
  const TripsState();

  @override
  List<Object> get props => [];
}

final class TripsInitial extends TripsState {}

class GenericTripsError extends TripsState {
  final String errorMessage;

  const GenericTripsError({required this.errorMessage});
}

//! CANCEL TRIP

//loading
class CancelTripLoading extends TripsState {}

//loaded
class CancelTripLoaded extends TripsState {
  final String message;

  const CancelTripLoaded({required this.message});
}

//! CREATE TRIP

//loading
class CreateTripLoading extends TripsState {}

//loaded
class CreateTripLoaded extends TripsState {
  final TripDetailsInfo tripDestination;

  const CreateTripLoaded({required this.tripDestination});
}

//! EDIT TRIP

//loading
class EditTripLoading extends TripsState {}

//loaded
class EditTripLoaded extends TripsState {
  final TripDetailsInfo tripDestination;

  const EditTripLoaded({required this.tripDestination});
}

//! GET ALL TRIP

//loading
class GetAllTripLoading extends TripsState {}

//loaded
class GetAllTripLoaded extends TripsState {
  final AllTripsInfo allTripsInfo;
  final List<AllTripDetails> tripDetails;

  const GetAllTripLoaded({
    required this.allTripsInfo,
    required this.tripDetails,
  });
}

//! GET  TRIP DETAILS

//loading
class GetTripLoading extends TripsState {}

//loaded
class GetTripLoaded extends TripsState {
  final TripDetailsInfo tripDetailsInfo;

  const GetTripLoaded({required this.tripDetailsInfo});
}

//! RATE  TRIP

//loading
class RateTripLoading extends TripsState {}

//loaded
class RateTripLoaded extends TripsState {
  final String rate;

  const RateTripLoaded({required this.rate});
}

//! REPORT   TRIP

//loading
class ReportTripLoading extends TripsState {}

//loaded
class ReportTripLoaded extends TripsState {
  final String report;

  const ReportTripLoaded({required this.report});
}

//!CREATE OR FETCH PRICING
//loading
final class FetchPricingLoading extends TripsState {}

//loaded
final class FetchPricingLoaded extends TripsState {
  final CreateTripInfo createTripInfo;

  const FetchPricingLoaded({required this.createTripInfo});
}

//error
final class FetchPricingError extends TripsState {
  final String message;

  const FetchPricingError({required this.message});
}

//!INITIATE TRACKING

//loading
final class InitiateTrackingLoading extends TripsState {}

//loaded
final class InitiateTrackingLoaded extends TripsState {
  final TrackingInfo trackingInfo;

  const InitiateTrackingLoaded({required this.trackingInfo});
}

//error
final class InitiateTrackingError extends TripsState {
  final String message;

  const InitiateTrackingError({required this.message});
}

//!INITIATE DRIVER LOOKUP

//loading
final class InitiateDriverLookupLoading extends TripsState {}

//loaded
final class InitiateDriverLookupLoaded extends TripsState {
  final TrackingInfo trackingInfo;

  const InitiateDriverLookupLoaded({required this.trackingInfo});
}

//error
final class InitiateDriverLookupError extends TripsState {
  final String message;

  const InitiateDriverLookupError({required this.message});
}
