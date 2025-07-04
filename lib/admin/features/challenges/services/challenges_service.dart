import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopamoja/admin/features/challenges/models/challenges_model.dart';

class ChallengeService {
  static final _challengesRef = FirebaseFirestore.instance.collection('challenges');

  static Stream<List<ChallengeModel>> getAllChallenges() {
    return _challengesRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => ChallengeModel.fromFirestore(doc)).toList());
  }

  static Future<void> addChallenge(ChallengeModel challenge) async {
    await _challengesRef.add(challenge.toFirestore());
  }

  static Future<void> deleteChallenge(String id) async {
    await _challengesRef.doc(id).delete();
  }

  static Future<void> updateChallenge(ChallengeModel challenge) async {
    await _challengesRef.doc(challenge.id).update(challenge.toFirestore());
  }
}
