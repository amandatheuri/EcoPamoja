import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecopamoja/features/home/did_you_know/did_you_know.dart';
import 'package:flutter/material.dart';

class DidYouKnowFactList extends StatelessWidget {
  const DidYouKnowFactList({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('did_you_know_facts')
          .orderBy('title')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No Did You Know facts added yet.'));
        }

        final facts = snapshot.data!.docs
            .map((doc) => DidYouKnowFact.fromFirestore(doc))
            .toList();

        return ListView.builder(
          itemCount: facts.length,
          itemBuilder: (context, index) {
            final fact = facts[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.all(12),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    fact.imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, _, _) =>
                        const Icon(Icons.broken_image),
                  ),
                ),
                title: Text(fact.title),
                subtitle: Text(
                  fact.fact.length > 60
                      ? '${fact.fact.substring(0, 60)}...'
                      : fact.fact,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () {
                        // TODO: Show edit dialog with pre-filled data
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        FirebaseFirestore.instance
                            .collection('did_you_know_facts')
                            .doc(fact.id)
                            .delete();
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
