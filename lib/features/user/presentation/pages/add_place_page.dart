import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/location/domain/entity/geo_hash.dart';
import 'package:rideme_mobile/core/location/presentation/bloc/location_bloc.dart';
import 'package:rideme_mobile/core/size/sizes.dart';
import 'package:rideme_mobile/core/spacing/whitspacing.dart';
import 'package:rideme_mobile/core/theme/app_colors.dart';
import 'package:rideme_mobile/core/widgets/buttons/generic_button_widget.dart';
import 'package:rideme_mobile/core/widgets/loaders/loading_indicator.dart';
import 'package:rideme_mobile/core/widgets/popups/error_popup.dart';
import 'package:rideme_mobile/core/widgets/textfield/generic_textfield_widget.dart';
import 'package:rideme_mobile/features/authentication/presentation/provider/authentication_provider.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/search_suggestions.dart';
import 'package:rideme_mobile/injection_container.dart';

class AddPlacePage extends StatefulWidget {
  final String geoId, locationName;
  final String? placeName, placeId;

  const AddPlacePage({
    super.key,
    required this.geoId,
    required this.locationName,
    this.placeName,
    this.placeId,
  });

  @override
  State<AddPlacePage> createState() => _AddPlacePageState();
}

class _AddPlacePageState extends State<AddPlacePage> {
  final placeName = TextEditingController();
  final locationBloc = sl<LocationBloc>();

  saveOrEditPlace() {
    final params = {
      "locale": context.appLocalizations.localeName,
      "bearer": context.read<AuthenticationProvider>().token,
      "body": {
        "description": placeName.text,
        "geo_data_id": widget.geoId,
      },
      if (widget.placeId != null)
        "urlParameters": {
          "id": widget.placeId!,
        }
    };

    locationBloc.add(widget.placeName != null
        ? EditSavedAddressEvent(params: params)
        : SaveAddressEvent(params: params));
  }

  @override
  void initState() {
    placeName.text = widget.placeName ?? '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.appLocalizations.savePlace,
          style: context.textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Sizes.height(context, 0.02)),
          child: Column(
            children: [
              GenericTextField(
                label: context.appLocalizations.locationName,
                hint: context.appLocalizations.givePlaceName,
                controller: placeName,
                onChanged: (p0) {
                  setState(() {});
                },
              ),
              Space.height(context, 0.02),
              SearchSuggestionsWidget(
                sectionType: SectionType.savePlace,
                place: GeoData(
                  id: null,
                  lat: null,
                  lng: null,
                  address: widget.locationName,
                  geoHash: null,
                ),
              )
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.all(Sizes.height(context, 0.02)),
        color: AppColors.rideMeBackgroundLight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocConsumer(
              bloc: locationBloc,
              listener: (context, state) {
                if (state is SavedAddressLoaded ||
                    state is EditSavedAddressLoaded) {
                  context.pop();
                }

                if (state is EditSavedAddressError) {
                  showErrorPopUp(state.message, context);
                }
                if (state is SavedAddressError) {
                  showErrorPopUp(state.message, context);
                }
              },
              builder: (context, state) {
                if (state is EditSavedAddressLoading ||
                    state is SavedAddressLoading) {
                  return const LoadingIndicator();
                }
                return GenericButton(
                  onTap: saveOrEditPlace,
                  label: context.appLocalizations.saveLocation,
                  isActive: placeName.text.trim().isNotEmpty,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
