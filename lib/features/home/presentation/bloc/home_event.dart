part of 'home_bloc.dart';

sealed class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object> get props => [];
}

final class FetchTopPlacesEvent extends HomeEvent {
  final Map<String, dynamic> params;

  const FetchTopPlacesEvent({required this.params});
}
