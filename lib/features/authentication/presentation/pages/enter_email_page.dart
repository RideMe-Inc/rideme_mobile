import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/size/sizes.dart';
import 'package:rideme_mobile/core/spacing/whitspacing.dart';
import 'package:rideme_mobile/core/theme/app_colors.dart';
import 'package:rideme_mobile/core/widgets/buttons/generic_button_widget.dart';
import 'package:rideme_mobile/core/widgets/textfield/generic_textfield_widget.dart';
import 'package:string_validator/string_validator.dart';

class EnterEmailPage extends StatefulWidget {
  final String token;
  const EnterEmailPage({
    super.key,
    required this.token,
  });

  @override
  State<EnterEmailPage> createState() => _EnterEmailPageState();
}

class _EnterEmailPageState extends State<EnterEmailPage> {
  final email = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              EdgeInsets.symmetric(horizontal: Sizes.height(context, 0.02)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.appLocalizations.enterYourEmail,
                style: context.textTheme.displayLarge?.copyWith(
                  color: AppColors.rideMeBlackNormalActive,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Space.height(context, 0.012),
              Text(
                context.appLocalizations.enterEmailToComplete,
                style: context.textTheme.displaySmall,
              ),
              Space.height(context, 0.031),
              GenericTextField(
                keyboardType: TextInputType.emailAddress,
                label: context.appLocalizations.emailAddress,
                hint: 'simon23@example.com',
                controller: email,
                onChanged: (p0) => setState(() {}),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.symmetric(
            horizontal: Sizes.height(context, 0.02),
            vertical: Sizes.height(context, 0.02)),
        color: context.theme.scaffoldBackgroundColor,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GenericButton(
              onTap: () => context.pushNamed(
                'moreAdditionalInfo',
                queryParameters: {
                  "email": email.text,
                  "token": widget.token,
                },
              ),
              label: context.appLocalizations.continues,
              isActive: isEmail(email.text),
            ),
          ],
        ),
      ),
    );
  }
}
