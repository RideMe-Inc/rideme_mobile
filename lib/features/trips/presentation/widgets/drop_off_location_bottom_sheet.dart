import 'package:flutter/material.dart';
import 'package:rideme_mobile/features/trips/presentation/pages/book_trip.dart';

buildWhereToBottomSheet({
  required BuildContext context,
  required Map locations,
  bool? fromTopPlaces,
  bool? fromScheduled,
  String? scheduleDate,
}) =>
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) => BookTripPage(
        locations: locations,
        fromTopPlaces: fromTopPlaces,
        fromScheduled: fromScheduled,
        scheduledDate: scheduleDate,
      ),
    );
