import 'package:dotted_decoration/dotted_decoration.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rideme_mobile/assets/svgs/svg_name_constants.dart';
import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/location/presentation/providers/location_provider.dart';
import 'package:rideme_mobile/core/size/sizes.dart';
import 'package:rideme_mobile/core/spacing/whitspacing.dart';
import 'package:rideme_mobile/core/theme/app_colors.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/drop_off_location_bottom_sheet.dart';

class RequestTripDottedButton extends StatelessWidget {
  const RequestTripDottedButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final locationProvider = context.read<LocationProvider>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Map locations = {
              "pickUp": [
                {
                  "name": locationProvider.geoDataInfo?.address,
                  "id": locationProvider.geoDataInfo?.id,
                  "lat": locationProvider.geoDataInfo?.lat,
                  "lng": locationProvider.geoDataInfo?.lng,
                }
              ],
              "dropOff": [{}],
            };
            buildWhereToBottomSheet(
              context: context,
              locations: locations,
            );
          },
          child: Container(
            height: Sizes.height(context, 0.05),
            width: Sizes.height(context, 0.05),
            decoration: DottedDecoration(
              shape: Shape.circle,
              color: AppColors.rideMeBlueNormal,
            ),
            child: Center(
                child: SvgPicture.asset(
              SvgNameConstants.additionSVG,
              height: Sizes.height(context, 0.03),
            )),
          ),
        ),
        Space.height(context, 0.01),
        Text(
          context.appLocalizations.requestNewTrip,
          style: context.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}
