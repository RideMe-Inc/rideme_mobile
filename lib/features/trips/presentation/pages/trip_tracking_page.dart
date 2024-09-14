import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rideme_mobile/assets/svgs/svg_name_constants.dart';
import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/size/sizes.dart';
import 'package:rideme_mobile/core/spacing/whitspacing.dart';
import 'package:rideme_mobile/core/theme/app_colors.dart';
import 'package:rideme_mobile/core/widgets/buttons/generic_button_widget.dart';
import 'package:rideme_mobile/features/authentication/presentation/provider/authentication_provider.dart';
import 'package:rideme_mobile/features/home/presentation/provider/home_provider.dart';
import 'package:rideme_mobile/features/localization/presentation/providers/locale_provider.dart';
import 'package:rideme_mobile/features/trips/domain/entities/trip_destination_data.dart';
import 'package:rideme_mobile/features/trips/presentation/bloc/trips_bloc.dart';
import 'package:rideme_mobile/features/trips/presentation/provider/trip_provider.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/cancel_trip_selection_bs.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/my_location_section_widget.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/payment/payment_type_selection.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/payment_method_section_widget.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/tracking/tracking_action_button.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/tracking/tracking_header_widget.dart';
import 'package:rideme_mobile/injection_container.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

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
  final tripBloc = sl<TripsBloc>();
  final tripBloc2 = sl<TripsBloc>();
  final tripBloc3 = sl<TripsBloc>();

  late GoogleMapController mapController;
  late HomeProvider homeProvider;
  late TripProvider tripProvider;
  TripDetails? tripDetails;
  Set<Marker>? markers = {};

  Marker? driverMarker;

  void onMapCreated(GoogleMapController controller) async {
    mapController = controller;

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // getServiceInfo(lat: position.latitude, lng: position.longitude);

    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
          target: LatLng(position.latitude, position.longitude), zoom: 14.5),
    ));
  }

  fetchTripDetails() {
    final params = {
      'locale': context.read<LocaleProvider>().locale,
      'bearer': context.read<AuthenticationProvider>().token!,
      'urlParameters': {
        'id': widget.tripId,
      },
    };

    tripBloc.add(GetTripInfoEvent(params: params));
  }

  initiateDriverTracking() {
    //INTITATE TRACKING
    tripBloc2.add(InitiateTrackingEvent(params: {
      "event": "track-trip",
      "data": {"trip_id": widget.tripId}
    }));
  }

  terminateTracking() {
    tripBloc2.add(
      TerminateTrackingEvent(params: {
        "event": "track-trip-stop",
        "data": {"trip_id": widget.tripId}
      }),
    );
  }

  callDirectionsApi(Map<String, dynamic> params) {
    tripBloc3.add(GetDirectionsEvent(params: params));
  }

  @override
  void initState() {
    fetchTripDetails();
    initiateDriverTracking();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    homeProvider = context.watch<HomeProvider>();
    tripProvider = context.watch<TripProvider>();
    return MultiBlocListener(
      listeners: [
        BlocListener(
          bloc: tripBloc,
          listener: (context, state) {
            if (state is GetTripLoaded) {
              setState(() {
                tripDetails = state.tripDetailsInfo.tripDestinationData;
              });
            }
          },
        ),
        BlocListener(
          bloc: tripBloc2,
          listener: (context, state) {
            if (state is InitiateTrackingLoaded) {
              setState(() {
                markers = {
                  Marker(
                    markerId: const MarkerId('driver_marker'),
                    icon: homeProvider.customMarkerIcon,
                    position: LatLng(
                        state.trackingInfo.driverLat?.toDouble() ?? 0,
                        state.trackingInfo.driverLng?.toDouble() ?? 0),
                    rotation: state.trackingInfo.heading?.toDouble() ?? 0,
                  )
                };
              });
            }
          },
          child: Container(),
        ),
        BlocListener(
          bloc: tripBloc3,
          listener: (context, state) {
            if (state is GetDirectionsLoaded) {
              tripProvider.decodePolylineFromString(
                  state.directions.routes!.first.overviewPolyline!.points!);
            }
          },
          child: Container(),
        )
      ],
      child: Scaffold(
        body: SlidingUpPanel(
          boxShadow: null,
          minHeight: Sizes.height(context, 0.35),
          maxHeight: Sizes.height(context, 0.7),
          color: Colors.transparent,
          collapsed: tripDetails != null
              ? _CollapsedWidget(
                  tripDetails: tripDetails!,
                  tripsBloc: tripBloc,
                )
              : Container(),
          panel: tripDetails != null
              ? _PanelWidget(tripDetails: tripDetails!, tripsBloc: tripBloc)
              : Container(),
          body: Stack(
            children: [
              SizedBox(
                height: Sizes.height(context, 0.85),
                child: GoogleMap(
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  mapType: MapType.terrain,
                  onMapCreated: onMapCreated,
                  markers: markers != null ? markers! : {},
                  polylines: {
                    Polyline(
                      polylineId: const PolylineId('trip_line'),
                      points: tripProvider.polyCoordinates,
                      color: AppColors.rideMeBlueDark,
                      width: 5,
                    )
                  },
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(
                      0,
                      0,
                    ),
                    zoom: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//!PANEL WIDGET
class _PanelWidget extends StatefulWidget {
  final TripDetails tripDetails;
  final TripsBloc tripsBloc;

  const _PanelWidget({required this.tripDetails, required this.tripsBloc});

  @override
  State<_PanelWidget> createState() => __PanelWidgetState();
}

class __PanelWidgetState extends State<_PanelWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Sizes.height(context, 0.02)),
      decoration: const BoxDecoration(
        color: AppColors.rideMeBackgroundLight,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Space.height(context, 0.015),
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
          //header
          TrackingHeaderWidget(
            header: widget.tripsBloc.getTrackingStrings(
                status: widget.tripDetails.status ?? 'assigned',
                arrivedAt: widget.tripDetails.arrivedAt,
                context: context),
            carType:
                '${widget.tripDetails.driver?.vehicleMake ?? ''} ${widget.tripDetails.driver?.vehicleModel ?? ''}, ${widget.tripDetails.driver?.vehicleColor ?? ''} - ${widget.tripDetails.driver?.vehicleRegistrationNumber ?? ''}',
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Space.height(context, 0.016),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      RiderInfoTile(
                        name: widget.tripDetails.driver?.firstName ?? '',
                        imagePath: widget.tripDetails.driver!.profileURL!,
                      ),
                      TrackActionButton(
                        onTap: () {},
                        svgPath: SvgNameConstants.shareSVG,
                        label: context.appLocalizations.shareTrip,
                      ),
                      TrackActionButton(
                        onTap: () {},
                        svgPath: SvgNameConstants.inRideSafetySVG,
                        label: context.appLocalizations.safety,
                      )
                    ],
                  ),
                  Space.height(context, 0.04),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      TrackActionButton(
                        onTap: () {},
                        svgPath: SvgNameConstants.safetySVG,
                        label: 'Chat',
                      ),
                      TrackActionButton(
                        onTap: () {},
                        svgPath: SvgNameConstants.phoneSVG,
                        label: context.appLocalizations.call,
                      )
                    ],
                  ),
                  Space.height(context, 0.022),
                  MyLocationSectionWidget(
                      onEditTap: () {},
                      onAddDestinationTap: () {},
                      pickUp: widget.tripDetails.pickupAddress ?? '',
                      dropOff:
                          widget.tripDetails.destinations?.last.address ?? ''),
                  Space.height(context, 0.03),
                  PaymentMethodSectionWidget(
                    paymentTypes: PaymentTypes.values.firstWhere(
                      (element) =>
                          element.name ==
                          (widget.tripDetails.paymentMethod ?? 'cash'),
                    ),
                    amount: widget.tripDetails.amountCharged ?? 0,
                    onEditTap: () {},
                  ),
                  Space.height(context, 0.042),
                  GenericButton(
                    onTap: () => buildCancelTripReasonsBS(
                      context: context,
                      tripId: widget.tripDetails.id?.toString() ?? '',
                    ),
                    label: context.appLocalizations.cancelTrip,
                    isActive: true,
                    buttonColor: AppColors.rideMeErrorNormal,
                  ),
                  Space.height(context, 0.02),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//!COLLAPSED WIDGET

class _CollapsedWidget extends StatefulWidget {
  final TripDetails tripDetails;
  final TripsBloc tripsBloc;
  const _CollapsedWidget({required this.tripDetails, required this.tripsBloc});

  @override
  State<_CollapsedWidget> createState() => __CollapsedWidgetState();
}

class __CollapsedWidgetState extends State<_CollapsedWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: Sizes.height(context, 0.02)),
      decoration: const BoxDecoration(
        color: AppColors.rideMeBackgroundLight,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          Space.height(context, 0.015),
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
          //header
          TrackingHeaderWidget(
            header: widget.tripsBloc.getTrackingStrings(
                status: widget.tripDetails.status ?? 'assigned',
                arrivedAt: widget.tripDetails.arrivedAt,
                context: context),
            carType:
                '${widget.tripDetails.driver?.vehicleMake ?? ''} ${widget.tripDetails.driver?.vehicleModel ?? ''}, ${widget.tripDetails.driver?.vehicleColor ?? ''} - ${widget.tripDetails.driver?.vehicleRegistrationNumber ?? ''}',
          ),

          Space.height(context, 0.016),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              RiderInfoTile(
                name: widget.tripDetails.driver?.firstName ?? '',
                imagePath: widget.tripDetails.driver!.profileURL!,
              ),
              TrackActionButton(
                onTap: () {},
                svgPath: SvgNameConstants.shareSVG,
                label: context.appLocalizations.shareTrip,
              ),
              TrackActionButton(
                onTap: () {},
                svgPath: SvgNameConstants.inRideSafetySVG,
                label: context.appLocalizations.safety,
              )
            ],
          ),
          Space.height(context, 0.04),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TrackActionButton(
                onTap: () {},
                svgPath: SvgNameConstants.safetySVG,
                label: 'Chat',
              ),
              TrackActionButton(
                onTap: () {},
                svgPath: SvgNameConstants.phoneSVG,
                label: context.appLocalizations.call,
              )
            ],
          ),
        ],
      ),
    );
  }
}
