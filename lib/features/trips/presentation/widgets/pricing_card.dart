import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:rideme_mobile/assets/images/image_name_constants.dart';
import 'package:rideme_mobile/assets/svgs/svg_name_constants.dart';
import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/size/sizes.dart';
import 'package:rideme_mobile/core/spacing/whitspacing.dart';
import 'package:rideme_mobile/core/theme/app_colors.dart';
import 'package:rideme_mobile/features/trips/domain/entities/create_trip_info.dart';

class PricingCard extends StatefulWidget {
  final bool isSelected;
  final Pricing pricing;
  final VoidCallback onTap;
  const PricingCard({
    super.key,
    required this.isSelected,
    required this.onTap,
    required this.pricing,
  });

  @override
  State<PricingCard> createState() => _PricingCardState();
}

class _PricingCardState extends State<PricingCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(top: 8),
        width: double.infinity,
        decoration: BoxDecoration(
          border: widget.isSelected
              ? Border.all(color: AppColors.rideMeBlueLightHover)
              : null,
          borderRadius: BorderRadius.circular(
            Sizes.height(context, 0.012),
          ),
          color: widget.isSelected
              ? AppColors.rideMeBlueLight
              : AppColors.rideMeBackgroundLight,
        ),
        child: widget.isSelected
            ? Padding(
                padding: EdgeInsets.only(
                  top: Sizes.height(context, 0.022),
                  bottom: Sizes.height(context, 0.016),
                  left: Sizes.height(context, 0.018),
                  right: Sizes.height(context, 0.009),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //car image
                    Image.asset(
                      CarTypesImages.values
                          .firstWhere(
                            (element) => element.name == widget.pricing.tag,
                            orElse: () => CarTypesImages.economy,
                          )
                          .imagePath,
                      height: Sizes.height(context, 0.06),
                    ),
                    Space.height(context, 0.018),
                    //price information
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //type and timings
                        _TypeAndDescription(
                          tag: widget.pricing.tag ?? '',
                          description: widget.pricing.description ?? '',
                          totalCapactity: 1,
                        ),

                        //price
                        Text(
                          context.appLocalizations.amountAndCurrency(
                            widget.pricing.charge.toString(),
                          ),
                          style: context.textTheme.displayMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            : Padding(
                padding: EdgeInsets.only(top: Sizes.height(context, 0.018)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //car type and type description
                    Row(
                      children: [
                        //car image
                        Image.asset(
                          CarTypesImages.values
                              .firstWhere(
                                (element) => element.name == widget.pricing.tag,
                                orElse: () => CarTypesImages.economy,
                              )
                              .imagePath,
                          height: Sizes.height(context, 0.039),
                        ),

                        Space.width(context, 0.048),

                        //type and timings
                        _TypeAndDescription(
                          tag: widget.pricing.tag ?? '',
                          description: widget.pricing.description ?? '',
                          totalCapactity: 1,
                        ),
                      ],
                    ),

                    //price
                    Text(
                      context.appLocalizations.amountAndCurrency(
                        widget.pricing.charge.toString(),
                      ),
                      style: context.textTheme.displayMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }
}

class _TypeAndDescription extends StatelessWidget {
  final String tag, description;
  final int? totalCapactity;
  const _TypeAndDescription({
    required this.tag,
    required this.description,
    required this.totalCapactity,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //tag
        Text(
          toBeginningOfSentenceCase(tag),
          style: context.textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),

        //description
        Row(
          children: [
            Text(
              description,
              style: context.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w400,
                color: AppColors.rideMeGreyDarkHover,
              ),
            ),

            Space.width(context, 0.008),
            SvgPicture.asset(
              SvgNameConstants.personsSVG,
            ),

            //TODO: PUT SEAT ALLOWED HERE WHEN AVAILABLE
          ],
        )
      ],
    );
  }
}

enum CarTypesImages {
  suv(imagePath: ImageNameConstants.suvIMG),
  hybrid(imagePath: ImageNameConstants.hybridIMG),
  economy(imagePath: ImageNameConstants.economyIMG),
  electric(imagePath: ImageNameConstants.electricIMG),
  premium(imagePath: ImageNameConstants.premiumIMG);

  final String imagePath;

  const CarTypesImages({required this.imagePath});
}
