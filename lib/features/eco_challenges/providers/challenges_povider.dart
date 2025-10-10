import 'package:flutter_riverpod/flutter_riverpod.dart';

final challengeCategories = [
  'Quiz',
  'Daily habits',
  'Nature',
  'Sustainable living',
  'Waste',
];

final selectedCategoryProvider = StateProvider<String>((ref) {
  return challengeCategories[0]; 
});
