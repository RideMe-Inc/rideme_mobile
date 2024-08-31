import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rideme_mobile/core/extensions/context_extensions.dart';
import 'package:rideme_mobile/core/size/sizes.dart';
import 'package:rideme_mobile/core/spacing/whitspacing.dart';
import 'package:rideme_mobile/core/theme/app_colors.dart';
import 'package:rideme_mobile/core/widgets/buttons/generic_button_widget.dart';
import 'package:rideme_mobile/core/widgets/loaders/loading_indicator.dart';
import 'package:rideme_mobile/core/widgets/popups/error_popup.dart';
import 'package:rideme_mobile/core/widgets/popups/success_popup.dart';
import 'package:rideme_mobile/core/widgets/textfield/generic_textfield_widget.dart';
import 'package:rideme_mobile/features/authentication/presentation/provider/authentication_provider.dart';
import 'package:rideme_mobile/features/localization/presentation/providers/locale_provider.dart';
import 'package:rideme_mobile/features/user/domain/entities/user.dart';
import 'package:rideme_mobile/features/user/presentation/bloc/user_bloc.dart';
import 'package:rideme_mobile/features/user/presentation/provider/user_provider.dart';
import 'package:rideme_mobile/injection_container.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final userBloc = sl<UserBloc>();
  User? user;

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final phoneNumber = TextEditingController();

  populateFields() {
    final user = context.read<UserProvider>().user;
    email.text = user?.email ?? '';
    lastName.text = user?.lastName ?? '';
    phoneNumber.text = user?.phone ?? '';
    firstName.text = user?.firstName ?? '';
  }

  editProfile() {
    final Map<String, dynamic> params = {
      "locale": context.read<LocaleProvider>().locale,
      "bearer": context.read<AuthenticationProvider>().token,
      "body": {
        "first_name": firstName.text,
        "last_name": lastName.text,
      }
    };

    userBloc.add(EditProfileEvent(params: params));
  }

  @override
  void initState() {
    populateFields();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    user = context.watch<UserProvider>().user;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.appLocalizations.userDetails,
          style: context.textTheme.displayMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(Sizes.height(context, 0.02)),
          child: Column(
            children: [
              //first name
              GenericTextField(
                label: context.appLocalizations.firstName,
                hint: '',
                controller: firstName,
                onChanged: (p0) => setState(() {}),
              ),

              Space.height(context, 0.02),

              //last name
              GenericTextField(
                label: context.appLocalizations.lastName,
                hint: '',
                controller: lastName,
                onChanged: (p0) => setState(() {}),
              ),
              Space.height(context, 0.02),

              //phone number
              GenericTextField(
                label: context.appLocalizations.phoneNumber,
                hint: '',
                controller: phoneNumber,
                enabled: false,
              ),

              Space.height(context, 0.02),

              //last name
              GenericTextField(
                label: context.appLocalizations.email,
                hint: '',
                controller: email,
                enabled: false,
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: EdgeInsets.symmetric(
          horizontal: Sizes.height(context, 0.02),
          vertical: Sizes.height(context, 0.03),
        ),
        color: AppColors.rideMeBackgroundLight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            BlocConsumer(
              bloc: userBloc,
              listener: (context, state) {
                if (state is EditProfileError) {
                  showErrorPopUp(state.message, context);
                }

                if (state is EditProfileLoaded) {
                  context.read<UserProvider>().updateUserInfo = state.user;
                  showSuccessPopUp('Profile information updated', context);
                  populateFields();
                }
              },
              builder: (context, state) {
                if (state is EditProfileLoading) {
                  return const LoadingIndicator();
                }

                return GenericButton(
                  onTap: editProfile,
                  label: context.appLocalizations.update,
                  isActive: user?.firstName != firstName.text ||
                      user?.lastName != lastName.text,
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
