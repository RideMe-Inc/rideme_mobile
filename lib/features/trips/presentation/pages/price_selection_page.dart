import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/size/sizes.dart';
import 'package:rideme_mobile/core/spacing/whitspacing.dart';
import 'package:rideme_mobile/core/theme/app_colors.dart';
import 'package:rideme_mobile/core/widgets/buttons/generic_button_widget.dart';
import 'package:rideme_mobile/core/widgets/loaders/loading_indicator.dart';
import 'package:rideme_mobile/core/widgets/popups/error_popup.dart';
import 'package:rideme_mobile/features/authentication/presentation/provider/authentication_provider.dart';
import 'package:rideme_mobile/features/home/presentation/provider/home_provider.dart';
import 'package:rideme_mobile/features/localization/presentation/providers/locale_provider.dart';
import 'package:rideme_mobile/features/trips/domain/entities/create_trip_info.dart';
import 'package:rideme_mobile/features/trips/presentation/bloc/trips_bloc.dart';
import 'package:rideme_mobile/features/trips/presentation/provider/trip_provider.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/payment/payment_type_bs.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/payment/payment_type_selection.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/pricing_card.dart';
import 'package:rideme_mobile/injection_container.dart';

class PriceSelectionPage extends StatefulWidget {
  final String pricing, isScheduled;
  const PriceSelectionPage({
    super.key,
    required this.pricing,
    required this.isScheduled,
  });

  @override
  State<PriceSelectionPage> createState() => _PriceSelectionPageState();
}

class _PriceSelectionPageState extends State<PriceSelectionPage> {
  final tripBloc = sl<TripsBloc>();

  int? selectedPriceId;
  CreateTripInfo? createTripInfo;
  late GoogleMapController mapController;
  late TripProvider tripProvider;
  late HomeProvider homeProvider;
  PaymentTypes? paymentTypes = PaymentTypes.cash;

  Set<Marker> markers = {};

  animateCameraBasedOnPoints() {
    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(
          min(createTripInfo?.pickupLat?.toDouble() ?? 0,
              createTripInfo?.destinations?.last.lat.toDouble() ?? 0),
          min(createTripInfo?.pickupLng?.toDouble() ?? 0,
              createTripInfo?.destinations?.last.lng.toDouble() ?? 0)),
      northeast: LatLng(
        max(createTripInfo?.pickupLat?.toDouble() ?? 0,
            createTripInfo?.destinations?.last.lat.toDouble() ?? 0),
        max(createTripInfo?.pickupLng?.toDouble() ?? 0,
            createTripInfo?.destinations?.last.lng.toDouble() ?? 0),
      ),
    );

    CameraUpdate cameraUpdate = CameraUpdate.newLatLngBounds(
      bounds,
      120,
    );

