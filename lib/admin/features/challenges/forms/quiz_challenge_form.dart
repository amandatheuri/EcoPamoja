// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopamoja/theme_essentials/textstyles.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddQuizChallengeDialog extends StatefulWidget {
  const AddQuizChallengeDialog({super.key});
  @override
  State<AddQuizChallengeDialog> createState() => _AddQuizChallengeDialogState();
}

class _AddQuizChallengeDialogState extends State<AddQuizChallengeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _questionController = TextEditingController();
  final _dailyLimitController = TextEditingController(text: '1');
  final _dueDateController = TextEditingController();
  DateTime? _selectedDueDate;
  int _durationSeconds = 60;

  final List<TextEditingController> _options =
      List.generate(4, (_) => TextEditingController());
  int _correctAnswerIndex = 0;
  bool _isSubmitting = false;

  Future<void> _pickDueDateTime() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );
    if (date == null) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return;
    final fullDateTime =
        DateTime(date.year, date.month, date.day, time.hour, time.minute);
    setState(() {
      _selectedDueDate = fullDateTime;
      _dueDateController.text =
          DateFormat('MMM dd, yyyy hh:mm a').format(fullDateTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: ConstrainedBox(
        constraints: const BoxConstraints(
          maxWidth: 600, 
          maxHeight: 600, 
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add Quiz Challenge',
                  style: AppTextStyles.title.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildField('Title', _titleController),
                                  const SizedBox(height: 10),
                      _buildField('Question', _questionController),
                                  const SizedBox(height: 10),
                      ...List.generate(4, (index) {
                        return _buildField('Option ${index + 1}', _options[index]);
                      }),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<int>(
                        value: _correctAnswerIndex,
                        items: List.generate(
                          4,
                          (index) => DropdownMenuItem(
                            value: index,
                            child: Text('Correct Option ${index + 1}'),
                          ),
                        ),
                        onChanged: (value) => setState(() {
                          _correctAnswerIndex = value!;
                        }),
                        decoration: const InputDecoration(
                          labelText: 'Correct Option',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<int>(
                        value: _durationSeconds,
                        items: const [
                          DropdownMenuItem(value: 30, child: Text('30 seconds')),
                          DropdownMenuItem(value: 60, child: Text('60 seconds')),
                          DropdownMenuItem(value: 90, child: Text('90 seconds')),
                          DropdownMenuItem(value: 120, child: Text('120 seconds')),
                        ],
                        onChanged: (value) => setState(() {
                          if (value != null) {
                            _durationSeconds = value;
                          }
                        }),
                        decoration: const InputDecoration(
                          labelText: 'Quiz Duration',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildField(
                        'Daily Limit',
                        _dailyLimitController,
                        inputType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) return 'Required';
                          final num = int.tryParse(value);
                          if (num == null || num < 1) return 'Must be ≥ 1';
                          return null;
                        },
                      ),
                                  const SizedBox(height: 10),
                      GestureDetector(
                        onTap: _pickDueDateTime,
                        child: AbsorbPointer(
                          child: _buildField(
                            'Due Date (pick date & time)',
                            _dueDateController,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isSubmitting ? null : () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _isSubmitting ? null : _submitQuiz,
                      child: _isSubmitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Add'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitQuiz() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final question = {
        'question': _questionController.text.trim(),
        'options': _options.map((c) => c.text.trim()).toList(),
        'correctAnswerIndex': _correctAnswerIndex,
      };

      await FirebaseFirestore.instance.collection('challenges').add({
        'title': _titleController.text.trim(),
        'type': 'quiz',
        'createdAt': FieldValue.serverTimestamp(),
        'questions': [question],
        'durationSeconds': _durationSeconds,
        'dueDate': _selectedDueDate,
        'daily_limit': int.parse(_dailyLimitController.text),
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Quiz Challenge Added')),
        );
      }
    } catch (e) {
      debugPrint('🔥 Quiz submission error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    TextInputType inputType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: validator ??
            (value) =>
                value == null || value.trim().isEmpty ? 'Required' : null,
      ),
    );
  }
}