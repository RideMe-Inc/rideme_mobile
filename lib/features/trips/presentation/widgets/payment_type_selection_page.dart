import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/size/sizes.dart';
import 'package:rideme_mobile/core/spacing/whitspacing.dart';
import 'package:rideme_mobile/core/theme/app_colors.dart';
import 'package:rideme_mobile/core/widgets/buttons/generic_button_widget.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/payment_selection_tile.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/payment_type_selection.dart';

class PaymentTypeSelectionPage extends StatefulWidget {
  final PaymentTypes? paymentTypes;
  const PaymentTypeSelectionPage({
    super.key,
    required this.paymentTypes,
  });

  @override
  State<PaymentTypeSelectionPage> createState() =>
      _PaymentTypeSelectionPageState();
}

class _PaymentTypeSelectionPageState extends State<PaymentTypeSelectionPage> {
  int? indexSelected;
  @override
  Widget build(BuildContext context) {
    List<PaymentTypes> paymentTypes = [
      PaymentTypes.card,
      PaymentTypes.cash,
    ];
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Sizes.width(context, 0.04),
      ),
      decoration: BoxDecoration(
        color: AppColors.rideMeBackgroundLight,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(Sizes.height(context, 0.02)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Space.height(context, 0.007),
          Center(
            child: Container(
              width: Sizes.width(context, 0.08),
              height: Sizes.height(context, 0.005),
              decoration: BoxDecoration(
                color: AppColors.rideMeGreyNormal,
                borderRadius: BorderRadius.circular(
                  Sizes.height(context, 0.005),
                ),
              ),
            ),
          ),
          Space.height(context, 0.011),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //title
              Text(
                context.appLocalizations.selectPaymentMethod,
                style: context.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),

              Space.height(context, 0.024),

              //payment types

              ...List.generate(
                paymentTypes.length,
                (index) => PaymentSelectionTile(
                  paymentTypes: paymentTypes[index],
                  isSelected: indexSelected == index,
                  onTap: () {
                    indexSelected = index;
                    setState(() {});
                  },
                ),
              ),

              Space.height(context, 0.116),
              GenericButton(
                onTap: () {
                  context.pop(paymentTypes[indexSelected!]);
                },
                label: context.appLocalizations.confirmMethod,
                isActive: indexSelected != null,
              ),
              Space.height(context, 0.03),
            ],
          ),
        ],
      ),
    );
  }
}
