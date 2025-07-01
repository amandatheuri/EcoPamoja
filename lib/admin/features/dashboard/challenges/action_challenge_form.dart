// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ecopamoja/theme_essentials/textstyles.dart';

class AddActionChallengeDialog extends StatefulWidget {
  const AddActionChallengeDialog({super.key});

  @override
  State<AddActionChallengeDialog> createState() => _AddActionChallengeDialogState();
}

class _AddActionChallengeDialogState extends State<AddActionChallengeDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Action Challenge', style: AppTextStyles.title),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildField('Title', _titleController),
              _buildField('Description', _descriptionController),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
  if (_formKey.currentState!.validate()) {
    await FirebaseFirestore.instance.collection('challenges').add({
      'title': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'type': 'action',
      'createdAt': FieldValue.serverTimestamp(),
      'daily_limit': 1, // default value for action challenge
      'questions': [], // empty for action
      'dueDate': null, // optional for action
    });

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Action Challenge Added')),
    );
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
