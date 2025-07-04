// EditSponsoredChallengeDialog.dart
import 'package:ecopamoja/utility_functions/validators.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:ecopamoja/theme_essentials/colors.dart';
import 'package:ecopamoja/admin/features/challenges/models/sponsored_challenges.dart';
import 'package:ecopamoja/admin/features/widgets/fetch_logos.dart';
import 'package:url_launcher/url_launcher.dart';

class EditSponsoredChallengeDialog extends StatefulWidget {
  final SponsoredChallengesModel challenge;
  const EditSponsoredChallengeDialog({super.key, required this.challenge});

  @override
  State<EditSponsoredChallengeDialog> createState() => _EditSponsoredChallengeDialogState();
}

class _EditSponsoredChallengeDialogState extends State<EditSponsoredChallengeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dailyLimitController = TextEditingController();
  final _partnerStoreLinkController = TextEditingController();
  final _dueDateController = TextEditingController();
  DateTime? _selectedDueDate;
  String? _selectedLogo;
  String? _selectedIcon;
  bool _isSubmitting = false;

  List<Map<String, dynamic>> availableIcons = [];
  List<Map<String, dynamic>> availableLogos = [];

  @override
  void initState() {
    super.initState();
    final challenge = widget.challenge;
    _titleController.text = challenge.title;
    _descriptionController.text = challenge.description;
    _dailyLimitController.text = challenge.daily_Limit.toString();
    _partnerStoreLinkController.text = challenge.storeLink;
    _selectedDueDate = challenge.dueDate.toDate();
    _dueDateController.text = DateFormat('MMM dd, yyyy hh:mm a').format(_selectedDueDate!);
    _selectedLogo = challenge.partnerLogoKey;
    _selectedIcon = challenge.icon;

    fetchLogos().then((logos) => setState(() => availableLogos = logos));

    availableIcons = [
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
  }

  Future<void> _pickDueDateTime() async {
    final date = await showDatePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      initialDate: _selectedDueDate ?? DateTime.now(),
    );
    if (date == null) return;
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (time == null) return;
    final fullDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    setState(() {
      _selectedDueDate = fullDateTime;
      _dueDateController.text = DateFormat('MMM dd, yyyy hh:mm a').format(fullDateTime);
    });
  }

  Future<void> _submitUpdate() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    try {
      final updatedIcon = availableIcons.firstWhere((icon) => icon['name'] == _selectedIcon);
      final logo = availableLogos.firstWhere((logo) => logo['key'] == _selectedLogo);

      await FirebaseFirestore.instance.collection('sponsored_challenges').doc(widget.challenge.id).update({
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'daily_limit': int.parse(_dailyLimitController.text.trim()),
        'storeLink': _partnerStoreLinkController.text.trim(),
        'dueDate': _selectedDueDate,
        'icon': _selectedIcon,
        'iconCode': updatedIcon['icon'].codePoint,
        'iconFontFamily': updatedIcon['icon'].fontFamily,
        'partnerLogoKey': _selectedLogo,
        'partnerName': logo['name'],
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('✅ Sponsored challenge updated')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating: $e')),
        );
      }
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  Widget _buildField(String label, TextEditingController controller, {int maxLines = 1, TextInputType inputType = TextInputType.text, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
        validator: validator ?? (value) => value == null || value.trim().isEmpty ? 'Required' : null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Sponsored Challenge'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildField('Title', _titleController),
              _buildField('Description', _descriptionController, maxLines: 3),
              _buildField('Daily Limit', _dailyLimitController, inputType: TextInputType.number),
               _buildField(
  'Partner Store Link',
  _partnerStoreLinkController,
  inputType: TextInputType.url,
  validator: (value) {
  AppValidators.validateUrl(value);
  return null;
  },
),
const SizedBox(height: 10),
if (_partnerStoreLinkController.text.trim().isNotEmpty)
  Align(
    alignment: Alignment.centerLeft,
    child: TextButton.icon(
      icon: const Icon(Icons.open_in_new),
      label: const Text('Preview Store Link'),
      onPressed: () {
        final link = _partnerStoreLinkController.text.trim();
        final uri = Uri.tryParse(link.startsWith('http') ? link : 'https://$link');
        if (uri != null) {
          launchUrl(uri); // requires url_launcher
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid URL')),
          );
        }
      },
    ),
  ),
  const SizedBox(height: 10),
              GestureDetector(
                onTap: _pickDueDateTime,
                child: AbsorbPointer(
                  child: _buildField('Due Date & Time', _dueDateController, inputType: TextInputType.datetime),
                ),
              ),
                          const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: _selectedLogo,
                decoration: const InputDecoration(labelText: 'Select Partner Logo'),
                items: availableLogos.map((logo) {
                  return DropdownMenuItem<String>(
                    value: logo['key'],
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage('https://amandatheuri.github.io/ecopamoja-assets/logos/${logo['key']}'),
                          radius: 12,
                        ),
                        const SizedBox(width: 8),
                        Text(logo['name']),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedLogo = value),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedIcon,
                decoration: const InputDecoration(labelText: 'Select Icon', border: OutlineInputBorder()),
                items: availableIcons.map((icon) {
                  return DropdownMenuItem<String>(
                    value: icon['name'],
                    child: Row(
                      children: [
                        Icon(icon['icon'], color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(icon['name']),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedIcon = value),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: _isSubmitting ? null : () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: _isSubmitting ? null : _submitUpdate,
          child: _isSubmitting ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Update'),
        ),
      ],
    );
  }
}
