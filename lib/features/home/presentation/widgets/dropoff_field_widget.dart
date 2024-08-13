import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rideme_mobile/assets/svgs/svg_name_constants.dart';

import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/size/sizes.dart';
import 'package:rideme_mobile/core/spacing/whitspacing.dart';
import 'package:rideme_mobile/core/theme/app_colors.dart';
import 'package:rideme_mobile/features/home/presentation/widgets/schedule_widget.dart';

class SetDropOffField extends StatelessWidget {
  final void Function()? dropOffOnTap;
  final void Function()? schedularOnTap;
  const SetDropOffField({
    super.key,
    required this.dropOffOnTap,
    required this.schedularOnTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: dropOffOnTap,
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: Sizes.width(context, 0.024),
            vertical: Sizes.height(context, 0.011)),
        // height: Sizes.height(context, 0.065),
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.rideMeGreyNormal,
          borderRadius: BorderRadius.circular(
            Sizes.height(context, 0.025),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //drop off section

            Row(
              children: [
                Space.width(context, 0.024),
                SvgPicture.asset(SvgNameConstants.searchSVG),
                Space.width(context, 0.024),
                Text(
                  context.appLocalizations.whereTo,
                  style: context.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),

            //scheduler
            GestureDetector(
              onTap: schedularOnTap,
              child: const ScheduleCard(),
            ),
          ],
        ),
      ),
    );
  }
}
