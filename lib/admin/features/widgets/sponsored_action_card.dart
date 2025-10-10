import 'package:ecopamoja/admin/features/challenges/models/sponsored_challenges.dart';
import 'package:ecopamoja/admin/features/challenges/services/sponsored_services_challenges.dart';
import 'package:ecopamoja/admin/features/widgets/edit_sponsored_action.dart';
import 'package:flutter/material.dart';

class SponsoredChallengeCard extends StatelessWidget {
  final SponsoredChallengesModel challenge;
  const SponsoredChallengeCard({super.key, required this.challenge});

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
   String getLogoUrl(String key) {
    return 'https://amandatheuri.github.io/ecopamoja-assets/logos/$key';
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
            /// Top row: Icon + Partner logo + Name
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Icon(
      IconData(challenge.iconCode ?? 0, fontFamily: challenge.iconFontFamily),
      size: 25,
      color: getColorByIconName(challenge.icon),
    ),
    const SizedBox(width: 8),
    ClipOval(
      child: Image.network(
        getLogoUrl(challenge.partnerLogoKey),
        width: 40,
        height: 40,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => const Icon(Icons.image_not_supported),
      ),
    ),
    const SizedBox(width: 8),
    Text(
        challenge.partnerName,
        style: Theme.of(context).textTheme.bodySmall,
        overflow: TextOverflow.ellipsis,
      ),
  ],
),

            ),

            const SizedBox(height: 8),
            Text(challenge.title,  style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 4),
            Text(challenge.description, maxLines: 2, overflow: TextOverflow.ellipsis),
            const Spacer(),
            /// Update + Delete buttons
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    showDialog(
  context: context,
  builder: (_) => EditSponsoredChallengeDialog(challenge: challenge),
);
                           },
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    SponsoredChallengeService.deleteSponsoredChallenge(challenge.id);
                  }
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
