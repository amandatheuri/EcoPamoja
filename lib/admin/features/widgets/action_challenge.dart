import 'package:ecopamoja/admin/features/challenges/models/challenges_model.dart';
import 'package:ecopamoja/admin/features/challenges/models/sponsored_challenges.dart';
import 'package:ecopamoja/admin/features/challenges/services/challenges_service.dart';
import 'package:ecopamoja/admin/features/challenges/services/sponsored_services_challenges.dart';
import 'package:ecopamoja/admin/features/widgets/regular_action_card.dart';
import 'package:ecopamoja/admin/features/widgets/sponsored_action_card.dart';
import 'package:flutter/material.dart';

class ActionChallengesPage extends StatelessWidget {
  const ActionChallengesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Sponsored Challenges
                StreamBuilder<List<SponsoredChallengesModel>>(
                  stream: SponsoredChallengeService.getAllSponsoredChallenges(),
                  builder: (context, sponsoredSnapshot) {
                    if (sponsoredSnapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final sponsored = sponsoredSnapshot.data ?? [];
                    if (sponsored.isEmpty) return const SizedBox();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Sponsored Challenges',  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final width = constraints.maxWidth;
                            final crossAxisCount = width >= 1200
                                ? 4
                                : width >= 900
                                    ? 3
                                    : width >= 600
                                        ? 2
                                        : 1;

                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.4,
                              ),
                              itemCount: sponsored.length,
                              itemBuilder: (context, index) {
                                return SponsoredChallengeCard(challenge: sponsored[index]);
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                      ],
                    );
                  },
                ),

                /// Regular Action Challenges
                StreamBuilder<List<ChallengeModel>>(
                  stream: ChallengeService.getAllChallenges(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final challenges = snapshot.data ?? [];
                    final regular = challenges.where((c) => c.type == ChallengeType.action).toList();
                    if (regular.isEmpty) return const Text('No regular action challenges found.');

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text('Regular Action Challenges', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final width = constraints.maxWidth;
                            final crossAxisCount = width >= 1200
                                ? 4
                                : width >= 900
                                    ? 3
                                    : width >= 600
                                        ? 2
                                        : 1;

                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1.4,
                              ),
                              itemCount: regular.length,
                              itemBuilder: (context, index) {
                                return RegularActionChallengeCard(challenge: regular[index]);
                              },
                            );
                          },
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
