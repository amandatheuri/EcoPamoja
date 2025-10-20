import 'package:cloud_firestore/cloud_firestore.dart';

class DidYouKnowFact {
  final String id;
  final String imageUrl;
  final String title;
  final String fact;
  final String blogLink;

  DidYouKnowFact({
    required this.id,
    required this.imageUrl,
    required this.title,
    required this.fact,
    required this.blogLink,
  });

  factory DidYouKnowFact.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DidYouKnowFact(
      id: doc.id,
      imageUrl: data['imageUrl'],
      title: data['title'],
      fact: data['fact'],
      blogLink: data['blogLink'],
    );
  }
  
}
