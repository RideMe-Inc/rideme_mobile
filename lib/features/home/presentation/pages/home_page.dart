import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';

import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:rideme_mobile/assets/svgs/svg_name_constants.dart';
import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/location/domain/entity/geo_hash.dart';
import 'package:rideme_mobile/core/location/domain/entity/places_info.dart';
import 'package:rideme_mobile/core/location/presentation/bloc/location_bloc.dart';
import 'package:rideme_mobile/core/location/presentation/providers/location_provider.dart';
import 'package:rideme_mobile/core/notifications/notif_handler.dart';

import 'package:rideme_mobile/core/size/sizes.dart';
import 'package:rideme_mobile/core/spacing/whitspacing.dart';
import 'package:rideme_mobile/core/theme/app_colors.dart';
import 'package:rideme_mobile/core/widgets/become_a_driver_card.dart';
import 'package:rideme_mobile/features/authentication/presentation/provider/authentication_provider.dart';
import 'package:rideme_mobile/features/home/presentation/bloc/home_bloc.dart';
import 'package:rideme_mobile/features/home/presentation/provider/home_provider.dart';
import 'package:rideme_mobile/features/home/presentation/widgets/book_trip_for_later_bottom_sheet.dart';
import 'package:rideme_mobile/features/home/presentation/widgets/dropoff_field_widget.dart';
import 'package:rideme_mobile/features/home/presentation/widgets/nav_bar_widget.dart';
import 'package:rideme_mobile/features/localization/presentation/providers/locale_provider.dart';
import 'package:rideme_mobile/features/permissions/presentation/bloc/permission_bloc.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/drop_off_location_bottom_sheet.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/search_suggestions.dart';
import 'package:rideme_mobile/features/user/presentation/provider/user_provider.dart';
import 'package:rideme_mobile/injection_container.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late HomeProvider homeProvider;
  late LocationProvider locationProvider;
  late UserProvider userProvider;

  final permissionBloc = sl<PermissionBloc>();
  final locationBloc = sl<LocationBloc>();
  final homeBloc = sl<HomeBloc>();
  List<GeoData> topPlaces = [];

  Set<Marker> markers = {};
  DateTime chosenDate = DateTime.now();
  BitmapDescriptor customIcon = BitmapDescriptor.defaultMarker;

  double? lat;
  double? lng;

  // fetchRiders(Position position) async {
  //   final params = {
  //     "event": "riders-near-me",
  //     "data": {
  //       "lng": position.longitude,
  //       "lat": position.latitude,
  //       "radius": 5,
  //     }
  //   };

  //   homeBloc.add(FetchRidersNearMeEvent(params: params));
  // }

  fetchTopLocations() {
    final params = {
      "locale": context.read<LocaleProvider>().locale,
      "bearer": context.read<AuthenticationProvider>().token,
    };

    homeBloc.add(FetchTopPlacesEvent(params: params));
  }

  late GoogleMapController mapController;

  void onMapCreated(GoogleMapController controller) async {
    mapController = controller;

    if (homeProvider.isLocationAllowed) {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // fetchRiders(position);

      if (!mounted) return;

      final params = {
        "locale": context.appLocalizations.localeName,
        "queryParameters": {
          "lat": position.latitude.toString(),
          "lng": position.longitude.toString(),
        },
      };

      locationBloc.add(GetGeoIDEvent(
        params: params,
        isPickup: true,
        index: null,
      ));
      // getServiceInfo(lat: position.latitude, lng: position.longitude);

      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 14.5),
      ));
    }
  }

  // getServiceInfo({required double lat, required double lng}) {
  //   final params = {
  //     "locale": appLocalizations.localeName,
  //     "bearer": "Bearer ${context.read<HomeProvider>().refreshedToken}",
  //     "queryParams": {
  //       "lat": lat.toString(),
  //       "lng": lng.toString(),
  //     },
  //   };

  //   homeBloc2.add(GetServiceInfoEvent(params: params));
  // }

  @override
  void initState() {
    // user = userBloc.getCachedUserWithoutSafety();
    permissionBloc.add(RequestLocationPemEvent());
    fetchTopLocations();
    PushNotificationHandler(
      context: context,
      localNotificationsPlugin: FlutterLocalNotificationsPlugin(),
      messaging: FirebaseMessaging.instance,
    );
    super.initState();
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    homeProvider = context.watch<HomeProvider>();
    locationProvider = context.watch<LocationProvider>();
    userProvider = context.watch<UserProvider>();

    return Scaffold(
      // drawer: const HomeDrawer(),

      body: MultiBlocListener(
        listeners: [
          //permission
          BlocListener(
            bloc: permissionBloc,
            listener: (context, state) {
              // homeProvider.setNumberOfActiveTrips = user?.ongoingTrips?.length ?? 0;
              if (state is LocationPemDeclined) {
                homeProvider.updateLocationAllowed = false;
              }
            },
          ),

          //location
          BlocListener(
            bloc: locationBloc,
            listener: (context, state) {
              if (state is GetGeoIDLoaded) {
                locationProvider.updateGeoDataInfo = state.geoDataInfo;
              }

              if (state is GetGeoIDError) {
                if (kDebugMode) {
                  print(state.message);
                }
              }
            },
          ),

          BlocListener(
            bloc: homeBloc,
            listener: (context, state) {
              if (state is FetchTopPlacesLoaded) {
                setState(() {
                  topPlaces = state.places;
                });
              }

              if (state is FetchTopPlacesError) {
                if (kDebugMode) print(state.message);
              }
            },
          )
        ],
        child: Stack(
          children: [
            SizedBox(
              height: Sizes.height(context, 0.8),
              child: GoogleMap(
                mapType: MapType.terrain,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                onMapCreated: onMapCreated,
                initialCameraPosition: const CameraPosition(
                  target: LatLng(44.9706674, -93.3438785),
                  zoom: 15,
                ),
                markers: homeProvider.markers,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SvgPicture.asset(SvgNameConstants.googleLogoSVG),
                            GestureDetector(
                              onTap: homeProvider.isLocationAllowed
                                  ? () async {
                                      final position =
                                          await Geolocator.getCurrentPosition(
                                        desiredAccuracy: LocationAccuracy.high,
                                      );

                                      mapController.animateCamera(
                                          CameraUpdate.newLatLng(LatLng(
                                              position.latitude,
                                              position.longitude)));
                                    }
                                  : null,
                              child: CircleAvatar(
                                radius: Sizes.height(context, 0.024),
                                backgroundColor:
                                    AppColors.rideMeBackgroundLight,
                                child: Icon(
                                  Icons.near_me_outlined,
                                  color: AppColors.rideMeBlackNormal,
                                  size: Sizes.height(
                                    context,
                                    0.03,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Space.height(context, 0.01),
                      ],
                    ),
                  ),

                  //container
                  Container(
                    width: Sizes.width(context, 1),
                    // height: Sizes.height(context, 0.42),
                    padding: EdgeInsets.symmetric(
                      horizontal: Sizes.width(context, 0.04),
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.rideMeBackgroundLight,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(Sizes.height(context, 0.03)),
                        topRight: Radius.circular(Sizes.height(context, 0.03)),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
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
                        Text(
                          context.appLocalizations
                              .helloThere(userProvider.user?.firstName ?? ''),
                          style: context.textTheme.displayLarge?.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Space.height(context, 0.016),
                        SetDropOffField(
                          dropOffOnTap: locationProvider.geoDataInfo != null
                              ? () {
                                  // context.pushNamed('bookTrip');
                                  Map locations = {
                                    "pickUp": [
                                      {
                                        "name": locationProvider
                                            .geoDataInfo?.address,
                                        "id": locationProvider.geoDataInfo?.id,
                                        "lat":
                                            locationProvider.geoDataInfo?.lat,
                                        "lng":
                                            locationProvider.geoDataInfo?.lng,
                                      }
                                    ],
                                    "dropOff": [{}],
                                  };

                                  buildWhereToBottomSheet(
                                    context: context,
                                    locations: locations,
                                  );
                                }
                              : null,
                          schedularOnTap: () async {
                            final response =
                                await buildBookTripForLaterBottomSheet(
                              context: context,
                              chosenDate: chosenDate
                                  .add(const Duration(hours: 5, minutes: 5)),
                            );

                            if (!context.mounted) return;

                            if (response != null) {
                              //TODO: ASSIGNN THE RESPONSE TO THE CHOSENDATE VARIABLE ON THIS PAGE
                              // Map locations = {
                              //   "pickUp": [
                              //     homeProvider.isLocationAllowed
                              //         ? {
                              //             "name":
                              //                 homeProvider.geoDataInfo?.address,
                              //             "id": homeProvider.geoDataInfo?.id,
                              //             "lat": homeProvider.geoDataInfo?.lat,
                              //             "lng": homeProvider.geoDataInfo?.lng,
                              //           }
                              //         : {}
                              //   ],
                              //   "dropOff": [{}],
                              // };
                              // final tripData = jsonEncode(locations);
                              // context.pushNamed('tripInfo', queryParameters: {
                              //   "tripData": tripData,
                              //   "scheduledDate": chosenDate.toString(),
                              // });
                            }
                          },
                        ),
                        Space.height(context, 0.028),
                        const BecomeADriverCard(),
                        Space.height(context, 0.03),

                        //!TOP PLACES
                        Skeletonizer(
                          ignoreContainers: true,
                          enabled: topPlaces.isEmpty,
                          child: Padding(
                            padding: EdgeInsets.only(
                                bottom: Sizes.height(context, 0.015)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: List.generate(
                                topPlaces.length > 1 ? 2 : topPlaces.length,
                                (index) {
                                  if (topPlaces.isEmpty) {
                                    return const SearchSuggestionsWidget(
                                      sectionType: SectionType.suggestions,
                                      placeInfo: PlaceInfo(
                                          id: 'id',
                                          name: 'name',
                                          structuredFormatting: DisplayName(
                                              mainText: 'mainText')),
                                    );
                                  }
                                  return SearchSuggestionsWidget(
                                    sectionType: SectionType.suggestions,
                                    place: topPlaces[index],
                                    topLocationOnTap: (p0) {
                                      Map locations = {
                                        "pickUp": [
                                          {
                                            "name": locationProvider
                                                .geoDataInfo?.address,
                                            "id": locationProvider
                                                .geoDataInfo?.id,
                                            "lat": locationProvider
                                                .geoDataInfo?.lat,
                                            "lng": locationProvider
                                                .geoDataInfo?.lng,
                                          }
                                        ],
                                        "dropOff": [
                                          {
                                            "name": p0?.address,
                                            "id": p0?.id,
                                            "lat": p0?.lat,
                                            "lng": p0?.lng,
                                          }
                                        ],
                                      };

                                      buildWhereToBottomSheet(
                                        context: context,
                                        locations: locations,
                                        fromTopPlaces: true,
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
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
      ),
    );
  }
}
