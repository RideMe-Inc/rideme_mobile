import 'package:flutter/material.dart';

class TripTrackingPage extends StatefulWidget {
  const TripTrackingPage({
    super.key,
    required this.tripId,
  });

  final String tripId;

  @override
  State<TripTrackingPage> createState() => _TripTrackingPageState();
}

class _TripTrackingPageState extends State<TripTrackingPage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Tracking page',
          )
        ],
      ),
    );
  }
}
