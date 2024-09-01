import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rideme_mobile/assets/images/image_name_constants.dart';
import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/size/sizes.dart';
import 'package:rideme_mobile/core/spacing/whitspacing.dart';
import 'package:rideme_mobile/core/theme/app_colors.dart';
import 'package:rideme_mobile/core/widgets/buttons/generic_button_widget.dart';
import 'package:rideme_mobile/features/trips/domain/entities/tracking_info.dart';
import 'package:rideme_mobile/features/trips/domain/entities/trip_destination_data.dart';
import 'package:rideme_mobile/features/trips/presentation/bloc/trips_bloc.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/cancel_trip_selection_bs.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/my_location_section_widget.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/payment/payment_type_selection.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/payment_method_section_widget.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/searching_for_rider_animation.dart';
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
  final tripsBloc2 = sl<TripsBloc>();
  late GoogleMapController mapController;
  TrackingInfo? trackingInfo;

  TripDetails? tripDetailsInfo;

  void onMapCreated(GoogleMapController controller) async {
    mapController = controller;

    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(tripDetailsInfo?.pickupLat?.toDouble() ?? 0,
            tripDetailsInfo?.pickupLng?.toDouble() ?? 0))));
  }

  initiateSearchTracking(String tripId) {
    //INTITATE TRACKING
    tripsBloc2.add(InitiateDriverLookupEvent(params: {
      "event": "driver-lookup",
      "data": {"trip_id": tripId}
    }));
  }

  initTracking() {
    if (tripDetailsInfo?.id != null) {
      initiateSearchTracking(tripDetailsInfo!.id.toString());
    }
  }

  terminateTracking(String trackingId) {
    tripsBloc2.add(
      TerminateDriverLookupEvent(params: {
        "event": "driver-lookup-stop",
        "data": {"trip_id": trackingId}
      }),
    );
  }

  @override
  void initState() {
    tripDetailsInfo = tripsBloc.decodeTripDetailsInfo(widget.tripInfo);
    initTracking();

    super.initState();
  }

  //TODO: RETRY FUNCTIONALITY

  @override
  void dispose() {
    mapController.dispose();
    terminateTracking(tripDetailsInfo!.id!.toString());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener(
            bloc: tripsBloc2,
            listener: (context, state) {
              print(state);
              if (state is InitiateDriverLookupLoaded) {
                print(state.trackingInfo);
                trackingInfo = state.trackingInfo;

                setState(() {});
              }

              if (state is InitiateDriverLookupError) {}
            },
          ),
          BlocListener(
            bloc: tripsBloc,
            listener: (context, state) {
              // TODO: implement listener
            },
          ),
        ],
        child: Stack(
          children: [
            Stack(
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
                                tripDetailsInfo?.pickupLat?.toDouble() ??
                                    44.9706674,
                                tripDetailsInfo?.pickupLng?.toDouble() ??
                                    -93.3438785),
                            zoom: 16,
                          ),
                          markers: const {},
                        )
                      : null,
                ),
                if (trackingInfo?.status != 'driver-not-found')
                  Container(
                    height: Sizes.height(context, 0.65),
                    width: double.infinity,
                    color: Colors.black38,
                    child: SearchingForRiderAnimation(
                      eta: trackingInfo?.timeToArrival != null
                          ? DateFormat('m').format(DateFormat('Hms', 'en_US')
                              .parse(trackingInfo!.timeToArrival!))
                          : '5',
                    ),
                  ),
              ],
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  tripsBloc
                                      .getSearchTrackInfo(trackingInfo, context)
                                      .header,
                                  style: context.textTheme.headlineSmall
                                      ?.copyWith(fontSize: 20),
                                ),
                                Space.height(context, 0.004),
                                Text(
                                  tripsBloc
                                      .getSearchTrackInfo(trackingInfo, context)
                                      .subtitle,
                                  style:
                                      context.textTheme.displaySmall?.copyWith(
                                    color: AppColors.rideMeGreyDark,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                        Space.height(context, 0.024),

                        trackingInfo?.status == 'driver-not-found'
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Image.asset(
                                      ImageNameConstants.noDriverIMG,
                                      height: Sizes.height(context, 0.18),
                                    ),
                                  ),
                                  Space.height(context, 0.058),
                                  GenericButton(
                                    onTap: () {},
                                    label: context.appLocalizations.retry,
                                    isActive: true,
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  MyLocationSectionWidget(
                                      onEditTap: () {},
                                      onAddDestinationTap: () {},
                                      pickUp:
                                          tripDetailsInfo?.pickupAddress ?? '',
                                      dropOff: tripDetailsInfo
                                              ?.destinations?.last.address ??
                                          ''),
                                  Space.height(context, 0.03),
                                  PaymentMethodSectionWidget(
                                    paymentTypes:
                                        PaymentTypes.values.firstWhere(
                                      (element) =>
                                          element.name ==
                                          (tripDetailsInfo?.paymentMethod ??
                                              'cash'),
                                    ),
                                    amount: tripDetailsInfo?.amountCharged ?? 0,
                                    onEditTap: () {},
                                  ),
                                  Space.height(context, 0.042),
                                  GenericButton(
                                    onTap: () => buildCancelTripReasonsBS(
                                      context: context,
                                      tripId:
                                          tripDetailsInfo?.id?.toString() ?? '',
                                    ),
                                    label: context.appLocalizations.cancelTrip,
                                    isActive: true,
                                    buttonColor: AppColors.rideMeErrorNormal,
                                  ),
                                ],
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
      ),
    );
  }
}
