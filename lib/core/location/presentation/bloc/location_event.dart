part of 'location_bloc.dart';

sealed class LocationEvent extends Equatable {
  const LocationEvent();

  @override
  List<Object> get props => [];
}

//!SEARCH PLACES
final class SearchPlacesEvent extends LocationEvent {
  final Map<String, dynamic> params;

  const SearchPlacesEvent({required this.params});
}

//!GET GEO ID
final class GetGeoIDEvent extends LocationEvent {
  final Map<String, dynamic> params;
  final bool isPickup;
  final int? index;

  const GetGeoIDEvent({
    required this.params,
    required this.isPickup,
    required this.index,
  });
}

//!CLEAR SEARCH RESULTS
final class ClearSearchResultsEvent extends LocationEvent {}
