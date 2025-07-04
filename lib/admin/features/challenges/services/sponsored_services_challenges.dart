import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopamoja/admin/features/challenges/models/sponsored_challenges.dart';

class SponsoredChallengeService {
  static final _ref = FirebaseFirestore.instance.collection('sponsored_challenges');

  static Stream<List<SponsoredChallengesModel>> getAllSponsoredChallenges() {
    return _ref.snapshots().map((snap) =>
        snap.docs.map((doc) => SponsoredChallengesModel.fromDoc(doc)).toList());
  }

  static Future<void> deleteSponsoredChallenge(String id) {
    return _ref.doc(id).delete();
  }

  static Future<void> updateSponsoredChallenge(String id, Map<String, dynamic> data) {
    return _ref.doc(id).update(data);
  }
}
