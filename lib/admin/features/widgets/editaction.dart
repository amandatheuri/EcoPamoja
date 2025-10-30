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
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _dailyLimitController;

  late DateTime? _selectedDueDate;
  late String? _selectedIcon;
  bool _isSubmitting = false;
  
final availableIcons = <Map<String, dynamic>>[
    {'name': 'Nature', 'icon': Icons.nature},
    {'name': 'Recycle', 'icon': Icons.recycling},
    {'name': 'Eco', 'icon': Icons.eco},
    {'name': 'Park', 'icon': Icons.park},
    {'name': 'Bike', 'icon': Icons.pedal_bike},
    {'name': 'Water', 'icon': Icons.water_drop},
    {'name': 'Energy', 'icon': Icons.bolt},
    {'name': 'Clean', 'icon': Icons.cleaning_services},
    {'name': 'Leaf', 'icon': Icons.spa},
    {'name': 'Tree', 'icon': Icons.forest},
    {'name': 'Lightbulb', 'icon': Icons.lightbulb},
    {'name': 'Compost', 'icon': Icons.compost},
    {'name': 'Air', 'icon': Icons.air},
    {'name': 'Garden', 'icon': Icons.yard},
    {'name': 'Electric Car', 'icon': Icons.electric_car},
    {'name': 'Solar Power', 'icon': Icons.solar_power},
    {'name': 'Wind Power', 'icon': Icons.wind_power},
    {'name': 'Fireplace', 'icon': Icons.fireplace},
    {'name': 'Trash', 'icon': Icons.delete_outline},
    {'name': 'Cloud', 'icon': Icons.cloud},
    {'name': 'Flower', 'icon': Icons.local_florist},
    {'name': 'Hand Wash', 'icon': Icons.soap},
    {'name': 'Plant', 'icon': Icons.grass},
    {'name': 'Globe', 'icon': Icons.public},
    {'name': 'Heart', 'icon': Icons.favorite},
    {'name': 'Shield', 'icon': Icons.shield},
    {'name': 'Star', 'icon': Icons.star},
    {'name': 'Check Circle', 'icon': Icons.check_circle},
    {'name': 'Warning', 'icon': Icons.warning},
  ];
 @override
void initState() {
  super.initState();
  _titleController = TextEditingController(text: widget.challenge.title);
  _descriptionController = TextEditingController(text: widget.challenge.description);
  _selectedDueDate = widget.challenge.dueDate;
  _selectedIcon = widget.challenge.icon;

 
}

  Future<void> _submitUpdate() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    try {
      final updatedIcon = availableIcons.firstWhere((icon) => icon['name'] == _selectedIcon);

      await FirebaseFirestore.instance
          .collection('challenges')
          .doc(widget.challenge.id)
          .update({
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'daily_limit': int.parse(_dailyLimitController.text),
        'dueDate': _selectedDueDate,
        'icon': updatedIcon['name'],
        'iconCode': updatedIcon['icon'].codePoint,
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
            _buildField('Title', _titleController),
            const SizedBox(height: 10),
            _buildField('Description', _descriptionController, maxLines: 3),
                        const SizedBox(height: 10),
            _buildField('Daily Limit', _dailyLimitController, inputType: TextInputType.number),

            const SizedBox(height: 12),
            _buildDueDatePicker(),

            const SizedBox(height: 12),
            _buildIconDropdown(),
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
Widget _buildIconDropdown() {
  return DropdownButtonFormField<String>(
    value: _selectedIcon,
    decoration: const InputDecoration(
      labelText: 'Icon',
      border: OutlineInputBorder(),
    ),
    items: availableIcons.map<DropdownMenuItem<String>>((iconMap) {
      return DropdownMenuItem<String>(
        value: iconMap['name'],
        child: Row(
          children: [
            Icon(iconMap['icon'], color: Colors.green),
            const SizedBox(width: 8),
            Text(iconMap['name']),
          ],
        ),
      );
    }).toList(),
    onChanged: (value) {
      setState(() {
        _selectedIcon = value;
      });
    },
    validator: (value) =>
        value == null || value.isEmpty ? 'Please select an icon' : null,
  );
}

}
