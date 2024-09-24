part of 'location_bloc.dart';

sealed class LocationState extends Equatable {
  const LocationState();

  @override
  List<Object> get props => [];
}

class LocationInitial extends LocationState {}

//!SEARCH PLACES
//loading
final class SearchPlacesLoading extends LocationState {}

//loaded
final class SearchPlacesLoaded extends LocationState {
  final Places places;
  final bool? isPickUP;

  final int? dropOffIndex;

  const SearchPlacesLoaded({
    required this.places,
    required this.isPickUP,
    required this.dropOffIndex,
  });
}

//!GET GEO ID
//loading
final class GetGeoIDLoading extends LocationState {
  final bool? isPickup;
  final int? index;

  const GetGeoIDLoading({required this.isPickup, required this.index});
}

//loaded
final class GetGeoIDLoaded extends LocationState {
  final GeoData geoDataInfo;
  final bool isPickUp;
  final String? placedID;

  const GetGeoIDLoaded({
    required this.geoDataInfo,
    required this.isPickUp,
    required this.placedID,
  });
}

//error
final class GetGeoIDError extends LocationState {
  final String message;

  const GetGeoIDError({required this.message});
}

//error
final class SearchPlacesError extends LocationState {
  final String message;

  const SearchPlacesError({required this.message});
}

//!EDIT SAVED ADDRESS
final class EditSavedAddressLoading extends LocationState {}

final class EditSavedAddressLoaded extends LocationState {
  final String message;

  const EditSavedAddressLoaded({required this.message});
}

final class EditSavedAddressError extends LocationState {
  final String message;

  const EditSavedAddressError({required this.message});
}

//!SAVED ADDRESS
final class SavedAddressLoading extends LocationState {}

final class SavedAddressLoaded extends LocationState {
  final String message;

  const SavedAddressLoaded({required this.message});
}

final class SavedAddressError extends LocationState {
  final String message;

  const SavedAddressError({required this.message});
}
