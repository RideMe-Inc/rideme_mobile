import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rideme_mobile/assets/svgs/svg_name_constants.dart';
import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/location/domain/entity/geo_hash.dart';
import 'package:rideme_mobile/core/location/domain/entity/places_info.dart';
import 'package:rideme_mobile/core/theme/app_colors.dart';

class SearchSuggestionsWidget extends StatelessWidget {
  final SectionType sectionType;
  final PlaceInfo? placeInfo;
  final GeoData? place;
  final bool? isLast;
  final void Function(PlaceInfo?)? placeOnTap;
  final void Function(GeoData?)? topLocationOnTap;

  /// Creates a widget with main location , sub location.
  const SearchSuggestionsWidget({
    super.key,
    this.place,
    this.placeInfo,
    this.placeOnTap,
    required this.sectionType,
    this.topLocationOnTap,
    this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          onTap: () {
            if (topLocationOnTap != null) topLocationOnTap!(place);
            if (placeOnTap != null) placeOnTap!(placeInfo);
          },
          leading: SvgPicture.asset(
            sectionType.svg,
          ),
          title: Text(
            placeInfo?.structuredFormatting.mainText ?? place?.address ?? '',
            style: context.textTheme.displayMedium?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.rideMeBlackNormal,
            ),
          ),
          subtitle: placeInfo?.name == null
              ? null
              : Text(
                  placeInfo!.name,
                  style: context.textTheme.displaySmall?.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.rideMeGreyNormalActive,
                  ),
                ),
        ),
        const Divider(
          color: AppColors.rideMeGreyNormal,
        ),
      ],
    );
  }
}

enum SectionType {
  recent(svg: SvgNameConstants.recentLocationSVG),
  suggestions(svg: SvgNameConstants.locationPinSVG),
  bookmarked(svg: SvgNameConstants.bookMarkedSVG),
  savePlace(svg: SvgNameConstants.savePlaceNav),
  work(svg: SvgNameConstants.workSVG);

  final String svg;

  const SectionType({required this.svg});
}
