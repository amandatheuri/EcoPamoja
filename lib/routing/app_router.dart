import 'package:ecopamoja/features/authentication/screens/forgot_passwords.dart';
import 'package:ecopamoja/features/authentication/screens/login_screen.dart';
import 'package:ecopamoja/features/authentication/screens/signup_screen.dart';
import 'package:ecopamoja/features/home/screens/homescreen.dart';
import 'package:ecopamoja/features/onboarding/screens/onboarding_screens.dart';
import 'package:go_router/go_router.dart';

GoRouter appRouter({
  required bool showOnboarding,
  required bool isLoggedIn,
}) {
  return GoRouter(
    initialLocation: showOnboarding
        ? '/onboarding'
        : isLoggedIn
            ? '/home'
            : '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/onboarding', builder: (context, state) => const OnboardingScreen()),
      GoRoute(path: '/home', builder: (context, state) => const Homescreen()),
      GoRoute(path: '/signup', builder: (context, state) => const SignupScreen()),
      GoRoute(path: '/forgot-password', builder: (context, state) => const ForgotPassword()),
    ],
  );
}
  