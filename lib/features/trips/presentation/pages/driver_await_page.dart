import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rideme_mobile/core/size/sizes.dart';
import 'package:rideme_mobile/core/spacing/whitspacing.dart';
import 'package:rideme_mobile/core/theme/app_colors.dart';
import 'package:rideme_mobile/features/trips/domain/entities/trip_destination_data.dart';
import 'package:rideme_mobile/features/trips/presentation/bloc/trips_bloc.dart';
import 'package:rideme_mobile/injection_container.dart';

class DriverAwaitPage extends StatefulWidget {
  final String tripInfo;
  const DriverAwaitPage({
    super.key,
    required this.tripInfo,
  });

  @override
  State<DriverAwaitPage> createState() => _DriverAwaitPageState();
}

class _DriverAwaitPageState extends State<DriverAwaitPage> {
  final tripsBloc = sl<TripsBloc>();
  late GoogleMapController mapController;

  TripDetails? tripDetailsInfo;

  void onMapCreated(GoogleMapController controller) async {
    mapController = controller;

    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(tripDetailsInfo?.pickupLat?.toDouble() ?? 0,
            tripDetailsInfo?.pickupLng?.toDouble() ?? 0))));
  }

  @override
  void initState() {
    tripDetailsInfo = tripsBloc.decodeTripDetailsInfo(widget.tripInfo);

    super.initState();
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: Sizes.height(context, 0.8),
            child: tripDetailsInfo != null
                ? GoogleMap(
                    myLocationEnabled: false,
                    myLocationButtonEnabled: false,
                    polylines: const {},
                    onMapCreated: onMapCreated,
                    onCameraMove: (position) {
                      mapController.moveCamera(CameraUpdate.zoomTo(13));
                    },
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                          tripDetailsInfo?.pickupLat?.toDouble() ?? 44.9706674,
                          tripDetailsInfo?.pickupLng?.toDouble() ??
                              -93.3438785),
                      zoom: 16,
                    ),
                    markers: const {},
                  )
                : null,
          ),

          //bottom sheet
          Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: Sizes.width(context, 0.04),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.rideMeBackgroundLight,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(Sizes.height(context, 0.02)),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Space.height(context, 0.007),
                      Center(
                        child: Container(
                          width: Sizes.width(context, 0.08),
                          height: Sizes.height(context, 0.005),
                          decoration: BoxDecoration(
                            color: AppColors.rideMeGreyNormal,
                            borderRadius: BorderRadius.circular(
                              Sizes.height(context, 0.005),
                            ),
                          ),
                        ),
                      ),
                      Space.height(context, 0.011),
                      Space.height(context, 0.03),
                      Space.height(context, 0.03),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
