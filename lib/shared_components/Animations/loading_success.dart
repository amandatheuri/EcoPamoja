import 'package:ecopamoja/theme_essentials/images.dart';
import 'package:ecopamoja/theme_essentials/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LoadingSuccess extends StatelessWidget {
  final String message;
  final VoidCallback? onPressed;
  final bool isLoading;

  const LoadingSuccess({
    super.key,
    this.message = 'Operation Successful',
    this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: isLoading? CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
        
      ): Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Lottie.asset(
            AppImages.success,
            width: 170,
            height: 170,
          ),
          const SizedBox(height: 20),
          Text(
            message,
            style: AppTextStyles.bodyText,
          ),
          const SizedBox(height: 30),
          if (onPressed != null)
            ElevatedButton(
              onPressed: onPressed,
              child: Text('OK', style: AppTextStyles.buttonText),
            ),
        ],
      ),
    );
  }
}