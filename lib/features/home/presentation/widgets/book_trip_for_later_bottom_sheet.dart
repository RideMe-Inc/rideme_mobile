import 'package:flutter/material.dart';

import 'package:rideme_mobile/features/home/presentation/widgets/book_trip_for_later_widget.dart';

buildBookTripForLaterBottomSheet({
  required BuildContext context,
  required DateTime chosenDate,
}) =>
    showModalBottomSheet(
      context: context,
      builder: (context) => BookTripForLater(
        chosenDate: chosenDate,
      ),
    );
