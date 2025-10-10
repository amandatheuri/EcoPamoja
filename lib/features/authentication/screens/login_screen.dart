import 'package:ecopamoja/features/authentication/controllers/auth_controller.dart';
import 'package:ecopamoja/features/authentication/widgets/continuewith.dart';
import 'package:ecopamoja/features/authentication/widgets/login_divider.dart';
import 'package:ecopamoja/features/authentication/widgets/loginform.dart';
import 'package:ecopamoja/features/authentication/widgets/loginform_desktop.dart';
import 'package:ecopamoja/features/authentication/widgets/loginprompt.dart';
import 'package:ecopamoja/features/authentication/widgets/loginprompt_desktop.dart';
import 'package:ecopamoja/theme_essentials/images.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final loginController = AuthController();
    final isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    final isDesktop = ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET);

    return Scaffold(
      appBar: isMobile
          ? AppBar(
              backgroundColor: Colors.transparent,
              centerTitle: true,
            )
          : null,
      body: Center(
        child: Stack(
          children: [
            if (isDesktop)
              Positioned.fill(
                child: Image.asset(
                  AppImages.background3,
                  fit: BoxFit.cover,
                ),
              ),
            Center(
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: isDesktop ? 550 : double.infinity,
                  maxWidth: isDesktop ? 500 : double.infinity,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 16.0 : 40.0,
                  vertical: 16.0,
                ),
                child: SingleChildScrollView(
                  child: isMobile
                      ? _buildMobileLayout(loginController, context, isMobile)
                      : _buildDesktopLayout(loginController, context, isMobile),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileLayout(
    AuthController loginController,
    BuildContext context,
    bool isMobile,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLogo(),
        const SizedBox(height: 18.0),
        _buildWelcomeText(context, isMobile),
        const SizedBox(height: 35.0),
        LoginForm(),
        const SizedBox(height: 20.0),
        const LoginDivider(),
        const SizedBox(height: 20.0),
        const ContinueWith(),
        const SizedBox(height: 18.0),
        const LoginPrompt(),
      ],
    );
  }

  Widget _buildDesktopLayout(
    AuthController loginController,
    BuildContext context,
    bool isMobile,
  ) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1000),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(right: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLogo(),
                    const SizedBox(height: 20.0),
                    _buildWelcomeText(context, isMobile),
                    const SizedBox(height: 30.0),
                    const LoginForm2(),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(left: 24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    LoginDivider(),
                    SizedBox(height: 20.0),
                    ContinueWith(),
                    SizedBox(height: 20.0),
                    LoginPrompt2(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Image.asset(AppImages.logo, height: 80, width: 80);
  }


  Widget _buildWelcomeText(BuildContext context, bool isMobile) {
    return Text(
      'Welcome back! Login to continue',
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
            fontSize: isMobile ? 16.0 : 14,
            fontWeight: FontWeight.bold,
          ),
    );
  }
}
