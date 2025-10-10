import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopamoja/features/did_you_know/did_you_know.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final didYouKnowProvider = FutureProvider<List<DidYouKnowFact>>((ref) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('did_you_know_facts')
      .orderBy('createdAt', descending: true)
      .get();

  return snapshot.docs.map((doc) => DidYouKnowFact.fromFirestore(doc)).toList();
});
