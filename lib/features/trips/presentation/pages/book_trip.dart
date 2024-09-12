import 'dart:convert';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/location/presentation/bloc/location_bloc.dart';
import 'package:rideme_mobile/core/size/sizes.dart';
import 'package:rideme_mobile/core/spacing/whitspacing.dart';
import 'package:rideme_mobile/core/theme/app_colors.dart';
import 'package:rideme_mobile/core/widgets/buttons/generic_button_widget.dart';
import 'package:rideme_mobile/core/widgets/loaders/loading_indicator.dart';
import 'package:rideme_mobile/core/widgets/popups/error_popup.dart';
import 'package:rideme_mobile/features/authentication/presentation/provider/authentication_provider.dart';
import 'package:rideme_mobile/features/localization/presentation/providers/locale_provider.dart';
import 'package:rideme_mobile/features/trips/presentation/bloc/trips_bloc.dart';
import 'package:rideme_mobile/features/trips/presentation/provider/trip_provider.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/get_geo_loading_widget.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/search_suggestions.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/trip_location_textfield.dart';
import 'package:rideme_mobile/injection_container.dart';

class BookTripPage extends StatefulWidget {
  final Map locations;
  final bool? fromTopPlaces;
  final bool? fromScheduled;
  final String? scheduledDate;

  const BookTripPage({
    super.key,
    required this.locations,
    this.fromTopPlaces = false,
    this.fromScheduled = false,
    this.scheduledDate,
  });

  @override
  State<BookTripPage> createState() => _BookTripPageState();
}

class _BookTripPageState extends State<BookTripPage> {
  final tripsBloc = sl<TripsBloc>();
  final locationBloc = sl<LocationBloc>();
  final locationBloc2 = sl<LocationBloc>();
  late TripProvider tripProvider;
  Map locations = {
    "pickUp": [{}],
    "dropOff": [{}],
  };
  final TextEditingController pickupLocationController =
      TextEditingController();
  final dropOffLocationControllers = [
    TextEditingController(),
  ];

  String? initialValue;

  //set controller if data exist

  initPickUpControllerIfValueExist() {
    if (widget.locations['pickUp'][0]['name'] == null) {
      return;
    }

    pickupLocationController.text = widget.locations['pickUp'][0]['name'];

    if (widget.locations['dropOff'][0]['name'] != null) {
      dropOffLocationControllers[0].text =
          widget.locations['dropOff'][0]['name'];
    }
  }

  bool allLocationsLoaded() {
    //check in locations['dropOff'] list for index of an empty map
    //it returns -1 if element is not found
    final dropOff = locations['dropOff'].indexWhere(
      (Map<dynamic, dynamic> e) => e.isEmpty,
    );

    //check in locations['pickup'] list for index of an empty map
    //it returns -1 if element is not found
    final pickup = locations['pickUp'].indexWhere(
      (Map<dynamic, dynamic> e) => e.isEmpty,
    );

    return pickup == -1 && dropOff == -1;
  }

  fetchPricing() {
    final params = {
      "locale": context.read<LocaleProvider>().locale,
      "bearer": context.read<AuthenticationProvider>().token,
      "body": {
        "pickup_geo_data_id": locations['pickUp'][0]['id'],
        "stops": tripsBloc.getGeoDataIds(locations['dropOff']),
        if (widget.fromScheduled ?? false)
          "schedule_time": widget.scheduledDate,
      }
    };

    tripsBloc.add(FetchPricingEvent(params: params));
  }

