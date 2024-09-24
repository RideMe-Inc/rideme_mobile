import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:rideme_mobile/assets/svgs/svg_name_constants.dart';
import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/location/presentation/bloc/location_bloc.dart';
import 'package:rideme_mobile/core/location/presentation/providers/location_provider.dart';
import 'package:rideme_mobile/core/size/sizes.dart';
import 'package:rideme_mobile/core/spacing/whitspacing.dart';
import 'package:rideme_mobile/core/theme/app_colors.dart';
import 'package:rideme_mobile/features/trips/presentation/provider/trip_provider.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/get_geo_loading_widget.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/search_suggestions.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/trip_location_textfield.dart';
import 'package:rideme_mobile/injection_container.dart';

class SavedPlacesPage extends StatefulWidget {
  const SavedPlacesPage({super.key});

  @override
  State<SavedPlacesPage> createState() => _SavedPlacesPageState();
}

class _SavedPlacesPageState extends State<SavedPlacesPage> {
  final newPlaceController = TextEditingController();
  final locationBloc = sl<LocationBloc>();
  final locationBloc2 = sl<LocationBloc>();
  late TripProvider tripProvider;

  Map? newLocation;

  @override
  Widget build(BuildContext context) {
    tripProvider = context.watch<TripProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.appLocalizations.newPlace,
          style: context.textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
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
                tripProvider.updateIsPickup = true;
              }
              if (state is GetGeoIDLoaded) {
                tripProvider.updateIsGeoLoading = false;

                //replace id

                newLocation = {
                  "name": newLocation?['name'],
                  "id": state.geoDataInfo.id,
                  "lat": state.geoDataInfo.lat,
                  "lng": state.geoDataInfo.lng,
                };
                setState(() {});

                context.pushNamed('addPlace', queryParameters: {
                  "geo_id": newLocation?['id'].toString(),
                  "location_name": newLocation?['name']
                });
              }
            },
          ),
        ],
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: Sizes.height(context, 0.02)),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: TripLocationTextfield(
                      hint: context.appLocalizations.enterNewPlace,
                      label: '',
                      isRequired: true,
                      errorText: null,
                      filled: true,
                      isPickup: false,
                      controller: newPlaceController,
                      onChanged: (p0) {
                        if (p0 == '') newPlaceController.text = p0;

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

                        if (newLocation?['lat'] != null) {
                          lat = newLocation!['lat'].toString();

                          lng = newLocation!['lng'].toString();

                          name = newPlaceController.text;
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
                            newLocation?['id'] = responseInfo['id'];
                            newLocation?['lat'] = responseInfo['lat'];
                            newLocation?['lng'] = responseInfo['lng'];
                            newLocation?['name'] = responseInfo['name'];

                            newPlaceController.text = responseInfo['name'];
                          });

                          if (!context.mounted) return;

                          context.pushNamed('addPlace', queryParameters: {
                            "geo_id": newLocation?['id'].toString(),
                            "location_name": newLocation?['name']
                          });
                        }
                      },
                    ),
                  ),
                  if (tripProvider.isGeoLoading && tripProvider.isPickup)
                    const GetGeoLoadingWidget()
                ],
              ),
              Space.height(context, 0.02),
              ListTile(
                contentPadding: EdgeInsets.zero,
                onTap: () {
                  //TODO: LOOK INTO THIS LATER BECAUSE WHEN ON TRACKING GEO DATA INFO IS NEVER GOTTEN
                  final geoData = context.read<LocationProvider>().geoDataInfo;

                  context.pushNamed('addPlace', queryParameters: {
                    "geo_id": geoData?.id.toString(),
                    "location_name": geoData?.address
                  });
                },
                leading: SvgPicture.asset(SvgNameConstants.currentLocation),
                visualDensity: VisualDensity.compact,
                title: Text(
                  context.appLocalizations.userCurrentLocation,
                  style: context.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.rideMeBlueNormal,
                  ),
                ),
              ),

              //TODO: SAVED PLACES LIST WILL APPEAR WHEN NO SEARCH IS DONE
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
                              final params = {
                                "name": location?.structuredFormatting.mainText,
                                "id": location?.id,
                              };

                              newLocation = params;

                              newPlaceController.text =
                                  location?.structuredFormatting.mainText! ??
                                      '';

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
                                  isPickup: true,
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
