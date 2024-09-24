import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rideme_mobile/core/enums/profile_item_type.dart';
import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/size/sizes.dart';
import 'package:rideme_mobile/core/spacing/whitspacing.dart';
import 'package:rideme_mobile/core/theme/app_colors.dart';
import 'package:rideme_mobile/core/widgets/become_a_driver_card.dart';

import 'package:rideme_mobile/features/user/presentation/provider/user_provider.dart';
import 'package:rideme_mobile/features/user/presentation/widgets/confirm_logout.dart';
import 'package:rideme_mobile/features/user/presentation/widgets/profile_item_listing_widget.dart';
import 'package:rideme_mobile/features/user/presentation/widgets/user_profile_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late UserProvider provider;

  final List<ProfileItemType> profileItemType = [
    ProfileItemType.editProfile,
    ProfileItemType.savedPlaces,
    ProfileItemType.appLanguage,
    ProfileItemType.notification,
    ProfileItemType.privacyAndData,
    // ProfileItemType.payment,
    ProfileItemType.aboutRideMe,
  ];
  @override
  Widget build(BuildContext context) {
    provider = context.watch<UserProvider>();
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          context.appLocalizations.profile,
          style: context.textTheme.headlineSmall,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Sizes.height(context, 0.02),
        ),
        child: Column(
          children: [
            Space.height(context, 0.028),
            UserProfileWidget(
              name:
                  '${provider.user?.firstName ?? ''} ${provider.user?.lastName ?? ''}',
              phoneNumber: provider.user?.phone ?? '',
              profileUrl: provider.user?.profileUrl,
              rating: provider.user?.rating,
            ),
            Space.height(context, 0.038),
            ...List.generate(
              profileItemType.length,
              (index) {
                return ProfileItemListingWidget(
                  type: profileItemType[index],
                  name: profileItemType[index].name,
                  showTrailing: true,
                  trailing: null,
                  onTap: () => context.pushNamed(
                    profileItemType[index].name,
                  ),
                );
              },
            ),
            ProfileItemListingWidget(
              type: ProfileItemType.deleteAccount,
              name: ProfileItemType.deleteAccount.name,
              showTrailing: false,
              trailing: null,
              onTap: () => context.pushNamed(
                ProfileItemType.deleteAccount.name,
              ),
            ),
            ProfileItemListingWidget(
              type: ProfileItemType.logout,
              name: ProfileItemType.logout.name,
              showTrailing: false,
              trailing: null,
              textColor: AppColors.rideMeErrorNormal,
              onTap: () => showAdaptiveDialog(
                context: context,
                builder: (context) => const ConfirmLogoutDialog(),
              ),
            ),
            const Expanded(
                child: Align(
              alignment: Alignment.bottomCenter,
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    BecomeADriverCard(),
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
