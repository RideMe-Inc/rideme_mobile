import 'package:flutter/material.dart';
import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/size/sizes.dart';
import 'package:rideme_mobile/core/theme/app_colors.dart';

class GetGeoLoadingWidget extends StatelessWidget {
  const GetGeoLoadingWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: context.theme.scaffoldBackgroundColor,
      margin: EdgeInsets.symmetric(
        horizontal: Sizes.width(context, 0.04),
      ),
      height: Sizes.height(context, 0.02),
      width: Sizes.height(context, 0.02),
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColors.rideMeBlueNormal,
        ),
      ),
    );
  }
}
