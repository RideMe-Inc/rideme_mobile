import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/spacing/whitspacing.dart';
import 'package:rideme_mobile/core/widgets/buttons/generic_button_widget.dart';

class NoInternetPage extends StatelessWidget {
  const NoInternetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            context.appLocalizations.noInternetConnection,
            style: context.textTheme.headlineSmall,
          ),
          Space.height(context, 0.01),
          Text(
            context.appLocalizations.noInternetConnectionDesc,
            style: context.textTheme.displayMedium,
          ),
          Space.height(context, 0.05),
          GenericButton(
            onTap: () => context.goNamed('root'),
            label: context.appLocalizations.retry,
            isActive: true,
          )
        ],
      ),
    );
  }
}
