import 'package:flutter/material.dart';
import 'package:rideme_mobile/core/size/sizes.dart';
import 'package:rideme_mobile/core/theme/app_colors.dart';

class OnboardingTransition extends StatelessWidget {
  final int index;
  final int currentIndex;
  const OnboardingTransition(
      {super.key, required this.index, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      height: Sizes.height(context, 0.008),
      width: currentIndex == index
          ? Sizes.width(context, 0.08)
          : Sizes.width(context, 0.018),
      margin: EdgeInsets.only(right: Sizes.width(context, 0.02)),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Sizes.height(context, 0.02)),
          color: currentIndex == index
              ? AppColors.rideMeBlackNormal
              : AppColors.rideMeBlackLightActive),
    );
  }
}
