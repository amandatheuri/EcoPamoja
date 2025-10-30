import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopamoja/features/authentication/models/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userDocProvider = StreamProvider<DocumentSnapshot>((ref) {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) {
    // Return an empty stream if not logged in
    return const Stream.empty();
  }

  // Listen to real-time changes
  return FirebaseFirestore.instance.collection('users').doc(uid).snapshots();
});

final userDataProvider = Provider<UserData?>((ref) {
  final snapshot = ref.watch(userDocProvider);

  return snapshot.when(
    data: (doc) {
      if (!doc.exists) return null;
      final data = doc.data() as Map<String, dynamic>?;

      if (data == null) return null;

      return UserData(
        uid: doc.id,
        email: data['email'] ?? '',
        username: data['username'] ?? '',
        photoUrl: data['photoUrl'],
        createdAt:
            (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        lastActive:
            (data['lastActive'] as Timestamp?)?.toDate() ?? DateTime.now(),
        lastReset:
            (data['lastReset'] as Timestamp?)?.toDate() ?? DateTime.now(),
        streak: data['streak'] ?? 0,
        isAdmin: data['isAdmin'] ?? false,
        quizzesCompleted: data['quizzesCompleted'] ?? 0,
        dailyHabitsCompleted: data['actionsCompleted'] ?? 0,
        totalChallengesCompleted: data['totalChallengesCompleted'] ?? 0,
        dailyGoal: data['dailyGoal'] ?? 3,
        todayChallengesCompleted: data['todayChallengesCompleted'] ?? 0,
        notificationsEnabled: data['notificationsEnabled'] ?? true,
        badgesEarned: List<String>.from(data['badgesEarned'] ?? []),
        completedSponsored: List<String>.from(data['completedSponsored'] ?? []),
        themeMode: data['themeMode'] ?? 'dark',
        hasSeenIntro: data['hasSeenIntro'] ?? false,
        groupsJoined: data['groupsJoined'] ?? 0,
        pointsEarned: data['pointsEarned'] ?? 0,
        wasteReductionCompleted: data['wasteReductionCompleted'] ?? 0,
      );
    },
    loading: () => null,
    error: (_, __) => null,
  );
});
