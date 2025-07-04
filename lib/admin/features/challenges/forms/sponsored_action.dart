// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopamoja/admin/features/widgets/fetch_logos.dart';
import 'package:ecopamoja/theme_essentials/colors.dart';
import 'package:ecopamoja/utility_functions/validators.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class SponsoredActionChallenge extends StatefulWidget {
  const SponsoredActionChallenge({super.key});

  @override
  State<SponsoredActionChallenge> createState() => _SponsoredActionChallengeState();
}

class _SponsoredActionChallengeState extends State<SponsoredActionChallenge> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dailyLimitController = TextEditingController();
  final _dueDateController = TextEditingController();
  final _partnerStoreLinkController = TextEditingController();
  final _logoSearchController = TextEditingController();
  final _iconSearchController = TextEditingController();

  DateTime? _selectedDueDate;
  String? _selectedIcon;
  final bool _isSubmitting = false;
  String? _selectedLogo;
  List<Map<String, dynamic>> availableLogos = [];
  List<Map<String, dynamic>> filteredLogos = [];
  List<Map<String, dynamic>> filteredIcons = [];

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

  String getLogoUrl(String key) {
    return 'https://amandatheuri.github.io/ecopamoja-assets/logos/$key';
  }

  @override
  void initState() {
    super.initState();
    _logoSearchController.addListener(_filterLogos);
    _iconSearchController.addListener(_filterIcons);
    filteredIcons = List.from(availableIcons);
    fetchLogos().then((logos) {
      setState(() {
        availableLogos = logos;
        filteredLogos = List.from(logos);
      });
    });
  }

  @override
  void dispose() {
    _logoSearchController.dispose();
    _iconSearchController.dispose();
    super.dispose();
  }

  void _filterLogos() {
    final query = _logoSearchController.text.toLowerCase();
    setState(() {
      filteredLogos = availableLogos.where((logo) {
        return logo['name'].toLowerCase().contains(query);
      }).toList();
    });
  }

  void _filterIcons() {
    final query = _iconSearchController.text.toLowerCase();
    setState(() {
      filteredIcons = availableIcons.where((icon) {
        return icon['name'].toLowerCase().contains(query);
      }).toList();
    });
  }

  Future<void> _pickDueDateTime() async {
    final date = await showDatePicker(
      context: context, 
      firstDate: DateTime.now(), 
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );
    if(date == null) return;
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if(time == null) return;
    final fullDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    setState(() {
      _selectedDueDate = fullDateTime;
      _dueDateController.text = DateFormat('MMM dd, yyyy hh:mm a').format(fullDateTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final dialogHeight = screenHeight * 0.8;
    final dialogWidth = screenWidth * 0.8;
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: dialogWidth,
          maxHeight: dialogHeight,
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildField('Title', _titleController),
                  const SizedBox(height: 10),
                  _buildField('Description', _descriptionController, maxLines: 3),
                  const SizedBox(height: 10),
                  _buildField('Daily Limit', _dailyLimitController, inputType: TextInputType.number, validator: (value) {
                    if (value == null || value.isEmpty) return 'Required';
                    final num = int.tryParse(value);
                    if (num == null || num < 1) return 'Must be ≥ 1';
                    return null;
                  },),
                  const SizedBox(height: 10),
                  _buildField(
                    'Partner Store Link',
                    _partnerStoreLinkController,
                    inputType: TextInputType.url,
                    validator: (value) {
                      AppValidators.validateUrl(value);
                      return null;
                    },
                  ),
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
                            launchUrl(uri);
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
                      child: _buildField(
                        'Due Date & Time',
                        _dueDateController,
                        inputType: TextInputType.datetime,
                        validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedLogo,
                    decoration: const InputDecoration(labelText: 'Select Partner Logo'),
                    items: [
                      DropdownMenuItem<String>(
                        value: null,
                        enabled: false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: TextField(
                            controller: _logoSearchController,
                            decoration: InputDecoration(
                              hintText: 'Search logos...',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 10),
                              isDense: true,
                            ),
                          ),
                        ),
                      ),
                      ...filteredLogos.map((logo) {
                        return DropdownMenuItem<String>(
                          value: logo['key'],
                          child: Container(
                            constraints: BoxConstraints(maxHeight: 40),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(
                                    'https://amandatheuri.github.io/ecopamoja-assets/logos/${logo['key']}',
                                  ),
                                  radius: 12,
                                ),
                                const SizedBox(width: 8),
                                Flexible(child: Text(logo['name'])),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                    onChanged: (value) => setState(() => _selectedLogo = value),
                    menuMaxHeight: 200,
                    isExpanded: true,
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    value: _selectedIcon,
                    decoration: const InputDecoration(
                      labelText: 'Select Icon',
                      border: OutlineInputBorder(
                      ),
                    ),
                    items: [
                      DropdownMenuItem<String>(
                        value: null,
                        enabled: false,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: TextField(
                            controller: _iconSearchController,
                            decoration: InputDecoration(
                              hintText: 'Search icons...',
                              border: OutlineInputBorder(
                              ),
                              contentPadding: EdgeInsets.symmetric(horizontal: 8),
                              isDense: true,
                            ),
                          ),
                        ),
                      ),
                      ...filteredIcons.map((icon) {
                        return DropdownMenuItem<String>(
                          value: icon['name'],
                          child: Container(
                            constraints: BoxConstraints(maxHeight: 60),
                            child: Row(
                              children: [
                                Icon(icon['icon'], color: AppColors.primary),
                                const SizedBox(width: 8),
                                Flexible(child: Text(icon['name'])),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedIcon = value;
                      });
                    },
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Please select an icon' : null,
                    menuMaxHeight: 300,
                    isExpanded: true,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: _isSubmitting ? null : () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: _isSubmitting ? null : _submitChallenge,
                        child: _isSubmitting
                            ? const CircularProgressIndicator()
                            : const Text('Submit'),
                      ),
                    ],
                  ),
                ]
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller, {
    TextInputType inputType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
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

  Future<void> _submitChallenge() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Please fill all required fields.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_selectedIcon == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Please select an icon.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_selectedLogo == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Please select a partner logo.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final partnerMatch = availableLogos.firstWhere(
      (logo) => logo['key'] == _selectedLogo,
      orElse: () => {},
    );

    if (partnerMatch.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Partner logo not found.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⏳ Submitting challenge...'),
          backgroundColor: Colors.blueGrey,
        ),
      );

      await FirebaseFirestore.instance.collection('sponsored_challenges').add({
        'title': _titleController.text.trim(),
        'description': _descriptionController.text.trim(),
        'partnerName': partnerMatch['name'],
        'partnerLogoKey': _selectedLogo,
        'storeLink': _partnerStoreLinkController.text.trim(),
        'dueDate': _selectedDueDate,
        'daily_Limit': int.parse(_dailyLimitController.text),
        'createdAt': FieldValue.serverTimestamp(),
        'type': 'sponsored',
        'icon': _selectedIcon,
        'iconCode': availableIcons.firstWhere((icon) => icon['name'] == _selectedIcon)['icon'].codePoint,
        'iconFontFamily': availableIcons.firstWhere((icon) => icon['name'] == _selectedIcon)['icon'].fontFamily ?? 'MaterialIcons',
      });

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Sponsored challenge added successfully!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: ${e.toString()}'),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }
}