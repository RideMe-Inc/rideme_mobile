import 'package:flutter/material.dart';
import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/spacing/whitspacing.dart';
import 'package:rideme_mobile/core/theme/app_colors.dart';

class TrackingHeaderWidget extends StatelessWidget {
  final String header, carType;
  final String? waitTime;
  const TrackingHeaderWidget({
    super.key,
    required this.header,
    required this.carType,
    this.waitTime,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //info\
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  header,
                  style: context.textTheme.displayLarge?.copyWith(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Space.height(context, 0.005),
                Text(
                  carType,
                  style: context.textTheme.displaySmall,
                )
              ],
            ),

            //waiting

            if (waitTime != null)
              Text(
                '${context.appLocalizations.waitTimeEnds} - $waitTime',
                style: context.textTheme.displaySmall,
              )
          ],
        ),
        Space.height(context, 0.01),
        const Divider(
          color: AppColors.rideMeGreyLightActive,
        ),
      ],
    );
  }
}
