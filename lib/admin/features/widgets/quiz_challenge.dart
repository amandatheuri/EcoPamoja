import 'package:ecopamoja/admin/features/dashboard/challenges/challenges_model.dart';
import 'package:ecopamoja/admin/features/dashboard/challenges/challenges_service.dart';
import 'package:flutter/material.dart';

class QuizChallengeManager extends StatelessWidget {
  const QuizChallengeManager({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<ChallengeModel>>(
      stream: ChallengeService.getAllChallenges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No quiz challenges found.'));
        }

        final actionChallenges = snapshot.data!
            .where((c) => c.type == ChallengeType.quiz)
            .toList();

        return ListView.builder(
          itemCount: actionChallenges.length,
          itemBuilder: (context, index) {
            final challenge = actionChallenges[index];

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              child: ListTile(
                title: Text(challenge.title),
                subtitle: Text(challenge.description),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () async {
                    await ChallengeService.deleteChallenge(challenge.id);
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
