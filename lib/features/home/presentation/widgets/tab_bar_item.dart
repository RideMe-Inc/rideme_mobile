import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/spacing/whitspacing.dart';

class TabBarItemWidget extends StatelessWidget {
  final VoidCallback onTap;
  final String itemName, itemSVG;
  const TabBarItemWidget({
    super.key,
    required this.onTap,
    required this.itemName,
    required this.itemSVG,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          SvgPicture.asset(itemSVG),
          Space.height(context, 0.005),
          Text(
            itemName,
            style: context.textTheme.displaySmall?.copyWith(
              fontSize: 12,
            ),
          )
        ],
      ),
    );
  }
}
