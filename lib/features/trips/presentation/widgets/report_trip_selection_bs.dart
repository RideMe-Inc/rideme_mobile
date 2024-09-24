import 'package:flutter/material.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/report_trip_selection.dart';

buildReportTripBS({required BuildContext context, required String tripId}) =>
    showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) => SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: ReportTripReasonsPage(
            tripId: tripId,
          ),
        ),
      ),
    );
