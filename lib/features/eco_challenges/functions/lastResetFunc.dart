import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

Future<void> resetDailyCountersIfNeeded() async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
  final snapshot = await userRef.get();

  if (!snapshot.exists) return;
  final data = snapshot.data();

  // Get current local time
  final now = DateTime.now();
  // Get "start of today" in local time
  final todayStart = DateTime(now.year, now.month, now.day);


  final lastResetUtc = (data?['lastReset'] as Timestamp?)?.toDate();
  final lastResetLocal = lastResetUtc?.toLocal();

  // Compare using local dates
  if (lastResetLocal == null || lastResetLocal.isBefore(todayStart)) {
    await userRef.update({
      'quizzesCompleted': 0,
      'dailyHabitsCompleted': 0,
      'wasteReductionCompleted': 0,
      'lastReset': Timestamp.fromDate(todayStart.toUtc()), 
    });
    debugPrint('Daily counters reset for ${user.uid} (local midnight)');
  } else {
    debugPrint('Counters already up to date for today (local time).');
  }
}

Future<void> incrementCounter(String fieldName) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) return;

  final userRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
  final snapshot = await userRef.get();
  final data = snapshot.data();

  if (data == null) return;

  final currentValue = data[fieldName] ?? 0;
  const maxDaily = 3;

  if (currentValue < maxDaily) {
    await userRef.update({fieldName: currentValue + 1});
  }
}
