// ignore_for_file: constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

enum ChallengeType { quiz, action, Regular }

class ChallengeModel {
  final String id;
  final String title;
  final String description;
  final ChallengeType type;
  final DateTime createdAt;
  final List<QuizQuestion>? questions;
  final int? iconCode;
  final String? iconFontFamily;
  final String? icon;
  final int? durationSeconds; // NEW
  final DateTime? dueDate; // NEW
  final int? dailyLimit; // NEW

  ChallengeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.createdAt,
    this.questions,
    this.iconCode,
    this.iconFontFamily,
    this.icon,
    this.durationSeconds,
    this.dueDate,
    this.dailyLimit,
  });

  factory ChallengeModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ChallengeModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      type: data['type'] == 'quiz' ? ChallengeType.quiz : ChallengeType.action,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      questions: data['questions'] != null
          ? (data['questions'] as List)
              .map((q) => QuizQuestion.fromMap(q as Map<String, dynamic>))
              .toList()
          : null,
      iconCode: data['iconCode'],
      iconFontFamily: data['iconFontFamily'],
      icon: data['icon'],
      durationSeconds: data['durationSeconds'],
      dueDate: data['dueDate'] != null ? (data['dueDate'] as Timestamp).toDate() : null,
      dailyLimit: data['daily_limit'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'type': type.name,
      'createdAt': Timestamp.fromDate(createdAt),
      if (questions != null)
        'questions': questions!.map((q) => q.toMap()).toList(),
      'iconCode': iconCode,
      'iconFontFamily': iconFontFamily,
      'icon': icon,
      'durationSeconds': durationSeconds,
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
      'daily_limit': dailyLimit,
    };
  }
}

class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctAnswerIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctAnswerIndex,
  });

  QuizQuestion copyWith({
    String? question,
    List<String>? options,
    int? correctAnswerIndex,
  }) {
    return QuizQuestion(
      question: question ?? this.question,
      options: options ?? this.options,
      correctAnswerIndex: correctAnswerIndex ?? this.correctAnswerIndex,
    );
  }

  factory QuizQuestion.fromMap(Map<String, dynamic> data) {
    return QuizQuestion(
      question: data['question'] ?? '',
      options: List<String>.from(data['options'] ?? []),
      correctAnswerIndex: data['correctAnswerIndex'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'question': question,
      'options': options,
      'correctAnswerIndex': correctAnswerIndex,
    };
  }
}
