import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideme_mobile/core/location/domain/entity/geo_hash.dart';
import 'package:rideme_mobile/features/home/domain/usecases/fetch_top_places.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final FetchTopPlaces fetchTopPlaces;
  HomeBloc({
    required this.fetchTopPlaces,
  }) : super(HomeInitial()) {
    on<FetchTopPlacesEvent>((event, emit) async {
      emit(FetchTopPlacesLoading());

      final response = await fetchTopPlaces(event.params);

      emit(
        response.fold(
          (errorMessage) => FetchTopPlacesError(message: errorMessage),
          (response) => FetchTopPlacesLoaded(places: response),
        ),
      );
    });
  }
}
