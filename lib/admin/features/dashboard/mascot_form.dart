import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopamoja/features/home/models/mascot_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdminMascotPage extends ConsumerStatefulWidget {
  const AdminMascotPage({super.key});

  @override
  ConsumerState<AdminMascotPage> createState() => _AdminMascotPageState();
}

class _AdminMascotPageState extends ConsumerState<AdminMascotPage> {
  final _formKey = GlobalKey<FormState>();
  final minDaysController = TextEditingController();
  final maxDaysController = TextEditingController();
  final messageController = TextEditingController();
  final imageController = TextEditingController();

  String? editingDocId;

  Future<List<MascotState>> _fetchMascotStates() async {
    final snapshot = await FirebaseFirestore.instance.collection('mascotStates').get();
    return snapshot.docs
        .map((doc) => MascotState.fromMap(doc.data()).copyWith(id: doc.id))
        .toList();
  }

  Future<bool> _overlappingRange(int min, int max, [String? excludeId]) async {
    final existing = await _fetchMascotStates();
    for (var m in existing) {
      if (m.id != excludeId && max >= m.minDaysInactive && min <= m.maxDaysInactive) {
        return true;
      }
    }
    return false;
  }

  void _submitMascotState() async {
    if (!_formKey.currentState!.validate()) return;

    final min = int.parse(minDaysController.text);
    final max = int.parse(maxDaysController.text);

    final overlap = await _overlappingRange(min, max, editingDocId);
    if (overlap) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Range overlaps with existing mascot state")),
      );
      return;
    }

    final mascotState = MascotState(
      minDaysInactive: min,
      maxDaysInactive: max,
      message: messageController.text,
      image: imageController.text,
    );

    final collection = FirebaseFirestore.instance.collection('mascotStates');

    if (editingDocId != null) {
      await collection.doc(editingDocId).update(mascotState.toMap());
    } else {
      await collection.add(mascotState.toMap());
    }

    _clearForm();
    setState(() {}); // refresh UI
  }

  void _clearForm() {
    minDaysController.clear();
    maxDaysController.clear();
    messageController.clear();
    imageController.clear();
    editingDocId = null;
  }

  void _editMascot(MascotState m) {
    minDaysController.text = m.minDaysInactive.toString();
    maxDaysController.text = m.maxDaysInactive.toString();
    messageController.text = m.message;
    imageController.text = m.image;
    editingDocId = m.id;
    setState(() {});
  }

  void _deleteMascot(String id) async {
    await FirebaseFirestore.instance.collection('mascotStates').doc(id).delete();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(editingDocId == null ? "Add Mascot State" : "Edit Mascot State")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
          Form(
            key: _formKey,
            child: Column(children: [
              TextFormField(
                controller: minDaysController,
                decoration: const InputDecoration(labelText: "Min Days Inactive"),
                keyboardType: TextInputType.number,
                validator: (val) => val == null || val.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: maxDaysController,
                decoration: const InputDecoration(labelText: "Max Days Inactive"),
                keyboardType: TextInputType.number,
                validator: (val) => val == null || val.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: messageController,
                decoration: const InputDecoration(labelText: "Mascot Message"),
                validator: (val) => val == null || val.isEmpty ? "Required" : null,
              ),
              TextFormField(
                controller: imageController,
                decoration: const InputDecoration(labelText: "Image URL"),
                onChanged: (_) => setState(() {}),
                validator: (val) => val == null || val.isEmpty ? "Required" : null,
              ),
              const SizedBox(height: 8),
              if (imageController.text.isNotEmpty)
                Image.network(
                  imageController.text,
                  height: 100,
                  errorBuilder: (_, _, _) => const Text("Invalid image URL"),
                ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _submitMascotState,
                child: Text(editingDocId == null ? "Add" : "Update"),
              )
            ]),
          ),
          const SizedBox(height: 20),
          const Divider(),
          const Text("Existing Mascot States", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Expanded(
            child: FutureBuilder<List<MascotState>>(
              future: _fetchMascotStates(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text("No mascot states added.");
                }

                final states = snapshot.data!;
                return ListView.builder(
                  itemCount: states.length,
                  itemBuilder: (_, i) {
                    final m = states[i];
                    return ListTile(
                      leading: Image.network(m.image, width: 50, height: 50, errorBuilder: (_, _, _) => const Icon(Icons.image_not_supported)),
                      title: Text("${m.minDaysInactive}–${m.maxDaysInactive} days"),
                      subtitle: Text(m.message),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(icon: const Icon(Icons.edit), onPressed: () => _editMascot(m)),
                          IconButton(icon: const Icon(Icons.delete), onPressed: () => _deleteMascot(m.id!)),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          )
        ]),
      ),
    );
  }
}
