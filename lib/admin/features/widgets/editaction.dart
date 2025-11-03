// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopamoja/admin/features/challenges/models/challenges_model.dart';
import 'package:flutter/material.dart';

class EditActionChallengeDialog extends StatefulWidget {
  final ChallengeModel challenge;

  const EditActionChallengeDialog({super.key, required this.challenge});

  @override
  State<EditActionChallengeDialog> createState() => _EditActionChallengeDialogState();
}

class _EditActionChallengeDialogState extends State<EditActionChallengeDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _descriptionController;
  late TextEditingController _dailyLimitController;

  late DateTime? _selectedDueDate;
  bool _isSubmitting = false;
 @override
void initState() {
  super.initState();
  _descriptionController = TextEditingController(text: widget.challenge.description);
  _selectedDueDate = widget.challenge.dueDate;

 
}

  Future<void> _submitUpdate() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    try {

      await FirebaseFirestore.instance
          .collection('challenges')
          .doc(widget.challenge.id)
          .update({
        'description': _descriptionController.text.trim(),
        'daily_limit': int.parse(_dailyLimitController.text),
        'dueDate': _selectedDueDate,
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Challenge updated successfully')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating: $e')),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  // reuse _buildField, _pickDueDateTime from your Add dialog...

 @override
Widget build(BuildContext context) {
  return AlertDialog(
    title: const Text('Edit Action Challenge'),
    content: SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 10),
            _buildField('Description', _descriptionController, maxLines: 3),
                        const SizedBox(height: 10),
            _buildField('Daily Limit', _dailyLimitController, inputType: TextInputType.number),

            const SizedBox(height: 12),
            _buildDueDatePicker(),

            const SizedBox(height: 12),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: _isSubmitting ? null : () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      ElevatedButton(
        onPressed: _isSubmitting ? null : _submitUpdate,
        child: _isSubmitting
            ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
            : const Text('Update'),
      ),
    ],
  );
}

  Widget _buildField(
    String label, 
    TextEditingController controller, {
    int maxLines = 1, 
    TextInputType inputType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label, 
          border: const OutlineInputBorder(),
        ),
        validator: validator ?? (value) => 
          value == null || value.trim().isEmpty ? 'Required' : null,
      ),
    );
  }
  Widget _buildDueDatePicker() {
  return ListTile(
    title: const Text('Due Date'),
    subtitle: Text(
      _selectedDueDate != null
          ? _selectedDueDate!.toLocal().toString().split(' ')[0]
          : 'Select a date',
    ),
    trailing: const Icon(Icons.calendar_today),
    onTap: () async {
      final picked = await showDatePicker(
        context: context,
        initialDate: _selectedDueDate ?? DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        setState(() {
          _selectedDueDate = picked;
        });
      }
    },
  );
}
}
