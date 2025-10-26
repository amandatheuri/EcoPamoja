import 'package:ecopamoja/features/rewards/custom_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'logic.dart';

// 'Unlocked' reward color
final Color unlocked = Color(0xff35B89B);
final Color rewardBorder = Color(0xff747474);

class Rewards extends ConsumerWidget {
  const Rewards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rewards = ref.watch(rewardsProvider);
    final level = (rewards.points / 100).ceil() + 1;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(21.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Container(
                width: 347,
                height: 178,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Theme.of(context).primaryColor,
                ),
                child: Column(
                  children: [
                    Icon(Icons.star, size: 50),
                    const SizedBox(height: 10),
                    Text(
                      "Level $level",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge!.copyWith(fontSize: 24),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Eco enthusiast",
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge!.copyWith(color: rewardBorder),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Your Badges",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              const SizedBox(height: 10),

              // categories
              SizedBox(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RewardContainer(
                          category:
                              badgeDisplayNames[BadgeCategories.firstStep]!,
                          unlockedCategory: rewards.unlockedBadges.contains(
                            BadgeCategories.firstStep,
                          ),
                        ),
                        RewardContainer(
                          category:
                              badgeDisplayNames[BadgeCategories.weekWarrior]!,
                          unlockedCategory: rewards.unlockedBadges.contains(
                            BadgeCategories.weekWarrior,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        RewardContainer(
                          category:
                              badgeDisplayNames[BadgeCategories.ecoExpert]!,
                          unlockedCategory: rewards.unlockedBadges.contains(
                            BadgeCategories.ecoExpert,
                          ),
                        ),
                        RewardContainer(
                          category:
                              badgeDisplayNames[BadgeCategories.greenChampion]!,
                          unlockedCategory: rewards.unlockedBadges.contains(
                            BadgeCategories.greenChampion,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
