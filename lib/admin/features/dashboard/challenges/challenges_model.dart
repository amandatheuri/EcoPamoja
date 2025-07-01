import 'package:cloud_firestore/cloud_firestore.dart';

enum ChallengeType { quiz, action }

class ChallengeModel {
  final String id;
  final String title;
  final String description;
  final ChallengeType type;
  final DateTime date;
  final List<String>? quizOptions;
  final int? correctAnswerIndex;

  ChallengeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.date,
    this.quizOptions,
    this.correctAnswerIndex,
  });

  factory ChallengeModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ChallengeModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      type: data['type'] == 'quiz' ? ChallengeType.quiz : ChallengeType.action,
      date: (data['date'] as Timestamp).toDate(),
      quizOptions: data['quizOptions'] != null
          ? List<String>.from(data['quizOptions'])
          : null,
      correctAnswerIndex: data['correctAnswerIndex'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'type': type.name,
      'date': Timestamp.fromDate(date),
      if (quizOptions != null) 'quizOptions': quizOptions,
      if (correctAnswerIndex != null) 'correctAnswerIndex': correctAnswerIndex,
    };
  }
}