  @override
  void initState() {
    initPickUpControllerIfValueExist();
    locations = widget.locations;
    initialValue = pickupLocationController.text;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    tripProvider = context.watch<TripProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.fromScheduled ?? false
              ? context.appLocalizations.bookForLater
              : context.appLocalizations.enterLocations,
          style: context.textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              dropOffLocationControllers.add(TextEditingController());
              locations['dropOff'].add({});
              setState(() {});
            },
            icon: Icon(
              Icons.add,
              size: Sizes.height(context, 0.035),
            ),
          )
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener(
            bloc: locationBloc2,
            listener: (context, state) {
              if (state is GetGeoIDError) {
                if (kDebugMode) print(state.message);
              }
              if (state is GetGeoIDLoading) {
                tripProvider.updateIsGeoLoading = true;
                if (state.isPickup!) {
                  tripProvider.updateIsPickup = true;
                } else {
                  tripProvider.updateIsPickup = false;
                  tripProvider.updateIndex = state.index ?? 0;
                }
              }
              if (state is GetGeoIDLoaded) {
                if (kDebugMode) print(locations);
                //replace id

                if (state.isPickUp) {
                  final index = locations['pickUp'].indexWhere(
                    (e) => e['id'] == state.placedID,
                  );
                  if (index != -1) {
                    locations['pickUp'][index] = {
                      "name": locations['pickUp'][index]['name'],
                      "id": state.geoDataInfo.id,
                      "lat": state.geoDataInfo.lat,
                      "lng": state.geoDataInfo.lng,
                    };
                    setState(() {});
                  }
                } else {
                  final index = locations['dropOff'].indexWhere(
                    (e) => e['id'] == state.placedID,
                  );

                  if (index != -1) {
                    locations['dropOff'][index] = {
                      "name": locations['dropOff'][index]['name'],
                      "id": state.geoDataInfo.id,
                      "lat": state.geoDataInfo.lat,
                      "lng": state.geoDataInfo.lng,
                    };

                    setState(() {});
                  }

                  if (allLocationsLoaded() && tripProvider.isGeoLoading) {
                    fetchPricing();
                  }
                }
                tripProvider.updateIsGeoLoading = false;
              }
            },
          ),
          BlocListener(
            bloc: tripsBloc,
            listener: (context, state) {
              if (kDebugMode) print(state);
              if (state is FetchPricingLoaded) {
                final params = state.createTripInfo.toMap();

                final jsonString = jsonEncode(params);

                // context.pop();
                context.pushNamed('priceSelection', queryParameters: {
                  "pricing": jsonString,
                  "isScheduled":
                      widget.fromScheduled ?? false ? 'true' : 'false',
                });
              }

              if (state is FetchPricingError) {
                if (kDebugMode) print(state.message);
                showErrorPopUp('Oopps. Kindly try again', context);
              }
            },
          ),
        ],
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Sizes.height(context, 0.02),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: TripLocationTextfield(
                      hint: 'Enter pickup location',
                      label: '',
                      isRequired: true,
                      errorText: null,
                      isPickup: true,
                      controller: pickupLocationController,
                      onChanged: (p0) {
                        if (initialValue! != '' &&
                            pickupLocationController.text ==
                                initialValue?.substring(
                                    0, initialValue!.length - 1)) {
                          setState(() {
                            pickupLocationController.clear();
                            locations['pickUp'][0] = {};
                          });
                          return;
                        }

                        if (p0 == '') pickupLocationController.text = p0;

                        final params = {
                          "isPickUP": true,
                          "body": {
                            "searchText": p0,
                          }
                        };

                        locationBloc.add(
                          SearchPlacesEvent(
                            params: params,
                          ),
                        );
                        setState(() {});
                      },
                      onMapTap: () async {
                        String lat = '';
                        String lng = '';
                        String name = '';

                        if (locations['pickUp'][0]['lat'] != null) {
                          lat = locations['pickUp'][0]['lat'].toString();

                          lng = locations['pickUp'][0]['lng'].toString();

                          name = pickupLocationController.text;
                        } else {
                          Position position =
                              await Geolocator.getCurrentPosition(
                                  desiredAccuracy: LocationAccuracy.high);

                          lat = position.latitude.toString();
                          lng = position.longitude.toString();
                          name = "-----------------------";
                        }

                        if (!context.mounted) return;

                        final response = await context.pushNamed(
                            'mapLocationSelection',
                            queryParameters: {
                              "isPickup": 'true',
                              "lat": lat,
                              "lng": lng,
                              "name": name,
                            });

                        if (response != null) {
                          final responseInfo = response as Map;
                          setState(() {
                            locations['pickUp'][0]['id'] = responseInfo['id'];
                            locations['pickUp'][0]['lat'] = responseInfo['lat'];
                            locations['pickUp'][0]['lng'] = responseInfo['lng'];
                            locations['pickUp'][0]['name'] =
                                responseInfo['name'];

                            pickupLocationController.text =
                                responseInfo['name'];
                          });
                        }
                      },
                    ),
                  ),
                  if (tripProvider.isGeoLoading && tripProvider.isPickup)
                    const GetGeoLoadingWidget()
                ],
              ),

              //drop off locations
              ReorderableListView.builder(
                shrinkWrap: true,
                itemCount: dropOffLocationControllers.length,
                proxyDecorator: (child, index, animation) => AnimatedBuilder(
                  animation: animation,
                  builder: (BuildContext context, Widget? child) {
                    final double animValue =
                        Curves.easeInOut.transform(animation.value);
                    final double elevation = lerpDouble(0, 6, animValue)!;
                    return Material(
                      elevation: elevation,
                      color: context.theme.scaffoldBackgroundColor,
                      shadowColor: AppColors.rideMeBlackLight,
                      child: child,
                    );
                  },
                  child: child,
                ),
                itemBuilder: (context, index) {
                  return Row(
                    key: Key(index.toString()),
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (dropOffLocationControllers.length > 1)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: Sizes.width(context, 0.01),
                          ),
                          child: Icon(
                            Icons.drag_indicator_rounded,
                            color: AppColors.rideMeBlackDarker,
                            size: Sizes.height(context, 0.024),
                          ),
                        ),
                      Expanded(
                        child: TripLocationTextfield(
                          hint: 'Enter your destination',
                          label: null,
                          isRequired: true,
                          errorText: null,
                          filled: true,
                          isPickup: false,
                          controller: dropOffLocationControllers[index],
                          onChanged: (p0) {
                            if (p0 == '') {
                              dropOffLocationControllers[index].text = p0;
                            }
                            final params = {
                              "isPickUP": false,
                              "dropOffIndex": index,
                              "body": {
                                "searchText": p0,
                              }
                            };

                            locationBloc.add(
                              SearchPlacesEvent(
                                params: params,
                              ),
                            );
                            setState(() {});
                          },
                          hasSuffix: true,
                          onMapTap: () async {
                            String lat = '';
                            String lng = '';
                            String name = '';

                            if (locations['dropOff'][index]['lat'] != null) {
                              lat =
                                  locations['dropOff'][index]['lat'].toString();

                              lng =
                                  locations['dropOff'][index]['lng'].toString();

                              name = dropOffLocationControllers[index].text;
                            } else {
                              Position position =
                                  await Geolocator.getCurrentPosition(
                                      desiredAccuracy: LocationAccuracy.high);

                              lat = position.latitude.toString();
                              lng = position.longitude.toString();
                              name = "-----------------------";
                            }

                            if (!context.mounted) return;

                            final response = await context.pushNamed(
                                'mapLocationSelection',
                                queryParameters: {
                                  "isPickup": 'false',
                                  "lat": lat,
                                  "lng": lng,
                                  "name": name,
                                });

                            if (response != null) {
                              final responseInfo = response as Map;
                              setState(() {
                                locations['dropOff'][index]['id'] =
                                    responseInfo['id'];
                                locations['dropOff'][index]['lat'] =
                                    responseInfo['lat'];
                                locations['dropOff'][index]['lng'] =
                                    responseInfo['lng'];
                                locations['dropOff'][index]['name'] =
                                    responseInfo['name'];

                                dropOffLocationControllers[index].text =
                                    responseInfo['name'];
                              });

                              fetchPricing();
                            }
                          },
                        ),
                      ),
                      if (tripProvider.isGeoLoading &&
                          !tripProvider.isPickup &&
                          tripProvider.index == index)
                        const GetGeoLoadingWidget(),
                      if (dropOffLocationControllers.length > 1)
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: Sizes.width(context, 0.01),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              dropOffLocationControllers.removeAt(index);
                              locations['dropOff'].removeAt(index);
                              setState(() {});
                            },
                            child: Icon(
                              Icons.close,
                              color: AppColors.rideMeBlackDarker,
                              size: Sizes.height(context, 0.024),
                            ),
                          ),
                        ),
                    ],
                  );
                },
                onReorder: (oldIndex, newIndex) {
                  if (oldIndex < newIndex) {
                    newIndex -= 1;
                  }

                  final dropOff = locations['dropOff'].removeAt(oldIndex);

                  final dropOffLocationController =
                      dropOffLocationControllers.removeAt(oldIndex);

                  locations['dropOff'].insert(newIndex, dropOff);
                  dropOffLocationControllers.insert(
                    newIndex,
                    dropOffLocationController,
                  );

                  setState(() {});
                },
              ),

              Space.height(context, 0.028),
              BlocBuilder(
                bloc: locationBloc,
                builder: (context, state) {
                  if (state is SearchPlacesLoaded) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: state.places.places?.length,
                        itemBuilder: (context, index) {
                          return SearchSuggestionsWidget(
                            sectionType: SectionType.suggestions,
                            placeInfo: state.places.places![index],
                            placeOnTap: (location) {
                              if (state.isPickUP!) {
                                final pickuplist = locations['pickUp'] as List;

                                final params = {
                                  "name":
                                      location?.structuredFormatting.mainText,
                                  "id": location?.id,
                                };

                                //add params to list
                                pickuplist[0] = params;

                                locations['pickUp'] = pickuplist;

                                pickupLocationController.text =
                                    location?.structuredFormatting.mainText! ??
                                        '';
                              } else {
                                final dropOffList =
                                    locations['dropOff'] as List;

                                final params = {
                                  "name":
                                      location?.structuredFormatting.mainText,
                                  "id": location?.id,
                                };

                                dropOffList[state.dropOffIndex!] = params;

                                locations['dropOff'] = dropOffList;

                                dropOffLocationControllers[state.dropOffIndex!]
                                        .text =
                                    location?.structuredFormatting.mainText! ??
                                        '';

                                //add params to list
                                // dropOffList.insert(
                                //   state.dropOffIndex!,
                                //   params,
                                // );
                              }

                              setState(() {});

                              locationBloc.add(ClearSearchResultsEvent());

                              locationBloc2.add(
                                GetGeoIDEvent(
                                  params: {
                                    "locale":
                                        context.appLocalizations.localeName,
                                    "queryParameters": {
                                      "google_place_id": location?.id,
                                    }
                                  },
                                  isPickup: state.isPickUP ?? false,
                                  index: state.dropOffIndex,
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  }

                  return const SizedBox();
                },
              ),
            ],
          ),
        ),
      ),
      bottomSheet: widget.fromTopPlaces ?? false
          ? Container(
              color: AppColors.rideMeBackgroundLight,
              padding: EdgeInsets.all(Sizes.height(context, 0.02)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  BlocBuilder(
                    bloc: tripsBloc,
                    builder: (context, state) {
                      if (state is FetchPricingLoading) {
                        return const LoadingIndicator();
                      }
                      return GenericButton(
                        onTap: fetchPricing,
                        label: context.appLocalizations.confirm,
                        isActive: true,
                      );
                    },
                  )
                ],
              ),
            )
          : null,
    );
  }
}
