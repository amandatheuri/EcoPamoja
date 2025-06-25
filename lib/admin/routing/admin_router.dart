import 'package:ecopamoja/admin/features/auth/admin_forgot_password.dart';
import 'package:ecopamoja/admin/features/auth/admin_login_screen.dart';
import 'package:ecopamoja/admin/features/dashboard/dashboard_screen.dart';
import 'package:go_router/go_router.dart';

final GoRouter adminRouter = GoRouter(
  initialLocation: '/admin-login',
  routes: [
    GoRoute(path: '/admin-login', builder: (context, state) =>const AdminLoginScreen()),
    GoRoute(path: '/admin-dashboard', builder: (context, state) =>const AdminDashboardScreen()),
    GoRoute(path: '/admin-forgotpassword', builder: (context, state) => const AdminForgotPassword()),
  ]);