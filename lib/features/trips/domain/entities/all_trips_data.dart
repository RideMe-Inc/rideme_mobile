import 'package:equatable/equatable.dart';
import 'package:rideme_mobile/core/pagination/pagination_entity.dart';
import 'package:rideme_mobile/features/trips/domain/entities/all_trips_details.dart';

class AllTripsData extends Equatable {
  final List<AllTripDetails> list;
  final Pagination? pagination;

  const AllTripsData({required this.list, required this.pagination});

  @override
  List<Object?> get props => [
        list,
        pagination,
      ];
}
