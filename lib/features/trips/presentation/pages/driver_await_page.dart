import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/size/sizes.dart';
import 'package:rideme_mobile/core/spacing/whitspacing.dart';
import 'package:rideme_mobile/core/theme/app_colors.dart';
import 'package:rideme_mobile/core/widgets/buttons/generic_button_widget.dart';
import 'package:rideme_mobile/features/trips/domain/entities/trip_destination_data.dart';
import 'package:rideme_mobile/features/trips/presentation/bloc/trips_bloc.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/my_location_section_widget.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/payment/payment_type_selection.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/payment_method_section_widget.dart';
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
          //TODO: WILL USE STATUS TO EITHER SHOW STATIC MAP OR ACTUAL MAP
          // Container(
          //   height: Sizes.height(context, 0.75),
          //   width: double.infinity,
          //   decoration: const BoxDecoration(
          //     color: AppColors.rideMeBlack20,
          //   ),
          //   child: Stack(
          //     alignment: Alignment.center,
          //     children: [
          //       Container(
          //         color: Colors.black38,
          //         height: Sizes.height(context, 0.75),
          //       ),
          //       const SearchingForRiderAnimation(
          //         eta: '7min',
          //       ),
          //     ],
          //   ),
          // ),
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
                      Space.height(context, 0.014),
                      //STATUS UPDATES WILL BE HERE
                      Space.height(context, 0.016),
                      MyLocationSectionWidget(
                          onEditTap: () {},
                          onAddDestinationTap: () {},
                          pickUp: tripDetailsInfo?.pickupAddress ?? '',
                          dropOff:
                              tripDetailsInfo?.destinations?.last.address ??
                                  ''),
                      Space.height(context, 0.03),

                      PaymentMethodSectionWidget(
                        paymentTypes: PaymentTypes.values.firstWhere(
                          (element) =>
                              element.name ==
                              (tripDetailsInfo?.paymentMethod ?? 'cash'),
                        ),
                        amount: tripDetailsInfo?.amountCharged ?? 0,
                        onEditTap: () {},
                      ),

                      Space.height(context, 0.042),

                      GenericButton(
                        onTap: () {},
                        label: context.appLocalizations.cancelTrip,
                        isActive: true,
                        buttonColor: AppColors.rideMeErrorNormal,
                      ),
                      Space.height(context, 0.02),
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
