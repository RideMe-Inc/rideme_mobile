import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/location/presentation/bloc/location_bloc.dart';
import 'package:rideme_mobile/core/size/sizes.dart';
import 'package:rideme_mobile/core/spacing/whitspacing.dart';
import 'package:rideme_mobile/features/trips/presentation/bloc/trips_bloc.dart';
import 'package:rideme_mobile/features/trips/presentation/provider/trip_provider.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/get_geo_loading_widget.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/search_suggestions.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/trip_location_textfield.dart';
import 'package:rideme_mobile/injection_container.dart';

class BookTripPage extends StatefulWidget {
  final Map locations;

  const BookTripPage({
    super.key,
    required this.locations,
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
          context.appLocalizations.enterLocations,
          style: context.textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.add,
              size: Sizes.height(context, 0.035),
            ),
          )
        ],
      ),
      body: BlocListener(
        bloc: locationBloc2,
        listener: (context, state) {
          if (state is GetGeoIDError) {
            print(state.message);
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
            }
            tripProvider.updateIsGeoLoading = false;
          }
        },
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
                      label: null,
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
              TripLocationTextfield(
                hint: 'Enter your destination',
                label: '',
                isRequired: true,
                errorText: null,
                filled: true,
                isPickup: false,
                controller: TextEditingController(),
                onChanged: (p0) {},
                onMapTap: () {},
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
    );
  }
}
