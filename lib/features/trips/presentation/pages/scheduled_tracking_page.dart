import 'package:flutter/material.dart';

class ScheduledTrackingPage extends StatefulWidget {
  const ScheduledTrackingPage({
    super.key,
    required this.tripId,
  });
  final String tripId;

  @override
  State<ScheduledTrackingPage> createState() => _ScheduledTrackingPageState();
}

class _ScheduledTrackingPageState extends State<ScheduledTrackingPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('SCHEDULE TRIP TRACKING PAGE'),
      ),
    );
  }
}
