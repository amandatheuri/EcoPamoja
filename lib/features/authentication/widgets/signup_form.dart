// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:async';

import 'package:ecopamoja/shared_components/inputs/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controllers/auth_controller.dart';

class SignUpForm extends ConsumerStatefulWidget {
  const SignUpForm({super.key});

  @override
  ConsumerState<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends ConsumerState<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  Timer? _debounce;
  String? _usernameStatus;
  bool _checkingUsername = false;
    bool _obscurePassword= true;



  bool isLoading = false;

  @override
  void initState() {
  super.initState();
  _usernameController.addListener(_onUsernameChanged);
}
  @override
  void dispose() {
  _debounce?.cancel();
  _usernameController.dispose();
  _emailController.dispose();
  _passwordController.dispose();
  super.dispose();
}
void _onUsernameChanged() {
  final username = _usernameController.text.trim();

  if (_debounce?.isActive ?? false) _debounce!.cancel();
  _debounce = Timer(const Duration(milliseconds: 500), () async {
    if (username.length < 3) {
      setState(() => _usernameStatus = null);
      return;
    }

    setState(() {
      _checkingUsername = true;
      _usernameStatus = null;
    });

    final exists = await ref
        .read(authControllerProvider)
        .checkUsernameExists(username);

    setState(() {
      _checkingUsername = false;
      _usernameStatus = exists ? 'Username already taken' : 'Username available';
    });
  });
}

  void _signup() async {
    if (_formKey.currentState!.validate()) {
      print("✅ Form is valid. Starting signup...");
      setState(() => isLoading = true);

      final username = _usernameController.text.trim();
 print("🔍 Checking if username is taken...");
      // Step 1: Check if username already exists
      final isTaken = await ref
          .read(authControllerProvider)
          .checkUsernameExists(username);

      if (isTaken) {
        setState(() => isLoading = false);
        print("❌ Username already taken.");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Username already taken")),
        );
        return;
      }
      // Step 2: Proceed with signup
      print("🚀 Registering with email...");
      final result = await ref.read(authControllerProvider).registerWithEmail(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
            username: username,
          );

      setState(() => isLoading = false);

      if (result != null) {
          print("🎉 Signup successful");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Signup successful")),
        );
        context.go('/home');
      } else {
            print("⚠️ Signup failed");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Signup failed")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return 
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextfield(
                 label: 'Username', 
                 icon: Icons.person, 
                 hintText: 'Enter Username',
                controller: _usernameController,
                validator: (val) => val == null || val.trim().length < 3
                    ? 'Enter a valid username'
                    : null,
              ),
              const SizedBox(height: 4),
               if (_checkingUsername)
      const Text('Checking...', style: TextStyle(color: Colors.grey)),
    if (_usernameStatus != null)
      Text(
        _usernameStatus!,
        style: TextStyle(
          color: _usernameStatus == 'Username available'
              ? Colors.green
              : Colors.red,
          fontSize: 12,
        ),
      ),
              const SizedBox(height: 10),
              AppTextfield(
                label: 'Email', 
                icon: Icons.mail, 
                hintText: 'you@example.com',
                controller: _emailController,
                validator: (val) => val == null || !val.contains('@')
                    ? 'Enter a valid email'
                    : null, 
              ),
              const SizedBox(height: 10),
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
              const SizedBox(height: 20),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading || _usernameStatus == 'Username already taken'
                      ? null
                      : _signup,
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Sign Up"),
                ),
              ),

            ],
          ),
        );
  }
}
