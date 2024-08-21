import 'package:go_router/go_router.dart';
import 'package:rideme_mobile/connection_page.dart';
import 'package:rideme_mobile/features/authentication/presentation/pages/enter_email_page.dart';
import 'package:rideme_mobile/features/authentication/presentation/pages/more_info_addition_page.dart';
import 'package:rideme_mobile/features/authentication/presentation/pages/otp_verification_page.dart';
import 'package:rideme_mobile/features/authentication/presentation/pages/phone_entry_page.dart';
import 'package:rideme_mobile/features/home/presentation/pages/home_page.dart';
import 'package:rideme_mobile/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:rideme_mobile/features/payment/presentation/pages/payment.dart';
import 'package:rideme_mobile/features/trips/presentation/pages/trip_history.dart';
import 'package:rideme_mobile/features/user/presentation/pages/faq_page.dart';
import 'package:rideme_mobile/features/user/presentation/pages/profile.dart';
import 'package:rideme_mobile/features/user/presentation/pages/promotions.dart';
import 'package:rideme_mobile/features/user/presentation/pages/safety_page.dart';
import 'package:rideme_mobile/features/user/presentation/pages/support.dart';

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
            userExist:
                bool.parse(state.uri.queryParameters['user_exist'] ?? 'false'),
          ),
        ),

        //COMPLETE SIGN UP
        GoRoute(
            name: 'additionalInfo',
            path: 'additional-info',
            builder: (context, state) => EnterEmailPage(
                  token: state.uri.queryParameters['token'] ?? '',
                ),
            routes: [
              GoRoute(
                name: 'moreAdditionalInfo',
                path: 'more-additional-info',
                builder: (context, state) => MoreInfoAdditionPage(
                  token: state.uri.queryParameters['token'] ?? '',
                  email: state.uri.queryParameters['email'] ?? '',
                ),
              )
            ])
      ],
    ),

    //HOME

    GoRoute(
      name: 'home',
      path: '/home',
      builder: (context, state) => const HomePage(),
      routes: [
        //profile
        GoRoute(
          name: 'profile',
          path: 'profile',
          builder: (context, state) => const ProfilePage(),
        ),

        //payment
        GoRoute(
          name: 'payment',
          path: 'payment',
          builder: (context, state) => const PaymentPage(),
        ),

        //history

        GoRoute(
          name: 'history',
          path: 'history',
          builder: (context, state) => const TripHistoryPage(),
        ),

        //promotions

        GoRoute(
          name: 'promotions',
          path: 'promotions',
          builder: (context, state) => const PromotionsPage(),
        ),

        //support
        GoRoute(
          name: 'support',
          path: 'support',
          builder: (context, state) => const SupportPage(),
          routes: [
            //faq
            GoRoute(
              name: 'faq',
              path: 'faq',
              builder: (context, state) => const FaqPage(),
            ),

            //safety
            GoRoute(
              name: 'safety',
              path: 'safety',
              builder: (context, state) => const SafetyPage(),
            ),
          ],
        ),
      ],
    )
  ],
);
