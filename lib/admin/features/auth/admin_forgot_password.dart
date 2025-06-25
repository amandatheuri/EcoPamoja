// ignore_for_file: use_build_context_synchronously

import 'package:ecopamoja/admin/features/auth/admin_auth_controller.dart';
import 'package:ecopamoja/shared_components/inputs/custom_textfield.dart';
import 'package:ecopamoja/theme_essentials/colors.dart';
import 'package:ecopamoja/theme_essentials/images.dart';
import 'package:ecopamoja/theme_essentials/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:ecopamoja/shared_components/animations/loading_success.dart';


class AdminForgotPassword extends StatefulWidget {
  const AdminForgotPassword({super.key});

  @override
  State<AdminForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<AdminForgotPassword> {
  bool _isLoading = false;
  bool _isSuccess = false;
  final _emailController= TextEditingController();
 void _handleResetPassword(WidgetRef ref) async {
  final email = _emailController.text.trim();

  if (email.isEmpty || !email.contains('@')) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Please enter a valid email"), backgroundColor: AppColors.primary),
    );
    return;
  }

  setState(() {
    _isLoading = true;
    _isSuccess = false;
  });

  try {
    await ref.read(adminAuthControllerProvider).sendPasswordReset(email);
     setState(() {
    _isLoading = false;
    _isSuccess = true;
  });
     ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Password reset link sent to $email')),
      );
  }catch(e){
    setState(() {
    _isLoading = false; 
    _isSuccess = false;
  });
     ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to send reset email.')),
      );
  }
}
  @override
  Widget build(BuildContext context) {
    final isMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    final isDesktop = ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET);
    return Scaffold(
      appBar: isMobile
          ? AppBar(
              title: Text('Forgot Password', style: AppTextStyles.title),
              backgroundColor: Colors.transparent,
              centerTitle: true,
            )
          : null,
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
                  vertical: 16.0,
                ),
                child: SingleChildScrollView(
                  child: _isLoading || _isSuccess
                      ? LoadingSuccess(
                          isLoading: _isLoading,
                          message: 'Check your Email for the reset link',
                          onPressed: () => Navigator.pop(context),
                        )
                      : Consumer(
                          builder: (context, ref, _) =>
                              _buildResetForm(isMobile, ref),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResetForm(bool isMobile, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter your email to reset password',
          style: AppTextStyles.subHeading.copyWith(fontSize: 16),
        ),
        const SizedBox(height: 20.0),
        AppTextfield(
          label: 'Email',
          icon: Icons.mail,
          hintText: 'you@example.com',
          controller: _emailController,
        ),
        const SizedBox(height: 20.0),
        Row(
          children: [
            ElevatedButton(
              onPressed: () => _handleResetPassword(ref),
              child: Text(
                'Reset Password',
                style: AppTextStyles.buttonText.copyWith(fontSize: isMobile ? 16 : 14),
              ),
            ),
            const SizedBox(width: 15.0),
            if (!isMobile)
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Back to login',
                  style: AppTextStyles.buttonText.copyWith(fontSize: isMobile ? 16 : 14),
                ),
              ),
          ],
        ),
      ],
    );
  }
}