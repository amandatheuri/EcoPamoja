// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors

import 'package:ecopamoja/features/authentication/controllers/auth_controller.dart';
import 'package:ecopamoja/features/authentication/screens/forgot_passwords.dart';
import 'package:ecopamoja/shared_components/inputs/custom_textfield.dart';
import 'package:ecopamoja/theme_essentials/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm2 extends ConsumerStatefulWidget{
   const LoginForm2({super.key});
  @override
  ConsumerState<LoginForm2> createState() => _LoginFormState();
}
class _LoginFormState extends ConsumerState<LoginForm2>{
  final _formKey = GlobalKey<FormState>();
  final _emailController= TextEditingController();
  final _passwordController= TextEditingController();

  bool isLoading = false;
  bool _rememberMe = false;
  bool _obscurePassword= true;

  @override
  void initState() {
    super.initState();
    _loadSavedEmail();
  }
  void _loadSavedEmail()async{
  final prefs = await SharedPreferences.getInstance();
  final savedEmail = prefs.getString('saved_email');
  if(savedEmail!=null){
    setState(() {
      _emailController.text=savedEmail;
      _rememberMe=true;
    });
  }
  }
  void _login ()async{
    if (_formKey.currentState!.validate()){
      setState(() {
        isLoading= true;
      });
      final result = await ref.read(authControllerProvider).loginWithEmail(email: _emailController.text.trim(), password: _passwordController.text.trim());
      setState(() {
        isLoading=false;
      });
     if (result!=null){
      if(_rememberMe){
        final prefs=await SharedPreferences.getInstance();
        await prefs.setString('saved_email', _emailController.text.trim());
      }
     showDialog(
     context: context,
     builder: (context) => AlertDialog(
     content: Text('Login Successful', style: Theme.of(context).textTheme.bodySmall),
     backgroundColor: AppColors.primary,
     ),
      );

      Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop(); // close the dialog
      context.go('/home');         // navigate after
        });
      }else{
      showDialog(context: context, builder: (context)=> AlertDialog(
        content: Text('Login failed! Check password and email', style: Theme.of(context).textTheme.bodySmall),
        backgroundColor: AppColors.primary,
      ));
      }
    }
  }
 @override
  Widget build(BuildContext context) {
    return Form(key: _formKey,child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppTextfield(
          label: 'Email', 
          icon: Icons.mail, 
          hintText: 'you@example.com', 
          controller: _emailController,
          validator: (val)=> val==null|| !val.contains('@')?' Enter Valid Email': null, 
        ),
        const SizedBox(height: 16),
         AppTextfield(
          label: 'Password', 
          icon: Icons.lock, 
          hintText: 'Enter Password', 
          controller: _passwordController,
          isPassword: true,
          isVisible: _obscurePassword,
          toogleVisibility: () {
          setState(() {
           _obscurePassword = !_obscurePassword;
          });
            },
          validator: (val) => val == null || val.length < 6 ? 'Password too short' : null,
          ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (val) => setState(() => _rememberMe = val!),
                ),
                Text("Remember me", style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
        ),
          TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const ForgotPassword()),
                  );
                },
                child: Text(
                  "Forgot Password?",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 45,
          child: ElevatedButton(onPressed: isLoading? null: _login, 
          child: isLoading? CircularProgressIndicator(): Text('Login', style:Theme.of(context).textTheme.bodySmall)),
        )
      ],
    ));
  }
  }

