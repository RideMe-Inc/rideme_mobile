import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rideme_mobile/assets/svgs/svg_name_constants.dart';
import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/spacing/whitspacing.dart';
import 'package:rideme_mobile/core/theme/app_colors.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/destination_pickup_widget.dart';

class MyLocationSectionWidget extends StatelessWidget {
  final VoidCallback onEditTap, onAddDestinationTap;
  final String pickUp, dropOff;
  const MyLocationSectionWidget({
    super.key,
    required this.onEditTap,
    required this.onAddDestinationTap,
    required this.pickUp,
    required this.dropOff,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.appLocalizations.myLocations,
              style: context.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: onEditTap,
              child: Text(
                'Edit',
                style: context.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: AppColors.rideMeBlueNormal,
                ),
              ),
            )
          ],
        ),

        Space.height(context, 0.014),

        TripPickUpDestinationWidget(
          pickup: pickUp,
          dropoff: dropOff,
        ),

        Space.height(context, 0.016),

        GestureDetector(
          onTap: onAddDestinationTap,
          child: Row(
            children: [
              SvgPicture.asset(SvgNameConstants.addDestinationSVG),
              Space.width(context, 0.032),
              Text(
                context.appLocalizations.addDestination,
                style: context.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w400,
                  color: AppColors.rideMeBlueNormal,
                ),
              )
            ],
          ),
        ),

        Space.height(context, 0.014),

        const Divider(
          color: AppColors.rideMeGreyLightActive,
        ),
      ],
    );
  }
}
