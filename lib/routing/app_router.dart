import 'package:ecopamoja/features/authentication/screens/forgot_passwords.dart';
import 'package:ecopamoja/features/authentication/screens/login_screen.dart';
import 'package:ecopamoja/features/authentication/screens/signup_screen.dart';
import 'package:ecopamoja/features/eco_challenges/screens/challenges.dart';
import 'package:ecopamoja/features/eco_challenges/screens/dailyhabits.dart';
import 'package:ecopamoja/features/home/screens/homescreenmanager.dart';
import 'package:ecopamoja/features/onboarding/screens/onboarding_screens.dart';
import 'package:ecopamoja/shared_components/navigation/main_nav_screen.dart';
import 'package:ecopamoja/features/groups/main_groups_screen.dart';
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
      //  NO NAVBAR
      GoRoute(
        path: '/',
        builder: (_, __) => const LoginScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/signup',
        builder: (_, __) => const SignupScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        builder: (_, __) => const ForgotPassword(),
      ),

      // NAVBAR SHELL
      ShellRoute(
        builder: (context, state, child) {
          return MainNavigationScreen(shellChild: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (_, __) => const HomePage(),
          ),
         GoRoute(
            path: '/challenges',
            builder: (_, __) => const UserChallenges(),
          ),
          GoRoute(
            path: '/groups',
            builder: (_, __) => const Groups(),
          ),
          /*GoRoute(
            path: '/rewards',
            builder: (_, __) => const RewardsPage(),
          ),
*/
          // NOT A TAB BUT HAS NAVBAR
          GoRoute(
            path: '/daily-habits',
            builder: (_, __) => const DailyHabits(),
          ),
        ],
      ),
    ],
  );
}
