import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopamoja/features/authentication/models/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userDocProvider = FutureProvider<DocumentSnapshot>((ref) async {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) throw Exception('User not logged in');

  final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
  if (!doc.exists) {
    throw Exception('User document does not exist');
  }

  return doc;
});

final userDataProvider = Provider<UserData?>((ref) {
  final snapshot = ref.watch(userDocProvider);
  return snapshot.when(
    data: (doc) {
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) return null;
      return UserData(
  uid: data['uid'] ?? '',
  email: data['email'] ?? '',
  username: data['username'] ?? '',
  photoUrl: data['photoUrl'],
  createdAt: data['createdAt']?.toDate(),
  lastActive: data['lastActive']?.toDate(),
  streak: data['streak'] ?? 0,
  isAdmin: data['isAdmin'] ?? false,
  medalCount: data['medalCount'] ?? 0,
  trophiesEarned: data['trophiesEarned'] ?? 0,
  ecoWarrior: data['ecoWarrior'] ?? false,
  quizzesCompleted: data['quizzesCompleted'] ?? 0,
  actionsCompleted: data['actionsCompleted'] ?? 0,
  totalChallengesCompleted: data['totalChallengesCompleted'] ?? 0,
  dailyGoal: data['dailyGoal'] ?? 3,
  todayChallengesCompleted: data['todayChallengesCompleted'] ?? 0,
  completedChallenges: List<String>.from(data['completedChallenges'] ?? []),
  notificationsEnabled: data['notificationsEnabled'] ?? true,
  preferredCategories: List<String>.from(data['preferredCategories'] ?? []),
  themeMode: data['themeMode'] ?? 'system',
  hasSeenIntro: data['hasSeenIntro'] ?? false,
);

    },
    loading: () => null,
    error: (_, _) => null,
  );
});