    mapController.animateCamera(cameraUpdate);
    tripProvider.updateInitialCameraMove = true;
  }

  void onMapCreated(GoogleMapController controller) async {
    mapController = controller;
    tripProvider.decodePolyline(createTripInfo!);

    // provider.updateMarkers(createTripInfo!);

    animateCameraBasedOnPoints();
    tripBloc.updateMarkersForPolyLine(createTripInfo!);
  }

  @override
  void initState() {
    createTripInfo = tripBloc.decodePricingInfo(widget.pricing);
    selectedPriceId = createTripInfo?.pricing[0].id.toInt();
    super.initState();
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    tripProvider = context.watch<TripProvider>();
    homeProvider = context.watch<HomeProvider>();
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: Sizes.height(context, 0.7),
            child: GoogleMap(
              mapType: MapType.terrain,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              polylines: {
                Polyline(
                  polylineId: const PolylineId('pricePolyline'),
                  color: AppColors.rideMeBlueNormalActive,
                  width: 4,
                  points: tripProvider.polyCoordinates,
                )
              },
              onMapCreated: onMapCreated,
              onCameraMove: (position) {
                if (!tripProvider.initialCameraMove) {
                  mapController.moveCamera(CameraUpdate.zoomTo(13));
                }
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    createTripInfo?.pickupLat?.toDouble() ?? 44.9706674,
                    createTripInfo?.pickupLng?.toDouble() ?? -93.3438785),
                zoom: 16,
              ),
              markers: tripProvider.polyCoordinates.isNotEmpty
                  ? {
                      Marker(
                        markerId: const MarkerId('start_point'),
                        icon: homeProvider.startIcon,
                        position: tripProvider.polyCoordinates.first,
                      ),
                      Marker(
                        markerId: const MarkerId('end_point'),
                        icon: homeProvider.endIcon,
                        position: tripProvider.polyCoordinates.last,
                      ),
                    }
                  : {},
            ),
          ),

          //MORE SECTION
          SafeArea(
            child: Align(
              alignment: Alignment.topLeft,
              child: Builder(builder: (context) {
                return GestureDetector(
                  onTap: () {
                    context.pop();
                  },
                  child: Container(
                    height: Sizes.height(context, 0.04),
                    width: Sizes.width(context, 0.2),
                    padding: Platform.isIOS
                        ? EdgeInsets.only(left: Sizes.width(context, 0.02))
                        : null,
                    decoration: const BoxDecoration(
                      color: AppColors.rideMeBackgroundLight,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 5,
                          spreadRadius: 1,
                          color: AppColors.rideMeGreyDark,
                          offset: Offset(0, 3.5),
                        )
                      ],
                    ),
                    child: Icon(
                      Platform.isIOS ? Icons.arrow_back_ios : Icons.arrow_back,
                      size: Sizes.height(
                        context,
                        0.02,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                if (createTripInfo?.discountApplied != null)
                  Container(
                    height: Sizes.height(context, 0.49),
                    alignment: Alignment.topCenter,
                    padding: EdgeInsets.symmetric(
                      vertical: Sizes.height(context, 0.005),
                      horizontal: Sizes.width(context, 0.04),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.rideMeBlack80,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(
                          Sizes.height(context, 0.03),
                        ),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SvgPicture.asset(
                        //   discountTagSVG,
                        //   height: Sizes.height(context, 0.016),
                        // ),
                        Space.width(context, 0.01),
                        Text(
                          createTripInfo!.discountApplied!,
                          style: context.textTheme.displaySmall!.copyWith(
                            fontSize: 12,
                            color: AppColors.rideMeWhite500,
                            fontWeight: FontWeight.w500,
                          ),
                        )
                      ],
                    ),
                  ),
                Container(
                  // padding: EdgeInsets.symmetric(
                  //   horizontal: Sizes.width(context, 0.04),
                  // ),
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
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Sizes.width(context, 0.04),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //title
                            Text(
                              context.appLocalizations.selectRide,
                              style: context.textTheme.displayMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                            ),

                            Space.height(context, 0.024),

                            //PRICE LISTING

                            Column(
                              children: List.generate(
                                createTripInfo?.pricing.length ?? 1,
                                (index) {
                                  return PricingCard(
                                    isSelected:
                                        createTripInfo!.pricing[index].id ==
                                            selectedPriceId,
                                    pricing: createTripInfo!.pricing[index],
                                    onTap: () {
                                      selectedPriceId = createTripInfo!
                                          .pricing[index].id as int;
                                      setState(() {});
                                    },
                                  );
                                },
                              ),
                            )

                            //delivery types
                          ],
                        ),
                      ),
                      Space.height(context, 0.03),
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: Sizes.height(context, 0.01),
                          horizontal: Sizes.width(context, 0.04),
                        ),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: AppColors.rideMeBackgroundLight,
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 30,
                              spreadRadius: 1,
                              color: AppColors.rideMeGreyNormal,
                              offset: Offset(0, -20),
                            )
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            PaymentTypeSelectionWidget(
                              onTap: () async {
                                final response =
                                    await buildPaymentTypeSelectionBs(
                                        context: context,
                                        paymentType: paymentTypes);

                                if (response != null) {
                                  paymentTypes = response;
                                  setState(() {});
                                }
                              },
                              paymentType: paymentTypes,
                            ),
                            Space.height(context, 0.032),
                            BlocConsumer(
                              bloc: tripBloc,
                              listener: (context, state) {
                                if (state is CreateTripLoaded) {
                                  //do navigation here
                                  final params = state
                                      .tripDestination.tripDestinationData!
                                      .toMap();

                                  context.pushNamed('driverAwait',
                                      queryParameters: {
                                        "tripInfo": jsonEncode(params)
                                      });
                                }

                                if (state is GenericTripsError) {
                                  if (kDebugMode) print(state.errorMessage);
                                  showErrorPopUp(state.errorMessage, context);
                                }
                              },
                              builder: (context, state) {
                                if (state is CreateTripLoading) {
                                  return const LoadingIndicator();
                                }

                                return GenericButton(
                                  onTap: () {
                                    final params = {
                                      "locale":
                                          context.read<LocaleProvider>().locale,
                                      "bearer": context
                                          .read<AuthenticationProvider>()
                                          .token,
                                      "body": {
                                        "price_id": selectedPriceId,
                                        "payment_method": paymentTypes?.name,
                                      },
                                      "urlParameters": {
                                        "id": createTripInfo?.tripID
                                      }
                                    };

                                    tripBloc
                                        .add(CreateTripEvent(params: params));
                                  },
                                  label: context.appLocalizations.selectRide,
                                  isActive: selectedPriceId != null &&
                                      paymentTypes != null,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
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
