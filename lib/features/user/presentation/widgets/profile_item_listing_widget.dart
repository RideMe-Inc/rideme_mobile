import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:rideme_mobile/assets/svgs/svg_name_constants.dart';
import 'package:rideme_mobile/core/enums/profile_item_type.dart';
import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/size/sizes.dart';

class ProfileItemListingWidget extends StatelessWidget {
  final String name;
  final Widget? trailing;
  final bool hasSubtitle;
  final bool showTrailing;
  final VoidCallback? onTap;
  final ProfileItemType type;
  final Color? textColor, bgColor, iconColor;

  const ProfileItemListingWidget({
    super.key,
    required this.type,
    required this.name,
    this.onTap,
    this.bgColor,
    this.trailing,
    this.textColor,
    this.iconColor,
    this.showTrailing = true,
    this.hasSubtitle = false,
  });

  @override
  Widget build(BuildContext context) {
    final namings = {
      "faq": 'FAQ',
      "logout": context.appLocalizations.logout,
      "safety": context.appLocalizations.safety,
      "payment": context.appLocalizations.payment,
      "editProfile": context.appLocalizations.userDetails,
      "appLanguage": context.appLocalizations.appLanguage,
      "becomeARider": context.appLocalizations.becomeARider,
      "aboutRideMe": context.appLocalizations.aboutRideMe,
      "deleteAccount": context.appLocalizations.deleteAccount,
      "contactSupport": context.appLocalizations.contactSupport,
      "changePassword": context.appLocalizations.changePassword,
      "accountSettings": context.appLocalizations.accountSettings,
      'notification': context.appLocalizations.notifications,
      "privacyAndData": context.appLocalizations.privacyAndDataPolicy,
    };

    final bool isRefer = name == 'refer';

    return Column(
      children: [
        ListTile(
          onTap: onTap,
          tileColor: bgColor,
          contentPadding: isRefer
              ? EdgeInsets.symmetric(
                  horizontal: Sizes.height(context, 0.02),
                )
              : EdgeInsets.zero,
          leading: SvgPicture.asset(
            type.svg,
          ),
          title: Text(
            namings[name] ?? '',
            style: context.textTheme.displaySmall?.copyWith(
              fontSize: hasSubtitle ? 14 : 13,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
          subtitle: null,
          trailing: trailing ??
              (showTrailing
                  ? SvgPicture.asset(
                      SvgNameConstants.forwardArrowSVG,
                    )
                  : null),
        ),
      ],
    );
  }
}
