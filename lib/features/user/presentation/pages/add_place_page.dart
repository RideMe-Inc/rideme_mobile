import 'package:flutter/material.dart';
import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/location/domain/entity/geo_hash.dart';
import 'package:rideme_mobile/core/size/sizes.dart';
import 'package:rideme_mobile/core/spacing/whitspacing.dart';
import 'package:rideme_mobile/core/theme/app_colors.dart';
import 'package:rideme_mobile/core/widgets/buttons/generic_button_widget.dart';
import 'package:rideme_mobile/core/widgets/textfield/generic_textfield_widget.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/search_suggestions.dart';

class AddPlacePage extends StatefulWidget {
  final String geoId, locationName;
  const AddPlacePage({
    super.key,
    required this.geoId,
    required this.locationName,
  });

  @override
  State<AddPlacePage> createState() => _AddPlacePageState();
}

class _AddPlacePageState extends State<AddPlacePage> {
  final placeName = TextEditingController();

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
            GenericButton(
              onTap: () {
                //TODO: SAVE LOCATION EVENT GOES HERE
              },
              label: context.appLocalizations.saveLocation,
              isActive: placeName.text.trim().isNotEmpty,
            )
          ],
        ),
      ),
    );
  }
}
