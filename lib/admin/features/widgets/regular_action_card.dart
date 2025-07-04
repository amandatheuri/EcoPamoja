// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopamoja/admin/features/challenges/models/challenges_model.dart';
import 'package:ecopamoja/admin/features/challenges/services/challenges_service.dart';
import 'package:ecopamoja/admin/features/widgets/editaction.dart';
import 'package:ecopamoja/theme_essentials/textstyles.dart';
import 'package:flutter/material.dart';

class RegularActionChallengeCard extends StatelessWidget {
  final ChallengeModel challenge;
  const RegularActionChallengeCard({super.key, required this.challenge});

  Color getColorByIconName(String? name) {
    switch (name) {
      case 'Nature': return Colors.green.shade700;
    case 'Recycle': return Colors.green;
    case 'Eco': return Colors.teal;
    case 'Park': return Colors.green.shade600;
    case 'Bike': return Colors.deepPurple;
    case 'Water': return Colors.blue;
    case 'Energy': return Colors.amber;
    case 'Clean': return Colors.orangeAccent;
    case 'Leaf': return Colors.lightGreen;
    case 'Tree': return Colors.green.shade800;
    case 'Lightbulb': return Colors.yellow.shade700;
    case 'Compost': return Colors.brown.shade400;
    case 'Air': return Colors.cyan;
    case 'Garden': return Colors.green.shade400;
    case 'Electric Car': return Colors.indigo;
    case 'Solar Power': return Colors.orange;
    case 'Wind Power': return Colors.lightBlueAccent;
    case 'Fireplace': return Colors.redAccent;
    case 'Trash': return Colors.grey;
    case 'Cloud': return Colors.blueGrey;
    case 'Flower': return Colors.pinkAccent;
    case 'Hand Wash': return Colors.lightBlue;
    case 'Plant': return Colors.greenAccent;
    case 'Globe': return Colors.blue.shade800;
    case 'Heart': return Colors.red;
    case 'Shield': return Colors.blueGrey.shade700;
    case 'Star': return Colors.amber;
    case 'Check Circle': return Colors.green.shade500;
    case 'Warning': return Colors.deepOrange;
    default: return Colors.grey;
    }
  }

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
            Center(
              child: Icon(
                IconData(challenge.iconCode ?? 0, fontFamily: challenge.iconFontFamily),
                size: 25,
                color: getColorByIconName(challenge.icon),
              ),
            ),
            const SizedBox(height: 8),
            Text(challenge.title, style: AppTextStyles.subHeading),
            const SizedBox(height: 4),
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
