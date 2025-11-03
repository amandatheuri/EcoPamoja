import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopamoja/theme_essentials/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddActionChallengeDialog extends StatefulWidget {
  const AddActionChallengeDialog({super.key});

  @override
  State<AddActionChallengeDialog> createState() => _AddActionChallengeDialogState();
}

class _AddActionChallengeDialogState extends State<AddActionChallengeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _dailyLimitController = TextEditingController(text: '1');
  final _dueDateController = TextEditingController();
  final _searchController = TextEditingController();

  DateTime? _selectedDueDate;
  bool _isSubmitting = false;

   @override
  void initState() {
    super.initState();
  }
  @override
  void dispose() {
    _descriptionController.dispose();
    _dailyLimitController.dispose();
    _dueDateController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _pickDueDateTime() async {
    try {
      final date = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
        initialDate: DateTime.now(),
      );
      if (date == null || !mounted) return;

      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (time == null || !mounted) return;

      final fullDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
      if (mounted) {
        setState(() {
          _selectedDueDate = fullDateTime;
          _dueDateController.text = DateFormat('MMM dd, yyyy hh:mm a').format(fullDateTime);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Date picker error: ${e.toString()}'),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 40),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 600,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add Action Challenge',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 20),
                ),
                const SizedBox(height: 16),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      _buildField('Description', _descriptionController, maxLines: 3),
                      const SizedBox(height: 10),
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
                          child: _buildField('Due Date (pick date & time)', _dueDateController),
                        ),
                      ),
                      const SizedBox(height: 12),
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
                      onPressed: _isSubmitting ? null : _submitForm,
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
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

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate() || !mounted) return;

    setState(() => _isSubmitting = true);

    try {
      await FirebaseFirestore.instance.collection('challenges').add({
        'description': _descriptionController.text.trim(),
        'type': 'dailyHabits',
        'createdAt': FieldValue.serverTimestamp(),
        'daily_limit': int.parse(_dailyLimitController.text),
        'dueDate': _selectedDueDate,
        'questions': [],
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Action Challenge Added'),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    } catch (e, stack) {
      debugPrint('Submission Error: $e\n$stack');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
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
}
