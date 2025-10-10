import 'package:ecopamoja/app.dart';
import 'package:ecopamoja/firebase_options.dart';
import 'package:ecopamoja/platform_check_stub.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefs = await SharedPreferences.getInstance();
  final isOnboardingComplete = prefs.getBool('onboarding_completed') ?? false;
  final isLoggedIn = FirebaseAuth.instance.currentUser != null;
  final isMobilePlatform = !kIsWeb && isMobile;
  final showOnboardingForTesting = false; 
  final shouldShowOnboarding =
      // ignore: dead_code
      showOnboardingForTesting ? true : (isMobilePlatform && !isOnboardingComplete);

  runApp(
    ProviderScope(
      child: MainApp(
        showOnboarding: shouldShowOnboarding,
        isLoggedIn: isLoggedIn,
      ),
    ),
  );
}

