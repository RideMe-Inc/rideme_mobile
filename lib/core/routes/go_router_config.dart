import 'package:go_router/go_router.dart';
import 'package:rideme_mobile/connection_page.dart';
import 'package:rideme_mobile/features/authentication/presentation/pages/otp_verification_page.dart';
import 'package:rideme_mobile/features/authentication/presentation/pages/phone_entry_page.dart';
import 'package:rideme_mobile/features/onboarding/presentation/pages/onboarding_page.dart';

final GoRouter goRouterConfiguration = GoRouter(
  initialLocation: '/',
  routes: [
    //ROOT
    GoRoute(
      name: 'root',
      path: '/',
      builder: (context, state) => const ConnectionPage(),
    ),

    //ONBOARDING
    GoRoute(
      name: 'onboarding',
      path: '/onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),

    //AUTHENTICATION
    GoRoute(
      name: 'login',
      path: '/login',
      builder: (context, state) => const PhoneEntryPage(),
      routes: [
        //otp verification

        GoRoute(
          name: 'otpVerification',
          path: 'otp-verification',
          builder: (context, state) => OtpVerificationPage(
            phoneNumber: state.uri.queryParameters['phone'] ?? '',
            token: state.uri.queryParameters['token'] ?? '',
          ),
        )
      ],
    ),

    //HOME
  ],
);
