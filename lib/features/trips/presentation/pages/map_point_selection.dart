import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';

import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rideme_mobile/assets/images/image_name_constants.dart';
import 'package:rideme_mobile/assets/svgs/svg_name_constants.dart';
import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/location/domain/entity/geo_hash.dart';
import 'package:rideme_mobile/core/location/presentation/bloc/location_bloc.dart';
import 'package:rideme_mobile/core/location/presentation/providers/location_provider.dart';
import 'package:rideme_mobile/core/size/sizes.dart';
import 'package:rideme_mobile/core/spacing/whitspacing.dart';
import 'package:rideme_mobile/core/theme/app_colors.dart';
import 'package:rideme_mobile/core/widgets/buttons/generic_button_widget.dart';
import 'package:rideme_mobile/core/widgets/loaders/loading_indicator.dart';
import 'package:rideme_mobile/core/widgets/popups/error_popup.dart';
import 'package:rideme_mobile/injection_container.dart';

class LocationSelectionOnMap extends StatefulWidget {
  final String lat;
  final String lng;
  final String name;

  const LocationSelectionOnMap({
    super.key,
    required this.lat,
    required this.lng,
    required this.name,
  });

  @override
  State<LocationSelectionOnMap> createState() => _LocationSelectionOnMapState();
}

class _LocationSelectionOnMapState extends State<LocationSelectionOnMap> {
  late bool isCurrentLocationSelector;

  late LocationProvider locationProvider;

  final locationBloc = sl<LocationBloc>();

  int? id;
  double? lat;
  double? lng;
  String? name;
  GeoData? geoData;
  bool isLoading = false;

  //GET GEO DATA EVENT

  getGeoDataEvent(String lat, String lng) {
    locationBloc.add(
      GetGeoIDEvent(
        params: {
          "locale": context.appLocalizations.localeName,
          "queryParameters": {
            "lat": lat.toString(),
            "lng": lng.toString(),
          }
        },
        isPickup: true,
        index: null,
      ),
    );
  }

  late GoogleMapController mapController;

  void onMapCreated(GoogleMapController controller) async {
    mapController = controller;
  }

  Future<Position> getCurrentPosition() async =>
      await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

  @override
  void initState() {
    lat = double.parse(widget.lat);
    lng = double.parse(widget.lng);
    context.read<LocationProvider>().loadCustomIcon();

    super.initState();
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    locationProvider = context.watch<LocationProvider>();

    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: Sizes.height(context, 0.8),
            child: GoogleMap(
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              onMapCreated: onMapCreated,
              onCameraIdle: () {
                getGeoDataEvent(lat.toString(), lng.toString());
              },
              onTap: (argument) {
                setState(() {
                  lat = argument.latitude;
                  lng = argument.longitude;
                });

                getGeoDataEvent(lat.toString(), lng.toString());
              },
              onCameraMove: (position) {
                setState(() {
                  lat = position.target.latitude;
                  lng = position.target.longitude;
                });
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(lat ?? 5.6623, lng ?? -0.2013),
                zoom: 14,
              ),
              markers: {
                Marker(
                  markerId: const MarkerId(''),
                  icon: locationProvider.customIcon,
                  position: LatLng(lat ?? 5.6623, lng ?? -0.2013),
                  anchor: const Offset(0.2, 1),
                )
              },
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
                    margin: EdgeInsets.only(
                      left: Sizes.height(context, 0.02),
                    ),
                    padding: EdgeInsets.symmetric(
                      vertical: Sizes.height(context, 0.009),
                      horizontal: Sizes.width(context, 0.02),
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.rideMeBackgroundLight,
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                          spreadRadius: 0,
                          offset: const Offset(0, 4),
                          color: AppColors.rideMeGreyDarker.withOpacity(0.1),
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: AppColors.rideMeBlackNormal,
                      size: Sizes.height(context, 0.025),
                    ),
                  ),
                );
              }),
            ),
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: Sizes.width(context, 0.04),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SvgPicture.asset(SvgNameConstants.googleLogoSVG),

                      //near me action button
                      GestureDetector(
                        onTap: () async {
                          final position = await getCurrentPosition();

                          mapController.animateCamera(
                            CameraUpdate.newLatLng(
                              LatLng(position.latitude, position.longitude),
                            ),
                          );

                          getGeoDataEvent(
                            position.latitude.toString(),
                            position.longitude.toString(),
                          );
                        },
                        child: CircleAvatar(
                          radius: Sizes.height(context, 0.024),
                          backgroundColor: AppColors.rideMeBackgroundLight,
                          child: SvgPicture.asset(
                            SvgNameConstants.myLocationSVG,
                            height: Sizes.height(context, 0.025),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Space.height(context, 0.01),
                Container(
                  width: Sizes.width(context, 1),
                  height: Sizes.height(context, 0.26),
                  decoration: BoxDecoration(
                    color: context.theme.scaffoldBackgroundColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(Sizes.height(context, 0.03)),
                      topRight: Radius.circular(Sizes.height(context, 0.03)),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //label
                      Padding(
                        padding: EdgeInsets.only(
                          left: Sizes.width(context, 0.04),
                          top: Sizes.height(context, 0.014),
                        ),
                        child: Text(
                          context.appLocalizations.setYourLocation,
                          style: context.textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Space.height(context, 0.018),
                      //location
                      BlocConsumer(
                        bloc: locationBloc,
                        listener: (context, state) {
                          if (state is GetGeoIDError) {
                            setState(() => isLoading = false);
                            showErrorPopUp(state.message, context);
                          }

                          if (state is GetGeoIDLoaded) {
                            setState(() {
                              isLoading = false;
                              id = state.geoDataInfo.id as int;
                              name = state.geoDataInfo.address;
                              geoData = state.geoDataInfo;
                            });
                          }
                          if (state is GetGeoIDLoading) {
                            setState(() => isLoading = true);
                          }
                        },
                        builder: (context, state) {
                          if (state is GetGeoIDLoading) {
                            return LoadingIndicator(
                              height: Sizes.height(context, 0.07),
                            );
                          }

                          if (state is GetGeoIDLoaded) {
                            final address = state.geoDataInfo.address;

                            return _LocationName(
                              theme: context.theme,
                              address: address,
                            );
                          }

                          return _LocationName(
                            theme: context.theme,
                            address: widget.name,
                          );
                        },
                      ),

                      Space.height(context, 0.03),

                      //confirm button

                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: Sizes.width(context, 0.04),
                        ),
                        child: GenericButton(
                          onTap: id != null
                              ? () {
                                  Map<String, dynamic> popData = {
                                    "id": id,
                                    "name": name,
                                    "lat": lat,
                                    "lng": lng,
                                  };

                                  context.pop(popData);
                                }
                              : null,
                          isActive: !isLoading,
                          label: context.appLocalizations.confirmDestination,
                        ),
                      ),
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

class _LocationName extends StatelessWidget {
  const _LocationName({
    required this.theme,
    required this.address,
  });

  final ThemeData theme;
  final String? address;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: Sizes.height(context, 0.070),
      padding: EdgeInsets.all(Sizes.height(context, 0.02)),
      color: AppColors.rideMeGreyNormal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            ImageNameConstants.locationPinIMG,
            width: Sizes.width(context, 0.1),
            height: Sizes.height(context, 0.1),
          ),
          Space.width(context, 0.032),
          Text(
            (address?.length ?? 0) > 33
                ? '${address?.characters.take(33)}...'
                : address ?? '',
            style: context.textTheme.displayMedium!.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
