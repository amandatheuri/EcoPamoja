import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Defines the available badges.
enum BadgeCategories { firstStep, weekWarrior, ecoExpert, greenChampion }

// Provides display names for each badge.
final badgeDisplayNames = {
  BadgeCategories.firstStep: "First Step",
  BadgeCategories.weekWarrior: "Week Warrior",
  BadgeCategories.ecoExpert: "Eco Expert",
  BadgeCategories.greenChampion: "Green Champion",
};

// Represents the user's rewards state, synced with Firestore.
class Rewards {
  final int points;
  final Set<BadgeCategories> unlockedBadges;
  final int streak;
  final DateTime? lastActive;
  final int quizCount;

  const Rewards({
    this.points = 0,
    this.unlockedBadges = const {},
    this.streak = 0,
    this.lastActive,
    this.quizCount = 0,
  });

  Rewards copyWith({
    int? points,
    Set<BadgeCategories>? unlockedBadges,
    int? streak,
    DateTime? lastActive,
    int? quizCount,
  }) => Rewards(
    points: points ?? this.points,
    unlockedBadges: unlockedBadges ?? this.unlockedBadges,
    streak: streak ?? this.streak,
    lastActive: lastActive ?? this.lastActive,
    quizCount: quizCount ?? this.quizCount,
  );
}

// Notifier for managing the Rewards state, now synced with Firestore.
class RewardsNotifier extends StateNotifier<Rewards> {
  RewardsNotifier() : super(const Rewards()) {
    // If a user is logged in when the app starts, load their data.
    if (FirebaseAuth.instance.currentUser != null) {
      _loadStateFromFirestore();
    }
  }

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // A helper to get the current user's document reference.
  DocumentReference<Map<String, dynamic>>? get _userDocRef {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _firestore.collection('users').doc(user.uid);
  }

  // Loads the user's rewards data from their Firestore document.
  Future<void> _loadStateFromFirestore() async {
    final docRef = _userDocRef;
    if (docRef == null) return;

    final doc = await docRef.get();
    if (!doc.exists || doc.data() == null) return;

    final data = doc.data()!;
    final badges = (data['badgesEarned'] as List<dynamic>? ?? [])
        .map(
          (e) => BadgeCategories.values.firstWhere(
            (b) => b.toString() == e.toString(),
          ),
        )
        .toSet();
    final lastActiveTimestamp = data['lastActive'] as Timestamp?;

    state = Rewards(
      points: data['pointsEarned'] ?? 0,
      unlockedBadges: badges,
      streak: data['streak'] ?? 0,
      lastActive: lastActiveTimestamp?.toDate(),
      quizCount: data['quizzesCompleted'] ?? 0,
    );
  }

  // Checks in for the day and updates the streak in Firestore.
  Future<void> checkIn() async {
    final now = DateTime.now();
    final last = state.lastActive;
    int newStreak = state.streak;

    // Return early if an update has already occurred today.
    if (last != null &&
        last.year == now.year &&
        last.month == now.month &&
        last.day == now.day) {
      return;
    }

    // Calculate the new streak based on the 'lastActive' date.
    if (last != null) {
      final today = DateTime(now.year, now.month, now.day);
      final lastDay = DateTime(last.year, last.month, last.day);
      final difference = today.difference(lastDay).inDays;

      if (difference == 1) {
        newStreak++; // Consecutive day
      } else if (difference > 1) {
        newStreak = 1; // Streak is broken
      }
    } else {
      newStreak = 1; // First-ever activity
    }

    final updatedBadges = {...state.unlockedBadges};
    if (newStreak >= 7) updatedBadges.add(BadgeCategories.weekWarrior);
    if (newStreak >= 30) updatedBadges.add(BadgeCategories.greenChampion);

    // Update the local state for immediate UI feedback.
    state = state.copyWith(
      streak: newStreak,
      lastActive: now,
      unlockedBadges: updatedBadges,
    );

    // Persist changes to Firestore.
    final docRef = _userDocRef;
    if (docRef == null) return;
    await docRef.update({
      'streak': newStreak,
      'lastActive': now, // Update the lastActive field
      'badgesEarned': updatedBadges.map((b) => b.toString()).toList(),
    });
  }

  // Updates state after a quiz is completed and syncs with Firestore.
  Future<void> quizCompleted() async {
    final newQuizCount = state.quizCount + 1;
    final newPoints = state.points + 10;
    final updatedBadges = {...state.unlockedBadges};

    if (newQuizCount >= 10) {
      updatedBadges.add(BadgeCategories.ecoExpert);
    }

    // Update local state.
    state = state.copyWith(
      points: newPoints,
      quizCount: newQuizCount,
      unlockedBadges: updatedBadges,
    );

    // Persist changes to Firestore.
    final docRef = _userDocRef;
    if (docRef == null) return;
    await docRef.update({
      'pointsEarned': newPoints,
      'quizzesCompleted': newQuizCount,
      'badgesEarned': updatedBadges.map((b) => b.toString()).toList(),
    });
  }
}

// Provides the RewardsNotifier to the app.
final rewardsProvider = StateNotifierProvider<RewardsNotifier, Rewards>(
  (_) => RewardsNotifier(),
);
