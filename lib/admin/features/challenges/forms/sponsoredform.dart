/*
Form that accepts:
Brand image
logo
Description
URL
Expiry date
Points to award
 */
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopamoja/admin/features/widgets/fetch_logos.dart';
import 'package:ecopamoja/utility_functions/validators.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class SponsoredInputForm extends StatefulWidget {
  const SponsoredInputForm({super.key});

  @override
  State<SponsoredInputForm> createState() => _SponsoredFormState();
}

class _SponsoredFormState extends State<SponsoredInputForm> {
  //controllers and form key
  final _imageUrl = TextEditingController();
  final _logo =TextEditingController();
  final _description =TextEditingController();
  final _url =TextEditingController();
  final _expiryDate =TextEditingController();
  final _points =TextEditingController();
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDueDate;
  final bool _isSubmitting = false;
  String? _selectedLogo;
  List<Map<String, dynamic>> availableLogos = [];
  List<Map<String, dynamic>> filteredLogos = [];
//getting images from github
  
   String getLogoUrl(String key) {
    return 'https://amandatheuri.github.io/ecopamoja-assets/logos/$key';
  }
//listening to logo selection
  @override
  void initState() {
    super.initState();
    _logo.addListener(_filterLogos);
    fetchLogos().then((logos) {
      setState(() {
        availableLogos = logos;
        filteredLogos = List.from(logos);
      });
    });
  }
//remove logos once selected
  @override
  void dispose() {
    _logo.dispose();
    super.dispose();
  }
//filtering logo logic
  void _filterLogos() {
    final query = _logo.text.toLowerCase();
    setState(() {
      filteredLogos = availableLogos.where((logo) {
        return logo['name'].toLowerCase().contains(query);
      }).toList();
    });
  }
//picking expiry date logic
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
      _expiryDate.text = DateFormat('MMM dd, yyyy hh:mm a').format(fullDateTime);
    });
  }
//textfield logic
 Widget _buildField(
    String label,
    TextEditingController controller, {
    TextInputType inputType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1, required String hintText,
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        //form
        child: Form(
          key:_formKey,
          child: Column(
            children: [
TextFormField(
      controller: _imageUrl,
      keyboardType: TextInputType.url,
      decoration: const InputDecoration(
        labelText: 'Brand Image URL',
        border: OutlineInputBorder(),
        hintText: 'https://example.com/brand_image.png',
      ),
 validator: (value) {
                          AppValidators.validateUrl(value);
                          return null;
                        }    ),              SizedBox(height: 10),
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
                                controller: _logo,
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
               SizedBox(height: 10),
              _buildField('Description', _description, maxLines: 3, hintText: 'Short description'),
               SizedBox(height: 10),
              _buildField('store link url', _url,  inputType: TextInputType.url,hintText: 'https://example.com/brand_image.png',
                        validator: (value) {
                          AppValidators.validateUrl(value);
                          return null;
                        },),
                         if (_url.text.trim().isNotEmpty)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton.icon(
                            icon: const Icon(Icons.open_in_new),
                            label: const Text('Preview Store Link'),
                            onPressed: () {
                              final link = _url.text.trim();
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
               SizedBox(height: 10),
              GestureDetector(
                        onTap: _pickDueDateTime,
                        child: AbsorbPointer(
                          child: _buildField(
                            'Due Date & Time',
                            _expiryDate,
                            inputType: TextInputType.datetime,
                            validator: (value) => value == null || value.isEmpty ? 'Required' : null,
                            hintText: 'Pick expiry date'
                          ),
                        ),
                      ),
               SizedBox(height: 10),
              _buildField('points to award', _points, hintText: '15'),
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
            ],
          ),
        ),
      ),
    );
  }
  //submit button logic
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
//database logic
    try {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⏳ Submitting challenge...'),
          backgroundColor: Colors.blueGrey,
        ),
      );

      await FirebaseFirestore.instance.collection('sponsored_challenges').add({
        'brandImage': _imageUrl.text.trim(),
        'description': _description.text.trim(),
        'partnerName': partnerMatch['name'],
        'partnerLogoKey': _selectedLogo,
        'storeLink': _url.text.trim(),
        'dueDate': _selectedDueDate,
        'createdAt': FieldValue.serverTimestamp(),
        'pointsToAward': int.tryParse(_points.text.trim()) ?? 0,
        'type': 'sponsored',
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