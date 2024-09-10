import 'package:flutter/cupertino.dart';

import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rideme_mobile/assets/svgs/svg_name_constants.dart';
import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/size/sizes.dart';
import 'package:rideme_mobile/core/spacing/whitspacing.dart';
import 'package:rideme_mobile/core/theme/app_colors.dart';
import 'package:rideme_mobile/core/widgets/buttons/generic_button_widget.dart';

class BookTripForLater extends StatefulWidget {
  final DateTime chosenDate;

  const BookTripForLater({
    super.key,
    required this.chosenDate,
  });

  @override
  State<BookTripForLater> createState() => _BookTripForLaterState();
}

class _BookTripForLaterState extends State<BookTripForLater> {
  DateTime chosedDate = DateTime.now();

  @override
  void initState() {
    chosedDate = widget.chosenDate;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: Sizes.width(context, 0.04),
      ),
      decoration: BoxDecoration(
        color: AppColors.rideMeBackgroundLight,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(
            Sizes.height(context, 0.03),
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Space.height(context, 0.022),
            //title
            Text(
              context.appLocalizations.bookForLater,
              style: context.textTheme.displayLarge!.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),

            Space.height(context, 0.02),

            Text(
              DateFormat('h:mm a').format(
                chosedDate,
              ),
              style: context.textTheme.displaySmall?.copyWith(
                color: AppColors.rideMeGreyDarker,
              ),
            ),

            Space.height(context, 0.012),

            Text(
              DateFormat('EE, d MMM').format(
                chosedDate,
              ),
              style: context.textTheme.displayMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),

            Space.height(context, 0.033),

            //date selector
            SizedBox(
              height: Sizes.height(context, 0.2),
              child: CupertinoDatePicker(
                minimumDate: DateTime.now(),
                initialDateTime: chosedDate,
                onDateTimeChanged: (value) {
                  setState(() {
                    chosedDate = value;
                  });
                },
              ),
            ),

            Space.height(context, 0.04),

            //notice
            Row(
              children: [
                SvgPicture.asset(
                  SvgNameConstants.scheduleSVG,
                  height: Sizes.height(context, 0.02),
                ),
                Space.width(context, 0.024),
                SizedBox(
                  width: Sizes.width(context, 0.7),
                  child: Text(
                    context.appLocalizations.bookForLaterNote,
                    style: context.textTheme.displaySmall?.copyWith(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: AppColors.rideMeGreyDarker,
                    ),
                  ),
                ),
              ],
            ),
            Space.height(context, 0.04),
            GenericButton(
              onTap: () => context.pop(chosedDate),
              label: context.appLocalizations.schedule,
              isActive: true,
            ),
          ],
        ),
      ),
    );
  }
}
