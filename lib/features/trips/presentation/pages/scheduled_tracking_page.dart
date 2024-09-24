import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/size/sizes.dart';
import 'package:rideme_mobile/core/spacing/whitspacing.dart';
import 'package:rideme_mobile/core/theme/app_colors.dart';
import 'package:rideme_mobile/core/widgets/buttons/dotted_button.dart';
import 'package:rideme_mobile/core/widgets/buttons/generic_button_widget.dart';
import 'package:rideme_mobile/core/widgets/loaders/loading_indicator.dart';
import 'package:rideme_mobile/core/widgets/popups/error_popup.dart';
import 'package:rideme_mobile/features/authentication/presentation/provider/authentication_provider.dart';
import 'package:rideme_mobile/features/home/presentation/widgets/nav_bar_widget.dart';
import 'package:rideme_mobile/features/localization/presentation/providers/locale_provider.dart';
import 'package:rideme_mobile/features/trips/presentation/bloc/trips_bloc.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/cancel_trip_selection_bs.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/my_location_section_widget.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/payment/payment_type_selection.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/payment_method_section_widget.dart';
import 'package:rideme_mobile/injection_container.dart';

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
  final tripBloc = sl<TripsBloc>();

  late GoogleMapController mapController;

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

  @override
  void initState() {
    fetchTripDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener(
        bloc: tripBloc,
        listener: (context, state) {
          if (state is GenericTripsError) {
            showErrorPopUp(state.errorMessage, context);
          }
        },
        child: Stack(
          children: [
            SizedBox(
              height: Sizes.height(context, 0.8),
              child: GoogleMap(
                myLocationEnabled: false,
                myLocationButtonEnabled: false,
                polylines: const {},
                onMapCreated: onMapCreated,
                onCameraMove: (position) {
                  mapController.moveCamera(CameraUpdate.zoomTo(13));
                },
                initialCameraPosition: const CameraPosition(
                  target: LatLng(44.9706674, -93.3438785),
                  zoom: 16,
                ),
              ),
            ),

            //MORE SECTION
            SafeArea(
              child: Align(
                alignment: Alignment.topLeft,
                child: Builder(builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      // Scaffold.of(context).openDrawer();
                      showAdaptiveDialog(
                        useSafeArea: false,
                        barrierDismissible: true,
                        context: context,
                        builder: (context) {
                          return Column(
                            children: [
                              const NavBarWidget(),
                              Space.height(context, 0.01),
                            ],
                          );
                        },
                      );
                    },
                    child: Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        Container(
                          height: Sizes.height(context, 0.05),
                          width: Sizes.width(context, 0.2),
                          decoration: const BoxDecoration(
                            color: AppColors.rideMeWhite500,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 5,
                                spreadRadius: 1,
                                color: AppColors.rideMeGreyNormalActive,
                                offset: Offset(0, 3.5),
                              )
                            ],
                          ),
                          child: Icon(
                            Icons.menu,
                            color: AppColors.rideMeBlackNormal,
                            size: Sizes.height(context, 0.025),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
              ),
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

                        BlocBuilder(
                          bloc: tripBloc,
                          builder: (context, state) {
                            if (state is GetTripLoading) {
                              return const LoadingIndicator();
                            }

                            if (state is GetTripLoaded) {
                              final tripDetailsInfo =
                                  state.tripDetailsInfo.tripDestinationData!;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Text(
                                      tripBloc.scheduleInfoString(
                                          tripDetailsInfo.scheduleTime!,
                                          context),
                                      style: context.textTheme.displayLarge
                                          ?.copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Space.height(context, 0.012),
                                  Center(
                                    child: Text(
                                      context.appLocalizations.carSearchInfo,
                                      style: context.textTheme.displaySmall
                                          ?.copyWith(
                                        color: AppColors.rideMeGreyDarker,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Space.height(context, 0.02),
                                  const Center(
                                    child: RequestTripDottedButton(),
                                  ),
                                  Space.height(context, 0.022),
                                  MyLocationSectionWidget(
                                      editable: false,
                                      onEditTap: () {},
                                      onAddDestinationTap: () {},
                                      pickUp:
                                          tripDetailsInfo.pickupAddress ?? '',
                                      dropOff: tripDetailsInfo
                                              .destinations?.last.address ??
                                          ''),
                                  Space.height(context, 0.03),
                                  PaymentMethodSectionWidget(
                                    editable: false,
                                    paymentTypes:
                                        PaymentTypes.values.firstWhere(
                                      (element) =>
                                          element.name ==
                                          (tripDetailsInfo.paymentMethod ??
                                              'cash'),
                                    ),
                                    amount: tripDetailsInfo.amountCharged ?? 0,
                                    onEditTap: () {},
                                  ),
                                  Space.height(context, 0.042),
                                  GenericButton(
                                    onTap: () => buildCancelTripReasonsBS(
                                      context: context,
                                      tripId:
                                          tripDetailsInfo.id?.toString() ?? '',
                                    ),
                                    label: context.appLocalizations.cancelTrip,
                                    isActive: true,
                                    buttonColor: AppColors.rideMeErrorNormal,
                                  ),
                                ],
                              );
                            }
                            return Container();
                          },
                        ),

                        Space.height(context, 0.02),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
