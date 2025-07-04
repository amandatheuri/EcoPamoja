// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class SponsoredChallengesModel {
  final String id;
  final String title;
  final String description;
  final String partnerLogoKey;
  final String partnerName;
  final String storeLink;
  final Timestamp dueDate;
  final DateTime createdAt;
  final int daily_Limit;
  final int? iconCode;
  final String? iconFontFamily;
  final String? icon;

  SponsoredChallengesModel({
    required this.id,
    required this.title,
    required this.description,
    required this.partnerLogoKey,
    required this.partnerName,
    required this.storeLink,
    required this.dueDate,
    required this.createdAt,
    required this.daily_Limit,
    this.iconCode,
    this.iconFontFamily,
    this.icon,
  });

  factory SponsoredChallengesModel.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SponsoredChallengesModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      partnerLogoKey: data['partnerLogoKey'] ?? '',
      partnerName: data['partnerName'] ?? '',
      storeLink: data['storeLink'] ?? '',
      dueDate: data['dueDate'] ?? Timestamp.now(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      daily_Limit: data['daily_limit'] ?? 1,
      iconCode: data['iconCode'],
      iconFontFamily: data['iconFontFamily'],
      icon: data['icon'],
    );
  }
}
