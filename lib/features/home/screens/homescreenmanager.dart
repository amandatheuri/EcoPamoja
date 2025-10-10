import 'package:ecopamoja/features/authentication/providers/user_provider.dart';
import 'package:ecopamoja/features/did_you_know/did_you_know_carousel.dart';
import 'package:ecopamoja/features/home/screens/mascot_section.dart';
import 'package:ecopamoja/features/home/screens/progress.dart';
import 'package:ecopamoja/shared_components/appbar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userDataProvider);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverEcoAppBar(),
          SliverToBoxAdapter(
            child: user == null
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.all(20),
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Mascot section
                        const MascotSection(),
                        const SizedBox(height: 20),

                        // Progress section
                        ProgressSection(
                          quizzesCompleted: user.quizzesCompleted,
                          actionsCompleted: user.actionsCompleted,
                          trophiesEarned: user.trophiesEarned,
                        ),
                        const SizedBox(height: 20),
                        // Did You Know carousel
                        const DidYouKnowCarousel(),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
