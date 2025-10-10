import 'package:ecopamoja/theme_essentials/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';

class AppTextfield extends StatelessWidget {
  final String label;
  final IconData icon;
  final String hintText;
  final TextEditingController controller;
  final bool isPassword;
  final bool isVisible;
  final VoidCallback? toogleVisibility;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? autofillHint;

  const AppTextfield({
    super.key,
    required this.label,
    required this.icon,
    required this.hintText,
    required this.controller,
    this.isPassword = false,
    this.isVisible = false,
    this.toogleVisibility,
    this.validator,
    this.keyboardType,
    this.inputFormatters,
    this.autofillHint,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword && !isVisible,
      validator: validator,
      keyboardType: keyboardType ??
          (isPassword ? TextInputType.visiblePassword : TextInputType.text),
      textInputAction: TextInputAction.next,
      inputFormatters: inputFormatters,
      autofillHints: autofillHint != null ? [autofillHint!] : null,
      style: Theme.of(context).textTheme.bodySmall,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 12.0),
        labelText: label,
        labelStyle: TextStyle(color: AppColors.grey, fontSize: 14),
        floatingLabelStyle: TextStyle(color: AppColors.primary),
        hintText: hintText,
        hintStyle: TextStyle(color: const Color.fromARGB(255, 139, 138, 138)),
        prefixIcon: Icon(icon),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isVisible ? Iconsax.eye : Iconsax.eye_slash,
                ),
                onPressed: toogleVisibility,
              )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
        errorStyle: TextStyle(color: Theme.of(context).colorScheme.error),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
        ),
      ),
    );
  }
}
