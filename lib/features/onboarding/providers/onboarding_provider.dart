import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final onboardingProvider = StateNotifierProvider<OnboardingController, int>((ref) {
  return OnboardingController();
});

class OnboardingController extends StateNotifier<int> {
  OnboardingController() : super(0);

  void nextPage() => state++;
  void previousPage() => state--;
  void goToPage(int index) => state = index;

  static Future<void> markOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
  }
}