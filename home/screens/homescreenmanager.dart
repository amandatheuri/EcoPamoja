import 'package:ecopamoja/features/authentication/providers/user_provider.dart';
import 'package:ecopamoja/features/home/screens/mascot_section.dart';
import 'package:ecopamoja/features/home/screens/progress.dart';
import '../did_you_know/did_you_know_carousel.dart';
import 'package:ecopamoja/shared_components/appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDataProvider);

    return Scaffold(
      appBar: const CustomEcoAppBar(), 
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const MascotSection(),

            const SizedBox(height: 20),

            // User progress
            ProgressSection(
              quizzesCompleted: user?.quizzesCompleted ?? 0,
              actionsCompleted: user?.actionsCompleted ?? 0,
              trophiesEarned: user?.trophiesEarned ?? 0,
            ),

            const SizedBox(height: 20),

            // Did You Know carousel
            const DidYouKnowCarousel(),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
