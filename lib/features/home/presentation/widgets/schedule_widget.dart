import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:rideme_mobile/assets/svgs/svg_name_constants.dart';
import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/size/sizes.dart';
import 'package:rideme_mobile/core/spacing/whitspacing.dart';
import 'package:rideme_mobile/core/theme/app_colors.dart';

class ScheduleCard extends StatelessWidget {
  const ScheduleCard({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Sizes.width(context, 0.018),
      ),
      //  width: Sizes.width(context, 0.160),
      height: Sizes.width(context, 0.065),
      decoration: BoxDecoration(
        color: AppColors.rideMeGreyLight,
        borderRadius: BorderRadius.circular(
          Sizes.height(context, 0.012),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(SvgNameConstants.clockSVG),
          Space.width(context, 0.014),
          Text(
            appLocalizations.now,
            style: context.textTheme.displayMedium
                ?.copyWith(fontWeight: FontWeight.w500),
          ),
          Icon(
            Icons.keyboard_arrow_down,
            size: Sizes.height(context, 0.02),
          ),
        ],
      ),
    );
  }
}
