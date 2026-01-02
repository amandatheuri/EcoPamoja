import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> updateUserStreak(String userId) async {
  final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
  final userDoc = await userRef.get();

  if (!userDoc.exists) return;

  final data = userDoc.data()!;
  final lastActive =
      (data['lastActive'] as Timestamp?)?.toDate() ?? DateTime.now();
  final today = DateTime.now();

  final lastDate =
      DateTime(lastActive.year, lastActive.month, lastActive.day);
  final currentDate =
      DateTime(today.year, today.month, today.day);

  final difference = currentDate.difference(lastDate).inDays;
  int streak = data['streak'] ?? 0;

  if (difference == 1) {
    streak += 1;
  } else if (difference > 1) {
    streak = 1; 
  }
  await userRef.update({
    'streak': streak,
    'lastActive': Timestamp.fromDate(today),
  });
}
