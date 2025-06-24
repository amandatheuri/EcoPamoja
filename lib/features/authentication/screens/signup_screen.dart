import 'package:ecopamoja/features/authentication/widgets/signup_form.dart';
import 'package:ecopamoja/features/authentication/widgets/signupdivider.dart';
import 'package:ecopamoja/features/authentication/widgets/signupwith.dart';
import 'package:ecopamoja/theme_essentials/colors.dart';
import 'package:ecopamoja/theme_essentials/images.dart';
import 'package:ecopamoja/theme_essentials/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_framework/responsive_framework.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    final isDesktop = ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET);
    
    return Scaffold(
      appBar: isMobile ? AppBar(
        title: Text('Sign Up', style: AppTextStyles.title),
        backgroundColor: Colors.transparent,
        centerTitle: true,
      ) : null,
      body: Center(
        child: Stack(
          children: [
            if (isDesktop)
              Positioned.fill(
                top: 0,
                right: 0,
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
                  vertical: 16.0
                ),
                child: SingleChildScrollView(
                  child: isMobile
                    ? _buildMobileLayout(context)
                    : _buildDesktopLayout(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildMobileLayout( BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLogo(),
        const SizedBox(height: 18.0),
        _buildWelcomeText(ResponsiveBreakpoints.of(context).smallerThan(TABLET)),
        const SizedBox(height: 35.0),
        SignUpForm(),
        const SizedBox(height: 20.0),
        SignUpDivider(), // 
        const SizedBox(height: 20.0),
        SignUpWith(),
        const SizedBox(height: 20.0),
        _buildLoginPrompt(context),
      ],
    );
  }

  Widget _buildDesktopLayout( BuildContext context) {
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
              SignUpForm(),
            ],
          ),
        ),
        const SizedBox(width: 40.0),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              SignUpDivider(), 
              const SizedBox(height: 20.0),
              SignUpWith(),
              const SizedBox(height: 20.0),
              _buildLoginPrompt2(context),
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
    return Text('Welcome! Create your account to get started',style: AppTextStyles.bodyText.copyWith(fontSize: isMobile? 16.0: 14,color: Colors.grey[700],fontWeight: FontWeight.bold));
  }
  Widget _buildLoginPrompt(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
      Text('Already have an account?',style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.bold,fontSize: 14)),
          Expanded(
            child: TextButton(
              onPressed: () => context.push('/'),
              child: Text('Log In',style: AppTextStyles.bodyText.copyWith( fontSize: 14.0,color: AppColors.primary)),
            ),
          ),
        ],
    );
  }
  Widget _buildLoginPrompt2(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
      Expanded(
        child: Text('Already have an account?',style: AppTextStyles.bodyText.copyWith(fontWeight: FontWeight.bold,fontSize: 14)),
      ),
          Expanded(
            child: TextButton(
              onPressed: () => context.push('/'),
              child: Text('Log In',style: AppTextStyles.bodyText.copyWith( fontSize: 14.0,color: AppColors.primary,),),
            ),
          ),
        ],
    );
  }
}