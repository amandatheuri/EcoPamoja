import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopamoja/admin/features/didyouknow/didyouknow_form.dart';
import 'package:flutter/material.dart';

class DidYouKnowScreen extends StatelessWidget {
  const DidYouKnowScreen({super.key});

  void _openAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const DidYouKnowForm(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Did You Know Facts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _openAddDialog(context),
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('did_you_know_facts')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No facts added yet.'));
          }

          final docs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final data = docs[index].data() as Map<String, dynamic>;
              final title = data['title'] ?? '';
              final fact = data['fact'] ?? '';
              final imageUrl = data['imageUrl'] ?? '';

           return Card(
  margin: const EdgeInsets.all(8),
  child: ListTile(
    contentPadding: const EdgeInsets.all(12),
    leading: imageUrl.isNotEmpty
        ? ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(
              imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const Icon(Icons.broken_image),
            ),
          )
        : const Icon(Icons.image_not_supported),
    title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
    subtitle: Text(
      fact.length > 80 ? '${fact.substring(0, 80)}...' : fact,
    ),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit, color: Colors.blue),
          onPressed: () {
            showDialog(
              context: context,
              builder: (_) => DidYouKnowForm(
                existingData: data,
                docId: docs[index].id,
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () async {
            final confirm = await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete Fact?'),
                content: const Text('Are you sure you want to delete this fact?'),
                actions: [
                  TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
                  TextButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
                ],
              ),
            );

            if (confirm == true) {
              await FirebaseFirestore.instance
                  .collection('did_you_know_facts')
                  .doc(docs[index].id)
                  .delete();
            }
          },
        ),
      ],
    ),
  ),
);

            },
          );
        },
      ),
    );
  }
}
