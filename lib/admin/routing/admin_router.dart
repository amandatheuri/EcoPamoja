import 'package:ecopamoja/admin/features/auth/admin_forgot_password.dart';
import 'package:ecopamoja/admin/features/auth/admin_login_screen.dart';
import 'package:ecopamoja/admin/features/dashboard/dashboard_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';

final GoRouter adminRouter = GoRouter(
  initialLocation: '/admin-login',
  routes: [
    GoRoute(
      path: '/admin-login',
      builder: (context, state) => const AdminLoginScreen(),
    ),
    GoRoute(
      path: '/admin-dashboard',
      builder: (context, state) => const AdminDashboardOverview(),
    ),
    GoRoute(
      path: '/admin-forgotpassword',
      builder: (context, state) => const AdminForgotPassword(),
    ),
  ],
  redirect: (context, state) {
    final user = FirebaseAuth.instance.currentUser;
    final isLoggingIn =
        state.matchedLocation == '/admin-login' ||
        state.matchedLocation == '/admin-forgotpassword';

    if (user == null && !isLoggingIn) {
      // Not logged in, trying to access protected route
      return '/admin-login';
    }

    if (user != null && isLoggingIn) {
      // Already logged in, redirect away from login/forgot
      return '/admin-dashboard';
    }

    return null; // No redirect
  },
);
