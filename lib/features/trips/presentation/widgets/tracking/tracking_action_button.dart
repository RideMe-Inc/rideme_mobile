import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/size/sizes.dart';
import 'package:rideme_mobile/core/spacing/whitspacing.dart';
import 'package:rideme_mobile/core/theme/app_colors.dart';

class TrackActionButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String svgPath;
  final String label;
  const TrackActionButton({
    super.key,
    required this.onTap,
    required this.svgPath,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.rideMeGreyNormal,
            radius: Sizes.height(context, 0.024),
            child: Center(
              child: SvgPicture.asset(svgPath),
            ),
          ),
          Space.height(context, 0.002),
          Text(
            label,
            style: context.textTheme.displaySmall,
          )
        ],
      ),
    );
  }
}

class RiderInfoTile extends StatelessWidget {
  final String name;
  final String imagePath;
  const RiderInfoTile({super.key, required this.name, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: Sizes.height(context, 0.024),
          backgroundImage: CachedNetworkImageProvider(imagePath),
        ),
        Space.height(context, 0.002),
        Text(
          name,
          style: context.textTheme.displaySmall,
        )
      ],
    );
  }
}
