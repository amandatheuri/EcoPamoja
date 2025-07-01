import 'package:flutter/material.dart';
import 'package:ecopamoja/theme_essentials/textstyles.dart';

class AddQuizChallengeDialog extends StatefulWidget {
  const AddQuizChallengeDialog({super.key});

  @override
  State<AddQuizChallengeDialog> createState() => _AddQuizChallengeDialogState();
}

class _AddQuizChallengeDialogState extends State<AddQuizChallengeDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _questionController = TextEditingController();
  final List<TextEditingController> _options = List.generate(4, (_) => TextEditingController());
  int _correctAnswerIndex = 0;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Quiz Challenge', style: AppTextStyles.title),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildField('Title', _titleController),
              _buildField('Question', _questionController),
              ...List.generate(4, (index) {
                return _buildField('Option ${index + 1}', _options[index]);
              }),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: _correctAnswerIndex,
                items: List.generate(4, (index) => DropdownMenuItem(value: index, child: Text('Option ${index + 1}'))),
                onChanged: (value) => setState(() => _correctAnswerIndex = value ?? 0),
                decoration: InputDecoration(labelText: 'Correct Option', border: OutlineInputBorder()),
              )
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.pop(context);
            }
          },
          child: const Text('Add'),
        )
      ],
    );
  }

  Widget _buildField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
        validator: (value) => value == null || value.trim().isEmpty ? 'Required' : null,
      ),
    );
  }
}
