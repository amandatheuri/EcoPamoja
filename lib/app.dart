import 'package:ecopamoja/routing/app_router.dart';
import 'package:ecopamoja/theme_essentials/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class MainApp extends StatelessWidget {
  final bool showOnboarding;
  final bool isLoggedIn;

  const MainApp({
    super.key,
    required this.showOnboarding,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: appRouter(
        showOnboarding: showOnboarding,
        isLoggedIn: isLoggedIn,
      ),
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
    );
  }
}
