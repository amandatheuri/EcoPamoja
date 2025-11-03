// EditSponsoredChallengeDialog.dart
import 'package:ecopamoja/utility_functions/validators.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:ecopamoja/admin/features/challenges/models/sponsored_challenges.dart';
import 'package:url_launcher/url_launcher.dart';

class EditSponsoredChallengeDialog extends StatefulWidget {
  final SponsoredChallengesModel challenge;
  const EditSponsoredChallengeDialog({super.key, required this.challenge});

  @override
  State<EditSponsoredChallengeDialog> createState() => _EditSponsoredChallengeDialogState();
}

class _EditSponsoredChallengeDialogState extends State<EditSponsoredChallengeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _imageUrl = TextEditingController();
  final _brandName = TextEditingController();
  final _points =TextEditingController();
  final _logo =TextEditingController();
  final _descriptionController = TextEditingController();
  final _partnerStoreLinkController = TextEditingController();
  final _dueDateController = TextEditingController();
  DateTime? _selectedDueDate;
  bool _isSubmitting = false;

  List<Map<String, dynamic>> availableLogos = [];

  @override
  void initState() {
    super.initState();
    final challenge = widget.challenge;
    _imageUrl.text = challenge.brandImageLink;
    _logo.text = challenge.partnerLogoKey;
    _brandName.text = challenge.partnerName;
    _descriptionController.text = challenge.description;
    _partnerStoreLinkController.text = challenge.storeLink;
    _selectedDueDate = challenge.dueDate.toDate();
    _points.text = challenge.pointsToAward.toString();
    _dueDateController.text = DateFormat('MMM dd, yyyy hh:mm a').format(_selectedDueDate!);
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

      await FirebaseFirestore.instance.collection('sponsored_challenges').doc(widget.challenge.id).update({
        'brandImage': _imageUrl.text.trim(),
        'description': _descriptionController.text.trim(),
        'storeLink': _partnerStoreLinkController.text.trim(),
        'dueDate': _selectedDueDate,
        'partnerLogoKey': _logo,
        'partnerName': _brandName,
        'pointsToAward': int.tryParse(_points.text.trim()) ?? 0,
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sponsored challenge updated')),
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
              _buildField('brand image url', _imageUrl, validator: (value) {
  AppValidators.validateUrl(value);
  return null;
  },),
                _buildField('brand name', _brandName, maxLines: 3),
              _buildField('points to award', _points, maxLines: 1),
              _buildField('Description', _descriptionController, maxLines: 3),
               _buildField('Partner Store Link',
  _partnerStoreLinkController,
  inputType: TextInputType.url,
  validator: (value) {
  AppValidators.validateUrl(value);
  return null;
  },
),
const SizedBox(height: 10),
//preview link
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
 _buildField('brand logo', _logo, validator: (value) {
  AppValidators.validateUrl(value);
  return null;
  },),
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
