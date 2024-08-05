import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rideme_mobile/features/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:rideme_mobile/injection_container.dart';

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({super.key});

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  final onboardingBloc = sl<OnboardingBloc>();

  //ONBOARDING VIEWING STATUS
  isViewed() => onboardingBloc.add(IsOnboardingViewedEvent());

  @override
  void initState() {
    isViewed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener(
          bloc: onboardingBloc,
          listener: (context, state) {
            if (state is IsOnboardingViewedError) {
              //navigate to onboarding section
              context.goNamed('onboarding');
            }

            if (state is IsOnboardingViewedSuccess) {
              //network connection flow continues from here
            }
          },
        ),
      ],
      child: const Scaffold(),
    );
  }
}
