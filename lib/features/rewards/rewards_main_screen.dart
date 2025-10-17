import 'package:ecopamoja/theme_essentials/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 'Unlocked' reward color
final Color unlocked = Color(0xff35B89B);
final Color rewardBorder = Color(0xff747474);

class Rewards extends ConsumerWidget {
  const Rewards({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                      "Level 5",
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
              SizedBox(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          color: null,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: rewardBorder),
                          ),
                          width: 132,
                          height: 114,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(Icons.star_outline_rounded),
                              Text(
                                "First step",
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: unlocked,
                                ),
                                child: Text(
                                  "Unlocked",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: null,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: rewardBorder),
                          ),
                          width: 132,
                          height: 114,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(Icons.star_outline_rounded),
                              Text(
                                "Week warrior",
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: unlocked,
                                ),
                                child: Text(
                                  "Unlocked",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          color: null,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: Border.all(color: rewardBorder),
                          ),
                          width: 132,
                          height: 114,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Icon(Icons.star_outline_rounded),
                              Text(
                                "Eco expert",
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              Container(
                                padding: const EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: unlocked,
                                ),
                                child: Text(
                                  "Unlocked",
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Opacity(
                          opacity: 0.5,
                          child: Container(
                            color: null,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(color: rewardBorder),
                            ),
                            width: 132,
                            height: 114,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Icon(Icons.star_outline_rounded),
                                Text(
                                  "Green champion",
                                  textAlign: TextAlign.center,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.labelMedium,
                                ),
                                // Container(
                                //   decoration: BoxDecoration(
                                //     borderRadius: BorderRadius.circular(25),
                                //     color: unlocked,
                                //   ),
                                //   child: Text(
                                //     "Unlocked",
                                //     style: Theme.of(context).textTheme.bodySmall
                                //   ),
                                // ),
                              ],
                            ),
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
