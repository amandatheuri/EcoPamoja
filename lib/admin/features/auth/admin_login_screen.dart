import 'package:ecopamoja/admin/features/widgets/admin_login_form.dart';
import 'package:ecopamoja/theme_essentials/images.dart';
import 'package:ecopamoja/theme_essentials/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class AdminLoginScreen extends StatelessWidget {
  const AdminLoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
     final adminIsMobile = ResponsiveBreakpoints.of(context).smallerThan(TABLET);
    final adminIsDesktop = ResponsiveBreakpoints.of(context).largerOrEqualTo(TABLET);
    return Scaffold(
      appBar: adminIsMobile?
        AppBar(
          title: Text('Login',style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          centerTitle: true,
        ):null,
        body: Center(child: Stack(
          children: [
            if(adminIsDesktop)
              Positioned.fill(
                child: Image.asset(AppImages.background, fit: BoxFit.cover)),
                Center(
                  child: Container(
                      constraints: BoxConstraints(
                  maxHeight: adminIsDesktop ? 550 : double.infinity,
                  maxWidth: adminIsDesktop ? 500 : double.infinity,
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: adminIsMobile ? 16.0 : 40.0,
                  vertical: 16.0,
                ),
                child: SingleChildScrollView(
                  child: adminIsMobile
                      ? _buildMobileLayout(context)
                      : _buildDesktopLayout(context),
                ),
                  )
                  )
          ],
        )),
    );
  }
   Widget _buildMobileLayout(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(AppImages.logo,width: 80,height: 80),
        const SizedBox(height: 18.0),
        Text( 'Welcome back admin!',
      style: AppTextStyles.bodyText.copyWith(
        fontSize:16,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
        const SizedBox(height: 35.0),
        AdminLoginForm(),
        const SizedBox(height: 20.0),
      ],
    );
  }
   Widget _buildDesktopLayout(BuildContext context,) {
    return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset(AppImages.logo,width: 80,height: 80),
              const SizedBox(height: 18.0),
              Text( 'Welcome back admin!',
      style: AppTextStyles.bodyText.copyWith(
        fontSize:14,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    ),
              const SizedBox(height: 35.0),
              AdminLoginForm(),
            ],
          );
  }
}