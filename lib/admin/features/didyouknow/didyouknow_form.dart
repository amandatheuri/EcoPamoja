import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DidYouKnowForm extends StatefulWidget {
  final Map<String, dynamic>? existingData;
  final String? docId;

  const DidYouKnowForm({super.key, this.existingData, this.docId});

  @override
  State<DidYouKnowForm> createState() => _DidYouKnowFormState();
}

class _DidYouKnowFormState extends State<DidYouKnowForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _imageUrlController;
  late TextEditingController _titleController;
  late TextEditingController _factController;
  late TextEditingController _blogLinkController;

  bool get isEdit => widget.existingData != null;

  @override
  void initState() {
    super.initState();
    _imageUrlController = TextEditingController(text: widget.existingData?['imageUrl'] ?? '');
    _titleController = TextEditingController(text: widget.existingData?['title'] ?? '');
    _factController = TextEditingController(text: widget.existingData?['fact'] ?? '');
    _blogLinkController = TextEditingController(text: widget.existingData?['blogLink'] ?? '');
  }

  @override
  void dispose() {
    _imageUrlController.dispose();
    _titleController.dispose();
    _factController.dispose();
    _blogLinkController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      'imageUrl': _imageUrlController.text.trim(),
      'title': _titleController.text.trim(),
      'fact': _factController.text.trim(),
      'blogLink': _blogLinkController.text.trim(),
      'createdAt': FieldValue.serverTimestamp(),
    };

    final collection = FirebaseFirestore.instance.collection('did_you_know_facts');

    try {
      if (isEdit && widget.docId != null) {
        await collection.doc(widget.docId).update(data);
      } else {
        await collection.add(data);
      }

      if (context.mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(isEdit ? 'Edit Did You Know' : 'Add Did You Know'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildField(label: 'Image URL', controller: _imageUrlController),
              _buildField(label: 'Title', controller: _titleController),
              _buildField(label: 'Fact', controller: _factController, maxLines: 4),
              _buildField(label: 'Blog Link', controller: _blogLinkController),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: _submit,
          child: Text(isEdit ? 'Update' : 'Add'),
        ),
      ],
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        validator: (value) => value == null || value.trim().isEmpty ? 'Required' : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
