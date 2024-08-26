import 'package:flutter/material.dart';
import 'package:rideme_mobile/features/trips/presentation/pages/book_trip.dart';

buildWhereToBottomSheet(
        {required BuildContext context, required Map locations}) =>
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) => BookTripPage(
        locations: locations,
      ),
    );
