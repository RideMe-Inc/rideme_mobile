part of 'home_bloc.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

//!FETCH TOP PLACES
final class FetchTopPlacesLoading extends HomeState {}

final class FetchTopPlacesLoaded extends HomeState {
  final List<GeoData> places;

  const FetchTopPlacesLoaded({required this.places});
}

final class FetchTopPlacesError extends HomeState {
  final String message;

  const FetchTopPlacesError({required this.message});
}
