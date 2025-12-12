// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopamoja/admin/features/challenges/models/challenges_model.dart';
import 'package:ecopamoja/admin/features/challenges/services/challenges_service.dart';
import 'package:ecopamoja/admin/features/widgets/editaction.dart';
import 'package:flutter/material.dart';

class RegularActionChallengeCard extends StatelessWidget {
  final ChallengeModel challenge;
  const RegularActionChallengeCard({super.key, required this.challenge});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(challenge.description, maxLines: 2, overflow: TextOverflow.ellipsis),
            const Spacer(),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () async {
                       final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => EditActionChallengeDialog(
        challenge: challenge,
      ),
    );

    if (result != null) {
      await FirebaseFirestore.instance
          .collection('challenges')
          .doc(challenge.id)
          .update(result);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Action challenge updated')),
      );
    }
  },
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await ChallengeService.deleteChallenge(challenge.id);
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
