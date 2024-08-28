import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rideme_mobile/assets/svgs/svg_name_constants.dart';
import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/size/sizes.dart';
import 'package:rideme_mobile/core/theme/app_colors.dart';
import 'package:rideme_mobile/features/trips/presentation/widgets/payment_type_selection.dart';

class PaymentSelectionTile extends StatefulWidget {
  final PaymentTypes paymentTypes;
  final bool isSelected;
  final VoidCallback onTap;
  const PaymentSelectionTile({
    super.key,
    required this.paymentTypes,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<PaymentSelectionTile> createState() => _PaymentSelectionTileState();
}

class _PaymentSelectionTileState extends State<PaymentSelectionTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: widget.onTap,
      leading: Image.asset(
        widget.paymentTypes.imagePath,
        height: Sizes.height(context, 0.028),
      ),
      title: Text(
        widget.paymentTypes.type,
        style: context.textTheme.displayMedium?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Container(
        width: Sizes.width(context, 0.05),
        height: Sizes.height(context, 0.025),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.isSelected
              ? AppColors.rideMeBlueNormal
              : AppColors.rideMeBackgroundLight,
          border: !widget.isSelected
              ? Border.all(color: AppColors.rideMeBlackLightActive)
              : null,
        ),
        child: widget.isSelected
            ? SvgPicture.asset(SvgNameConstants.checkmarkSVG)
            : null,
      ),
    );
  }
}
