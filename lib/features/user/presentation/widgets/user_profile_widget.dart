import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rideme_mobile/assets/svgs/svg_name_constants.dart';
import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/size/sizes.dart';
import 'package:rideme_mobile/core/spacing/whitspacing.dart';
import 'package:rideme_mobile/core/theme/app_colors.dart';
import 'package:rideme_mobile/features/user/presentation/widgets/user_initials.dart';

class UserProfileWidget extends StatelessWidget {
  final String? profileUrl;
  final String phoneNumber, name;
  final num? rating;

  const UserProfileWidget({
    super.key,
    required this.name,
    required this.phoneNumber,
    required this.profileUrl,
    this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: Sizes.height(context, 0.028),
              backgroundColor: AppColors.rideMeBlackNormal,
              backgroundImage: profileUrl == null
                  ? null
                  : CachedNetworkImageProvider(profileUrl!),
              child: profileUrl != null ? null : UserInitials(name: name),
            ),
            Space.width(context, 0.04),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // number
                Text(
                  name,
                  style: context.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Space.height(context, 0.004),
                Text(
                  phoneNumber,
                  style: context.textTheme.displaySmall?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.rideMeGreyDarkHover,
                  ),
                ),
              ],
            )
          ],
        ),
        Row(
          children: [
            SvgPicture.asset(
              SvgNameConstants.starSVG,
            ),
            Space.width(context, 0.012),
            Text(
              '${rating ?? 0.0}',
              style: context.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w500,
                color: AppColors.rideMeBlack90,
              ),
            )
          ],
        )
      ],
    );
  }
}
