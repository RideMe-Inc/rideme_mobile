import 'package:flutter/material.dart';
import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/size/sizes.dart';
import 'package:rideme_mobile/core/spacing/whitspacing.dart';
import 'package:rideme_mobile/core/theme/app_colors.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/payment/payment_type_selection.dart';

class PaymentMethodSectionWidget extends StatelessWidget {
  final PaymentTypes paymentTypes;
  final VoidCallback onEditTap;
  final num amount;
  final bool? editable;
  const PaymentMethodSectionWidget({
    super.key,
    required this.paymentTypes,
    required this.amount,
    required this.onEditTap,
    this.editable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.appLocalizations.paymentMethod,
              style: context.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (editable!)
              GestureDetector(
                onTap: onEditTap,
                child: Text(
                  'Edit',
                  style: context.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.rideMeBlueNormal,
                  ),
                ),
              )
          ],
        ),

        Space.height(context, 0.02),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //indicator
            Row(
              children: [
                Image.asset(
                  paymentTypes.imagePath,
                  height: Sizes.height(context, 0.028),
                ),
                Space.width(context, 0.032),
                Text(
                  paymentTypes.type,
                  style: context.textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                )
              ],
            ),

            //amount

            Text(
              context.appLocalizations.amountAndCurrency(amount.toString()),
              style: context.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),

        Space.height(context, 0.014),

        const Divider(
          color: AppColors.rideMeGreyLightActive,
        ),
      ],
    );
  }
}
