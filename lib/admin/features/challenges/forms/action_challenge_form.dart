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
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dailyLimitController = TextEditingController(text: '1');
  final _dueDateController = TextEditingController();
  final _searchController = TextEditingController();

  DateTime? _selectedDueDate;
  bool _isSubmitting = false;
  String? _selectedIcon;
   List<Map<String, dynamic>> _filteredIcons = [];

  final List<Map<String, dynamic>> availableIcons = [
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
    _filteredIcons = availableIcons;
    _searchController.addListener(_filterIcons);
  }
  void _filterIcons() {
    setState(() {
      _filteredIcons = availableIcons.where((icon) =>
        icon['name'].toLowerCase().contains(_searchController.text.toLowerCase())
      ).toList();
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
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
                      _buildField('Title', _titleController),
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
                      _buildIconDropdown(),
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
      final selectedIcon = availableIcons.firstWhere(
        (icon) => icon['name'] == _selectedIcon,
        orElse: () => availableIcons.first,
      );

      await FirebaseFirestore.instance.collection('challenges').add({
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'type': 'action',
        'createdAt': FieldValue.serverTimestamp(),
        'daily_limit': int.parse(_dailyLimitController.text),
        'dueDate': _selectedDueDate,
        'questions': [],
        'icon': selectedIcon['name'],
        'iconCode': selectedIcon['icon'].codePoint,
        'iconFontFamily': selectedIcon['icon'].fontFamily ?? 'MaterialIcons',
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Action Challenge Added'),
            backgroundColor: AppColors.primary,
          ),
        );
      }
    } catch (e, stack) {
      debugPrint('🔥 Submission Error: $e\n$stack');
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
   Widget _buildIconDropdown() {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      menuMaxHeight: 200,
      decoration: InputDecoration(
        labelText: 'Select Icon',
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        prefixIcon: const Icon(Icons.search),
        suffixIcon: _searchController.text.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear, size: 20),
                onPressed: () {
                  _searchController.clear();
                  _filterIcons();
                },
              )
            : null,
      ),
      value: _selectedIcon,
      items: [
        // Search bar as first item
        DropdownMenuItem<String>(
          enabled: false,
          child: TextField(
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Search icons...',
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        ..._filteredIcons.map((icon) {
          return DropdownMenuItem<String>(
            value: icon['name'],
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(icon['icon'], 
                    size: 20,
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    icon['name'],
                    style: const TextStyle(fontSize: 14),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
      onChanged: (value) {
        if (value != null) {
          setState(() => _selectedIcon = value);
        }
      },
      validator: (value) => value == null ? 'Please select an icon' : null,
    );
  }
}