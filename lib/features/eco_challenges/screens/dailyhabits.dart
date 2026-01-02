/*
container showing progress and number of challenges completed
display daily habit challenges from firestore
challenges displayed in a container with icon, challenge description(f.s), points to award(f.s), mark as done button.
 */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopamoja/features/eco_challenges/providers/fetchdata_provider.dart';
import 'package:ecopamoja/shared_components/appbar/custom_appbar.dart';
import 'package:ecopamoja/theme_essentials/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DailyHabits extends ConsumerWidget {
  const DailyHabits({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dailyProgressAsync = ref.watch(dailyProgressProvider);
    final dailyHabitsAsync = ref.watch(dailyHabitsProvider);

    const progressKey = 'dailyHabitsCompleted';
    const total = 3;

    return Scaffold(
      appBar: const CustomEcoAppBar(),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
        children: [
          // --- Progress Container ---
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF111111),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.grey),
            ),
            child: dailyProgressAsync.when(
              data: (progress) {
                final completed = progress[progressKey] ?? 0;
                final clamped = completed.clamp(0, total);
                final progressValue = clamped / total;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Daily Progress',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: AppColors.secondary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          '$clamped/$total completed',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progressValue,
                        backgroundColor: const Color(0xFF333333),
                        valueColor:
                            const AlwaysStoppedAnimation(AppColors.primary),
                        minHeight: 8,
                      ),
                    ),
                  ],
                );
              },
              loading: () => const CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 2,
              ),
              error: (err, _) {
                debugPrint('Progress error: $err');
                return const Text(
                  'Error loading progress',
                  style: TextStyle(color: Colors.grey),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // --- Daily Habits Challenges ---
          dailyHabitsAsync.when(
            data: (challenges) {
              if (challenges.isEmpty) {
                return const Text(
                  'No daily habit challenges available.',
                  style: TextStyle(color: Colors.grey),
                );
              }

              return Column(
                children: challenges.map((challenge) {
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF111111),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.primary),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // --- Row: icon + description + points aligned ---
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Icon
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.primary.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.eco,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 12),

                            // Column for description + points
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    challenge.description,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '${challenge.points} pts',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        // --- Full-width button ---
SizedBox(
  width: double.infinity,
  child: ElevatedButton(
    onPressed: () async {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final userDoc = FirebaseFirestore.instance.collection('users').doc(user.uid);

      try {
        await FirebaseFirestore.instance.runTransaction((transaction) async {
          final snapshot = await transaction.get(userDoc);
          final data = snapshot.data() ?? {};

          // 1️ Increment dailyHabitsCompleted
          final currentCompleted = (data['dailyHabitsCompleted'] ?? 0) + 1;
          final totalCompleted = (data['totalChallengesCompleted'] ?? 0) + 1;

          // 2️ Add challenge points
          final currentPoints = (data['pointsEarned'] ?? 0) + (challenge.points);

          // 3️ Update streak logic
          int currentStreak = data['streak'] ?? 0;
          DateTime? lastCompleted;
          if (data['lastDailyHabitsCompleted'] != null) {
            lastCompleted = (data['lastDailyHabitsCompleted'] as Timestamp).toDate();
          }

          final now = DateTime.now();
          if (lastCompleted != null &&
              now.difference(lastCompleted).inDays == 1) {
            currentStreak += 1; // increment streak if yesterday was completed
          } else if (lastCompleted == null ||
                     now.difference(lastCompleted).inDays > 1) {
            currentStreak = 1; // reset streak if missed a day
          }

          // Apply the updates in one transaction
          transaction.update(userDoc, {
            'dailyHabitsCompleted': currentCompleted,
            'pointsEarned': currentPoints,
            'streak': currentStreak,
            'lastDailyHabitsCompleted': Timestamp.now(),
            'totalChallengesCompleted':totalCompleted,
            'lastChallengeType': [challenge.type],
          });
        });

        // Optionally show a snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Challenge completed!')),
        );
      } catch (e) {
        debugPrint('Error completing challenge: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error completing challenge.')),
        );
      }
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    child: const Text(
      'Mark as done',
      style: TextStyle(fontSize: 12),
    ),
  ),
),
                      ],
                    ),
                  );
                }).toList(),
              );
            },
            loading: () => const Center(
                child: CircularProgressIndicator(color: AppColors.primary)),
            error: (err, _) {
              debugPrint('Daily habits error: $err');
              return const Text(
                'Error loading challenges',
                style: TextStyle(color: Colors.grey),
              );
            },
          ),
        ],
      ),
    );
  }
}
