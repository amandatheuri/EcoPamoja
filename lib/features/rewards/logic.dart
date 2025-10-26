import 'package:flutter_riverpod/flutter_riverpod.dart';

// challenge categories enum
enum ChallengeCategories { regular, sponsored }

enum BadgeCategories { firstStep, weekWarrior, ecoExpert, greenChampion }

// category group
const Map<BadgeCategories, String> badgeDisplayNames = {
  BadgeCategories.firstStep: "First Step",
  BadgeCategories.weekWarrior: "Week Warrior",
  BadgeCategories.ecoExpert: "Eco Expert",
  BadgeCategories.greenChampion: "Green Champion",
};

class Rewards {
  // reward variables
  final int points;
  final Set<BadgeCategories> unlockedBadges;

  const Rewards({this.points = 0, this.unlockedBadges = const {}});

  Rewards copyWith({int? points, Set<BadgeCategories>? unlockedBadges}) {
    return Rewards(
      points: points ?? this.points,
      unlockedBadges: unlockedBadges ?? this.unlockedBadges,
    );
  }
}

class RewardsNotifier extends StateNotifier<Rewards> {
  RewardsNotifier() : super(const Rewards());

  static const _badgeUnlockPoints = {
    BadgeCategories.firstStep: 100,
    BadgeCategories.weekWarrior: 500,
    BadgeCategories.ecoExpert: 1000,
    BadgeCategories.greenChampion: 2000,
  };

  // point increment function
  void increasePoints(ChallengeCategories category) {
    final int pointsToAdd = (category == ChallengeCategories.regular) ? 10 : 15;
    final int newPoints = state.points + pointsToAdd;

    final newUnlockedBadges = Set<BadgeCategories>.from(state.unlockedBadges);

    // badge unlock logic
    _badgeUnlockPoints.forEach((badge, pointsRequired) {
      if (newPoints >= pointsRequired) {
        newUnlockedBadges.add(badge);
      }
    });

    state = state.copyWith(
      points: newPoints,
      unlockedBadges: newUnlockedBadges,
    );
  }
}

final rewardsProvider = StateNotifierProvider<RewardsNotifier, Rewards>((ref) {
  return RewardsNotifier();
});
