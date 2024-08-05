import 'package:go_router/go_router.dart';
import 'package:rideme_mobile/features/onboarding/presentation/pages/onboarding_page.dart';

import 'package:rideme_mobile/iam.dart';

final GoRouter goRouterConfiguration = GoRouter(
  initialLocation: '/onboarding',
  routes: [
    //ROOT
    GoRoute(
      name: 'root',
      path: '/',
      builder: (context, state) => const IAMScreenImplementer(),
    ),

    //ONBOARDING
    GoRoute(
      name: 'onboarding',
      path: '/onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),

    //SIGN UP

    //HOME
  ],
);
