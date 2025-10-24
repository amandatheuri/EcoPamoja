// challenge categories enum
enum ChallengeCategories { regular, sponsored }

enum BadgeCategories { firstStep, weekWarrior, ecoExpert, greenChampion }

class Rewards {
  // reward variables
  int points = 0;
  bool unlocked = false;
  BadgeCategories badgeCategory = BadgeCategories.firstStep;
  bool category = true;

  // point increment function
  int increasePoints() {
    if (category == ChallengeCategories.regular) {
      points += 10;
    } else if (category == ChallengeCategories.sponsored) {
      points += 15;
    }
    return points;
  }

  // badge unlock function
  bool unlockBadge(int points) {
    switch (badgeCategory) {
      case BadgeCategories.firstStep:
        if (points == 100) unlocked = true;
        break;
      case BadgeCategories.weekWarrior:
        if (points == 500) unlocked = true;
        break;
      case BadgeCategories.ecoExpert:
        if (points == 1000) unlocked = true;
        break;
      case BadgeCategories.greenChampion:
        if (points == 2000) unlocked = true;
        break;
    }
    return unlocked;
  }
}
