import 'package:ecopamoja/theme_essentials/colors.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ProgressSection extends StatelessWidget {
  final int quizzesCompleted;
  final int actionsCompleted;
  final int trophiesEarned;

  const ProgressSection({
    super.key,
    required this.quizzesCompleted,
    required this.actionsCompleted,
    required this.trophiesEarned,
  });

  @override
  Widget build(BuildContext context) {
    final int ongoingChallenges = quizzesCompleted + actionsCompleted;
    final int totalChallengesForBadge = 15;
    final int remainingForBadge =
        (totalChallengesForBadge - ongoingChallenges).clamp(0, totalChallengesForBadge);
    final double progress = (ongoingChallenges / totalChallengesForBadge).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(color: AppColors.complimentary.withOpacity(0.5), width: 1.2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row with icon + stats
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.complimentary.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.complimentary.withOpacity(0.5)),
                  ),
                  child: const Icon(Icons.flag_rounded,
                      color: AppColors.complimentary, size: 26),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$ongoingChallenges ongoing challenges",
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        "$remainingForBadge more to earn a badge 🏅",
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: const Color.fromARGB(179, 136, 136, 136),
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Linear Progress Indicator
            LinearPercentIndicator(
              percent: progress,
              lineHeight: 8,
              animation: true,
              barRadius: const Radius.circular(12),
              backgroundColor: Colors.white12,
              progressColor: AppColors.primary,
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}
