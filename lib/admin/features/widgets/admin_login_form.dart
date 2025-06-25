// ignore_for_file: use_build_context_synchronously

import 'package:ecopamoja/admin/features/auth/admin_auth_controller.dart';
import 'package:ecopamoja/admin/features/auth/admin_forgot_password.dart';
import 'package:ecopamoja/shared_components/inputs/custom_textfield.dart';
import 'package:ecopamoja/theme_essentials/colors.dart';
import 'package:ecopamoja/theme_essentials/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AdminLoginForm extends ConsumerStatefulWidget {
  const AdminLoginForm({super.key});
  @override
  ConsumerState<AdminLoginForm> createState() => _AdminLoginScreenState();
}
class _AdminLoginScreenState extends ConsumerState<AdminLoginForm>{
  final _adminFormKey = GlobalKey<FormState>();
  final _adminEmailController = TextEditingController();
  final _adminPasswordController = TextEditingController();
  bool _adminIsLoading = false;
  bool _adminObscurePassword = true;

  void _adminLogin() async{
    if(_adminFormKey.currentState!.validate()){
      setState(() {
        _adminIsLoading=true;
      });
      final credentialsResult = await ref.read(adminAuthControllerProvider).signInUser(
        email: _adminEmailController.text.trim(),
        password: _adminPasswordController.text.trim(),
      );
      setState(() {
        _adminIsLoading=false;
      });
      if(credentialsResult!=null){
       ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Login successful!'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
        );
      context.go('/admin-dashboard');         // navigate after
        }
    else{
       ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Login failed', style: TextStyle(color: Colors.white)),
    backgroundColor: Colors.red,
  ),
);
    }
    }
  }

  @override
  Widget build(BuildContext context) {
  return Form(key: _adminFormKey,child: Column(
    children: [
       AppTextfield(
          label: 'Email', 
          icon: Icons.mail, 
          hintText: 'you@example.com', 
          controller: _adminEmailController,
          validator: (val)=> val==null|| !val.contains('@')?' Enter Valid Email': null, 
        ),
        const SizedBox(height: 16),
         AppTextfield(
          label: 'Password', 
          icon: Icons.lock, 
          hintText: 'Enter Password', 
          controller: _adminPasswordController,
          isPassword: true,
          isVisible: _adminObscurePassword,
          toogleVisibility: () {
          setState(() {
           _adminObscurePassword = !_adminObscurePassword;
          });
            },
          validator: (val) => val == null || val.length < 6 ? 'Password too short' : null,
          ),
      const SizedBox(height: 20),
       TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AdminForgotPassword()),
                  );
                },
                child: Text(
                  "Forgot Password?",
                  style: AppTextStyles.buttonText.copyWith(color: AppColors.primary,fontSize: 14),
                ),
              ),
              const SizedBox(height: 18),
               SizedBox(
          width: double.infinity,
          height: 45,
          child: ElevatedButton(onPressed: _adminIsLoading? null: _adminLogin, 
          child: _adminIsLoading? CircularProgressIndicator(): Text('Login', style: AppTextStyles.buttonText,)),
        )
    ],
  ));
  }

}