import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rideme_mobile/assets/svgs/svg_name_constants.dart';
import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/size/sizes.dart';
import 'package:rideme_mobile/core/spacing/whitspacing.dart';

import 'package:rideme_mobile/core/theme/app_colors.dart';

class TripPickUpDestinationWidget extends StatelessWidget {
  final String pickup, dropoff;
  const TripPickUpDestinationWidget({
    super.key,
    required this.pickup,
    required this.dropoff,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _LocationTile(isStart: true, address: pickup),
        Padding(
          padding: EdgeInsets.only(left: Sizes.height(context, 0.005)),
          child: const DottedLine(
            direction: Axis.vertical,
            dashColor: AppColors.rideMeBlackNormal,
            lineLength: 35,
            lineThickness: 2,
            dashLength: 35,
          ),
        ),
        _LocationTile(isStart: false, address: dropoff)
      ],
    );
  }
}

class _LocationTile extends StatelessWidget {
  final bool isStart;
  final String address;
  const _LocationTile({required this.isStart, required this.address});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(isStart
            ? SvgNameConstants.dropOffPointActiveSVG
            : SvgNameConstants.destinationSVG),
        Space.width(context, 0.032),
        Text(
          address,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: context.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        )
      ],
    );
  }
}
