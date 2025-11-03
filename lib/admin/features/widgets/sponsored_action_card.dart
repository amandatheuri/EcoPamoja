import 'package:ecopamoja/admin/features/challenges/models/sponsored_challenges.dart';
import 'package:ecopamoja/admin/features/challenges/services/sponsored_services_challenges.dart';
import 'package:ecopamoja/admin/features/widgets/edit_sponsored_action.dart';
import 'package:flutter/material.dart';

class SponsoredChallengeCard extends StatelessWidget {
  final SponsoredChallengesModel challenge;
  const SponsoredChallengeCard({super.key, required this.challenge});

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
