import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rideme_mobile/core/enums/profile_item_type.dart';
import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/size/sizes.dart';
import 'package:rideme_mobile/core/spacing/whitspacing.dart';
import 'package:rideme_mobile/features/trips/domain/entities/create_trip_info.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/pricing_card.dart';
import 'package:rideme_mobile/features/user/presentation/widgets/profile_item_listing_widget.dart';

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  State<SupportPage> createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  final List<ProfileItemType> profileItemType = [
    ProfileItemType.faq,
    ProfileItemType.safety,
  ];

  bool tester = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(
          context.appLocalizations.support,
          style: context.textTheme.headlineSmall,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Sizes.height(context, 0.02),
        ),
        child: Column(
          children: [
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

            //TODO: TO BE CLEARED; TESTING WIDGET BUILD UP
            Space.height(context, 0.05),
            PricingCard(
              isSelected: tester,
              onTap: () => setState(() {
                tester = !tester;
              }),
              pricing: const Pricing(
                  id: 1,
                  charge: 22,
                  isAvailable: true,
                  vehicleType: 'suv',
                  expiration: 'expiration',
                  description: '15 min away',
                  cost: 34,
                  tag: 'economy'),
            )
          ],
        ),
      ),
    );
  }
}
