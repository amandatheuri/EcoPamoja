import 'package:ecopamoja/features/authentication/screens/forgot_passwords.dart';
import 'package:ecopamoja/features/authentication/screens/login_screen.dart';
import 'package:ecopamoja/features/authentication/screens/signup_screen.dart';
import 'package:ecopamoja/features/home/screens/homescreenmanager.dart';
import 'package:ecopamoja/features/onboarding/screens/onboarding_screens.dart';
import 'package:ecopamoja/shared_components/navigation/main_nav_screen.dart';
import 'package:go_router/go_router.dart';

GoRouter appRouter({
  required bool showOnboarding,
  required bool isLoggedIn,
}) {
  return GoRouter(
    initialLocation: showOnboarding
        ? '/onboarding'
        : isLoggedIn
            ? '/navigation'
            : '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
      GoRoute(path: '/navigation', builder: (context, state)=> const MainNavigationScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomePage()),
      GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
      GoRoute(path: '/forgot-password', builder: (context, state) => const ForgotPassword()),
    ],
  );
}
  