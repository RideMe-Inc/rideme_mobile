import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/size/sizes.dart';
import 'package:rideme_mobile/core/spacing/whitspacing.dart';
import 'package:rideme_mobile/core/theme/app_colors.dart';
import 'package:rideme_mobile/core/widgets/buttons/generic_button_widget.dart';
import 'package:rideme_mobile/core/widgets/loaders/loading_indicator.dart';
import 'package:rideme_mobile/core/widgets/popups/error_popup.dart';
import 'package:rideme_mobile/core/widgets/textfield/generic_textfield_widget.dart';
import 'package:rideme_mobile/features/authentication/presentation/bloc/authentication_bloc.dart';
import 'package:rideme_mobile/features/localization/presentation/providers/locale_provider.dart';
import 'package:rideme_mobile/features/user/presentation/bloc/user_bloc.dart';
import 'package:rideme_mobile/features/user/presentation/provider/user_provider.dart';
import 'package:rideme_mobile/injection_container.dart';

class MoreInfoAdditionPage extends StatefulWidget {
  final String token, email;
  const MoreInfoAdditionPage({
    super.key,
    required this.token,
    required this.email,
  });

  @override
  State<MoreInfoAdditionPage> createState() => _MoreInfoAdditionPageState();
}

class _MoreInfoAdditionPageState extends State<MoreInfoAdditionPage> {
  final firstName = TextEditingController();
  final lastName = TextEditingController();

  final authBloc = sl<AuthenticationBloc>();
  final userBloc = sl<UserBloc>();

  signUpUser() {
    final params = {
      "locale": context.read<LocaleProvider>().locale,
      "body": {
        "token": widget.token,
        "email": widget.email,
        "first_name": firstName.text,
        "last_name": lastName.text,
      }
    };

    authBloc.add(SignUpEvent(params: params));
  }

  getUserProfile(String token) {
    final params = {
      "locale": context.read<LocaleProvider>().locale,
      "bearer": token,
    };

    userBloc.add(GetUserProfileEvent(params: params));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocListener(
        bloc: userBloc,
        listener: (context, state) {
          if (state is GetUserProfileLoaded) {
            //udpate provider with user data and navigate to home
            context.read<UserProvider>().updateUserInfo = state.user;

            context.goNamed('home');
          }

          if (state is GetUserProfileError) {
            context.goNamed('noInternet');
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding:
                EdgeInsets.symmetric(horizontal: Sizes.height(context, 0.02)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.appLocalizations.enterFullName,
                  style: context.textTheme.displayLarge?.copyWith(
                    color: AppColors.rideMeBlackNormalActive,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Space.height(context, 0.012),
                Text(
                  context.appLocalizations.enterFullNameInfo,
                  style: context.textTheme.displaySmall,
                ),
                Space.height(context, 0.031),
                GenericTextField(
                  keyboardType: TextInputType.text,
                  label: context.appLocalizations.firstName,
                  hint: context.appLocalizations.enterYourFirstName,
                  controller: firstName,
                  onChanged: (p0) => setState(() {}),
                ),
                Space.height(context, 0.016),
                GenericTextField(
                  keyboardType: TextInputType.text,
                  label: context.appLocalizations.lastName,
                  hint: context.appLocalizations.enterYourLastName,
                  controller: lastName,
                  onChanged: (p0) => setState(() {}),
                ),
              ],
            ),
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
            BlocConsumer(
              bloc: authBloc,
              listener: (context, state) {
                if (state is SignupLoaded) {
                  //update user provider and navigate to home

                  getUserProfile(
                      state.authenticationInfo.authorization!.token!);
                  // context.read<UserProvider>().updateUserInfo =
                  //     state.authenticationInfo.user!;

                  // context.goNamed('home');
                }
                if (state is GenericAuthenticationError) {
                  showErrorPopUp(state.errorMessage, context);
                }
              },
              builder: (context, state) {
                if (state is SignupLoading) {
                  return const LoadingIndicator();
                }
                return GenericButton(
                  onTap: signUpUser,
                  label: context.appLocalizations.continues,
                  isActive:
                      firstName.text.length > 1 && lastName.text.length > 1,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
