import 'package:go_router/go_router.dart';

import 'package:rideme_mobile/iam.dart';

final GoRouter goRouterConfiguration = GoRouter(
  initialLocation: '/',
  routes: [
    //ROOT
    GoRoute(
      name: 'root',
      path: '/',
      builder: (context, state) => const IAMScreenImplementer(),
    ),
  ],
);
