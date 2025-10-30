import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> updateUserStreak(String userId) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
  final userDoc = await userRef.get();

  if (!userDoc.exists) return;

  final data = userDoc.data()!;
  final lastActive = (data['lastActive'] as Timestamp).toDate();
  final today = DateTime.now();

  final lastDate = DateTime(lastActive.year, lastActive.month, lastActive.day);
  final currentDate = DateTime(today.year, today.month, today.day);

  final difference = currentDate.difference(lastDate).inDays;
  int streak = data['streak'] ?? 0;

  if (difference == 0) {
    // active today 
    return;
  } else if (difference == 1) {
    //Continued streak
    streak += 1;
  } else {
    // Missed one or more days
    streak = 1;
  }

  //Update Firestore once, after logic completes
  await userRef.update({
    'streak': streak,
    'lastActive': today,
  });
}
