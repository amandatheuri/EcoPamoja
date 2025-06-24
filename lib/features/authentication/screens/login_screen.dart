import 'package:ecopamoja/features/authentication/controllers/auth_controller.dart';
import 'package:ecopamoja/features/authentication/widgets/continuewith.dart';
import 'package:ecopamoja/features/authentication/widgets/login_divider.dart';
import 'package:ecopamoja/features/authentication/widgets/loginform.dart';
import 'package:ecopamoja/features/authentication/widgets/loginform_desktop.dart';
import 'package:ecopamoja/features/authentication/widgets/loginprompt.dart';
import 'package:ecopamoja/features/authentication/widgets/loginprompt_desktop.dart';
import 'package:ecopamoja/theme_essentials/images.dart';
import 'package:ecopamoja/theme_essentials/textstyles.dart';
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
              title: Text('Login', style: AppTextStyles.title),
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
    AppImages.background,
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
                      ? _buildMobileLayout(loginController, context)
                      : _buildDesktopLayout(loginController, context),
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
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLogo(),
        const SizedBox(height: 18.0),
        _buildWelcomeText(ResponsiveBreakpoints.of(context).smallerThan(TABLET)),
        const SizedBox(height: 35.0),
        LoginForm(),
        const SizedBox(height: 20.0),
        LoginDivider(),
        const SizedBox(height: 20.0),
        ContinueWith(),
        const SizedBox(height: 18.0),
        LoginPrompt(),
      ],
    );
  }

  Widget _buildDesktopLayout(
    AuthController loginController,
    BuildContext context,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLogo(),
              const SizedBox(height: 18.0),
              _buildWelcomeText(ResponsiveBreakpoints.of(context).smallerThan(TABLET)),
              const SizedBox(height: 35.0),
              LoginForm2(),
            ],
          ),
        ),
        const SizedBox(width: 40.0),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100), // Align with form
              LoginDivider(),
              const SizedBox(height: 20.0),
              ContinueWith(),
              const SizedBox(height: 20.0),
              LoginPrompt2(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Image.asset(AppImages.logo, height: 80, width: 80);
  }

  Widget _buildWelcomeText(isMobile) {
    return Text(
      'Welcome back! Login to continue',
      style: AppTextStyles.bodyText.copyWith(
        fontSize: isMobile? 16.0: 14,
        color: Colors.grey[700],
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
