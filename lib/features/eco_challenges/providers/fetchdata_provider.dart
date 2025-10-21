import 'package:cloud_firestore/cloud_firestore.dart';
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