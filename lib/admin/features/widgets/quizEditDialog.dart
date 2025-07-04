// ignore_for_file: file_names

import 'package:ecopamoja/admin/features/challenges/models/challenges_model.dart';
import 'package:flutter/material.dart';

class EditQuizQuestionDialog extends StatefulWidget {
  final QuizQuestion question;
  final int? initialDurationSeconds;
  final int? initialMaxAttemptsPerDay;

  const EditQuizQuestionDialog({
    super.key,
    required this.question,
    this.initialDurationSeconds,
    this.initialMaxAttemptsPerDay,
  });

  @override
  State<EditQuizQuestionDialog> createState() => _EditQuizQuestionDialogState();
}

class _EditQuizQuestionDialogState extends State<EditQuizQuestionDialog> {
  late TextEditingController questionController;
  late List<TextEditingController> optionControllers;
  late int correctAnswerIndex;

  late TextEditingController _durationController;
  late TextEditingController _limitController;

  @override
  void initState() {
    super.initState();
    questionController = TextEditingController(text: widget.question.question);
    optionControllers = widget.question.options
        .map((opt) => TextEditingController(text: opt))
        .toList();
    correctAnswerIndex = widget.question.correctAnswerIndex;

    _durationController = TextEditingController(
      text: widget.initialDurationSeconds?.toString() ?? '60',
    );
    _limitController = TextEditingController(
      text: widget.initialMaxAttemptsPerDay?.toString() ?? '1',
    );
  }

  @override
  void dispose() {
    questionController.dispose();
    for (var c in optionControllers) {
      c.dispose();
    }
    _durationController.dispose();
    _limitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Quiz Question'),
      content: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 500,
            maxHeight: 600,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: questionController,
                decoration: const InputDecoration(labelText: 'Question'),
              ),
              const SizedBox(height: 10),
              ...List.generate(optionControllers.length, (index) {
                return ListTile(
                  leading: Radio<int>(
                    value: index,
                    groupValue: correctAnswerIndex,
                    onChanged: (val) {
                      setState(() {
                        correctAnswerIndex = val!;
                      });
                    },
                  ),
                  title: TextField(
                    controller: optionControllers[index],
                    decoration: InputDecoration(labelText: 'Option ${index + 1}'),
                  ),
                );
              }),
              const SizedBox(height: 12),
              TextField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Timer Duration (seconds)',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _limitController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Max Attempts per Day',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: const Text('Save'),
          onPressed: () {
            final updated = QuizQuestion(
              question: questionController.text,
              options: optionControllers.map((c) => c.text).toList(),
              correctAnswerIndex: correctAnswerIndex,
            );

            final int? updatedDuration = int.tryParse(_durationController.text);
            final int? updatedLimit = int.tryParse(_limitController.text);

            Navigator.pop(context, {
              'question': updated,
              'durationSeconds': updatedDuration,
              'maxAttemptsPerDay': updatedLimit,
            });
          },
        ),
      ],
    );
  }
}
