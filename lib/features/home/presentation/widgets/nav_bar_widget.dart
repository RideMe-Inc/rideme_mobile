import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rideme_mobile/assets/svgs/svg_name_constants.dart';
import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/theme/app_colors.dart';
import 'package:rideme_mobile/features/home/domain/entities/tab_bar_item_entity.dart';
import 'package:rideme_mobile/features/home/presentation/widgets/tab_bar_item.dart';

class NavBarWidget extends StatelessWidget {
  const NavBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    List<TabBarItemEntity> navItems = [
      TabBarItemEntity(
        name: context.appLocalizations.profile,
        svgPath: SvgNameConstants.profileSVG,
        routePath: 'profile',
      ),
      TabBarItemEntity(
        name: context.appLocalizations.payment,
        svgPath: SvgNameConstants.paymentSVG,
        routePath: 'payment',
      ),
      TabBarItemEntity(
        name: context.appLocalizations.history,
        svgPath: SvgNameConstants.historySVG,
        routePath: 'history',
      ),
      TabBarItemEntity(
        name: context.appLocalizations.promotions,
        svgPath: SvgNameConstants.promotionsSVG,
        routePath: 'promotions',
      ),
      TabBarItemEntity(
        name: context.appLocalizations.support,
        svgPath: SvgNameConstants.supportSVG,
        routePath: 'support',
      ),
    ];

    return Container(
      color: AppColors.rideMeBackgroundLight,
      width: double.infinity,
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            navItems.length,
            (index) => TabBarItemWidget(
              onTap: () => context.pushNamed(navItems[index].routePath),
              itemName: navItems[index].name,
              itemSVG: navItems[index].svgPath,
            ),
          ),
        ),
      ),
    );
  }
}
