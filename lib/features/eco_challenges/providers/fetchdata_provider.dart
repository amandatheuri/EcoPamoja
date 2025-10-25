import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

//provide sponsored challenges from firestore sponsored_challenges
//the value will change over time 

final sponsoredChallengesProvider = StreamProvider.autoDispose((ref) {
  final firestore = FirebaseFirestore.instance;
  return firestore
	  .collection('sponsored_challenges')
	  .snapshots()
	  .map((snapshot) => snapshot.docs.map((doc) => doc.data()).toList());
});
final dailyProgressProvider = StreamProvider<Map<String, int>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return const Stream.empty();

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .snapshots()
      .map((doc) {
        final data = doc.data();
        return {
          'quizzes': data?['quizzesCompleted'] ?? 0,
          'habits': data?['dailyHabitsCompleted'] ?? 0,
          'waste': data?['wasteReductionCompleted'] ?? 0,
        };
      });
});

final newChallengesProvider = FutureProvider<int>((ref) async {
  final now = DateTime.now();
  final todayStart = DateTime(now.year, now.month, now.day);

  try {
    // Query all challenges of type 'quiz' created today
    final snapshot = await FirebaseFirestore.instance
        .collection('challenges')
        .where('type', isEqualTo: 'quiz')
        .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(todayStart))
        .get();

    // Return the count directly
    return snapshot.docs.length;
  } catch (e) {
    if (kDebugMode) {
      print('🔥 Error fetching challenges: $e');
    }
    rethrow;
  }
});
