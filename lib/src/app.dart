import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'core/localization/app_locale.dart';
import 'core/localization/strings.dart';
import 'feature/auth/presentation/login_page.dart';
import 'feature/auth/presentation/register_page.dart';
import 'feature/home/presentation/home_page.dart';
import 'feature/shell/presentation/shell_page.dart';
import 'feature/splash/presentation/splash_page.dart';

class AppRoot extends StatelessWidget {
  const AppRoot({super.key});

  @override
  Widget build(BuildContext context) {
    final GoRouter router = GoRouter(
      initialLocation: '/splash',
      routes: <RouteBase>[
        GoRoute(
          path: '/splash',
          builder: (BuildContext context, GoRouterState state) => const SplashPage(),
        ),
        GoRoute(
          path: '/login',
          builder: (BuildContext context, GoRouterState state) => const LoginPage(),
        ),
        GoRoute(
          path: '/register',
          builder: (BuildContext context, GoRouterState state) => const RegisterPage(),
        ),
        GoRoute(
          path: '/',
          builder: (BuildContext context, GoRouterState state) => const ShellPage(),
        ),
      ],
    );

    return AnimatedBuilder(
      animation: AppLocaleController.instance,
      builder: (BuildContext context, Widget? _) {
        final S t = S.of(AppLocaleController.instance.locale);
        return MaterialApp.router(
          title: t.appTitle,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.darkCinematic(),
          routerConfig: router,
        );
      },
    );
  }
}
