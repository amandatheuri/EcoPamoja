// ignore_for_file: unrelated_type_equality_checks, use_build_context_synchronously

import 'package:ecopamoja/admin/features/challenges/models/challenges_model.dart';
import 'package:ecopamoja/admin/features/challenges/services/challenges_service.dart';
import 'package:ecopamoja/admin/features/widgets/quizEditDialog.dart';
import 'package:ecopamoja/theme_essentials/colors.dart';
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

        final quizChallenges = snapshot.data!
            .where((c) => c.type == ChallengeType.quiz)
            .toList();

       return LayoutBuilder(
  builder: (context, constraints) {
    final screenWidth = constraints.maxWidth;

    int crossAxisCount;
    if (screenWidth >= 1200) {
      crossAxisCount = 4;
    } else if (screenWidth >= 900) {
      crossAxisCount = 3;
    } else if (screenWidth >= 600) {
      crossAxisCount = 2;
    } else {
      crossAxisCount = 1;
    }

      return GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.4,
        ),
        itemCount: quizChallenges.length,
        itemBuilder: (context, index) {
          final challenge = quizChallenges[index];
          return Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    challenge.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Expanded(
                    child: ListView.builder(
                      itemCount: challenge.questions?.length ?? 0,
                      itemBuilder: (context, qIndex) {
                        final q = challenge.questions![qIndex];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 2),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Q: ${q.question}'),
                              const SizedBox(height: 4),
                              ...q.options.asMap().entries.map((entry) {
                                final index = entry.key;
                                final option = entry.value;
                                final isCorrect = index == q.correctAnswerIndex;

                                return Row(
                                  children: [
                                    Icon(
                                      isCorrect ? Icons.check_circle : Icons.radio_button_unchecked,
                                      size: 16,
                                      color: isCorrect ? Colors.green : Colors.grey,
                                    ),
                                    const SizedBox(width: 4),
                                    Flexible(child: Text(option)),
                                  ],
                                );
                              }),
                              const Divider(),
                              Row(
                                children: [
                                  IconButton(
  icon: const Icon(Icons.edit, color: Colors.blue),
  onPressed: () async {
    if (challenge.questions == null || challenge.questions!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ No quiz question to edit')),
      );
      return;
    }

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => EditQuizQuestionDialog(
        question: challenge.questions!.first,
        initialDurationSeconds: challenge.durationSeconds,
      ),
    );

    if (result != null) {
      final updatedQuestion = result['question'] as QuizQuestion;
      final updatedDuration = result['durationSeconds'] as int?;

      final updatedChallenge = ChallengeModel(
        id: challenge.id,
        title: challenge.title,
        description: challenge.description,
        type: challenge.type,
        createdAt: challenge.createdAt,
        questions: [updatedQuestion],
        durationSeconds: updatedDuration,
        dueDate: challenge.dueDate,
        points: challenge.points,
      );

      await ChallengeService.updateChallenge(updatedChallenge);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('✅ Quiz updated'), backgroundColor: AppColors.primary),
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
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );
    
  },
);
      },
    );
  }
}
  