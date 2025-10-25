import 'package:ecopamoja/features/eco_challenges/providers/fetchdata_provider.dart';
import 'package:ecopamoja/theme_essentials/colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'dart:async';

final _selectedCardProvider =
    StateProvider.autoDispose<bool>((ref) => false);

class QuizChallengeCard extends ConsumerWidget {
  final String title;
  final int total;
  final IconData icon;
  final VoidCallback onContinue;
  final String progressKey;

  const QuizChallengeCard({
    super.key,
    required this.title,
    required this.total,
    required this.icon,
    required this.onContinue,
    required this.progressKey,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newChallengesAsync = ref.watch(newChallengesProvider);
    final dailyProgressAsync = ref.watch(dailyProgressProvider);
    final isSelected = ref.watch(_selectedCardProvider);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected
              ? AppColors.primary
              : const Color(0xFFB8FF60).withOpacity(0.15),
          width: 1.3,
        ),
        boxShadow: isSelected
            ? [
                BoxShadow(
                  color: AppColors.primary.withOpacity(0.35),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ]
            : [],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // === Header Row ===
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // --- Icon ---
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child:
                  Icon(icon, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 12),

              // --- Title + Progress ---
              Expanded(
                child: dailyProgressAsync.when(
                  data: (progress) {
                    final completed = progress[progressKey] ?? 0;
                    final clamped = completed.clamp(0, total);
                    final progressValue = clamped / total;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: AppColors.secondary,
                          ),
                        ),
                        Text(
                          '$clamped/$total completed',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.7),
                          ),
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
                  loading: () => const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      color: AppColors.primary,
                      strokeWidth: 2,
                    ),
                  ),
                  error: (err, _) {
                    debugPrint('🔥 Progress error: $err');
                    return const Text(
                      'Error loading progress',
                      style: TextStyle(color: Colors.grey),
                    );
                  },
                ),
              ),

              // --- New challenges count ---
              const SizedBox(width: 8),
              newChallengesAsync.when(
                data: (count) => Text(
                  '$count New',
                  style: const TextStyle(
                    color: Color(0xFFB8FF60),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                ),
                loading: () => const Text(
                  '...',
                  style: TextStyle(color: Color(0xFFB8FF60)),
                ),
                error: (err, _) {
                  debugPrint('🔥 UI Error fetching challenges: $err');
                  return const Text(
                    'Error',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 16),

          // === Continue button ===
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                //Highlight the card
                ref.read(_selectedCardProvider.notifier).state = true;

                //Remove highlight after 3 seconds
                Future.delayed(const Duration(seconds: 3), () {
                  ref.read(_selectedCardProvider.notifier).state = false;
                });

                //Continue action
                onContinue();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text(
                'Continue',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
