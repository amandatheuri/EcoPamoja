// ignore_for_file: prefer_function_declarations_over_variables, use_function_type_syntax_for_parameters

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopamoja/admin/features/challenges/models/challenges_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// StreamProvider for sponsored challenges
final sponsoredChallengesProvider = StreamProvider.autoDispose((ref) {
  final firestore = FirebaseFirestore.instance;

  return firestore
      .collection('sponsored_challenges')
      .snapshots()
      .map((snapshot) => snapshot.docs.map((doc) {
            final data = doc.data();
            return {
              'id': doc.id,
              ...data,
            };
          }).toList());
});

// StreamProvider for user's daily progress
final dailyProgressProvider = StreamProvider<Map<String, int>>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return const Stream.empty();

  return FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .snapshots()
      .map((doc) {
        final data = doc.data() ?? {};
        return {
          'quizzes': data['quizzesCompleted'] ?? 0,
          'habits': data['dailyHabitsCompleted'] ?? 0,
          'waste': data['wasteReductionCompleted'] ?? 0,
        };
      });
});

// FutureProvider for new challenges created today
final newChallengesProvider = FutureProvider<int>((ref) async {
  final now = DateTime.now();
  final todayStart = DateTime(now.year, now.month, now.day);

  try {
    final snapshot = await FirebaseFirestore.instance
        .collection('challenges')
        .where('type', isEqualTo: 'quiz')
        .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(todayStart))
        .get();

    return snapshot.docs.length;
  } catch (e) {
    if (kDebugMode) {
      print('Error fetching challenges: $e');
    }
    rethrow;
  }
});

// FutureProvider for dailyhabits challenges 
final dailyHabitsProvider = StreamProvider.autoDispose<List<ChallengeModel>>((ref){
final firestore = FirebaseFirestore.instance;
return firestore
.collection('challenges')
.where('type', isEqualTo: 'dailyHabits')
.snapshots()
.map((snapshot){
  return snapshot.docs
  .map((doc)=>ChallengeModel.fromFirestore(doc))
  .toList();
});
});

