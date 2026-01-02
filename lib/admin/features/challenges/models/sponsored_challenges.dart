// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class SponsoredChallengesModel {
  final String id;
  final String title;
  final String description;
  final String partnerLogoKey;
  final String partnerName;
  final String storeLink;
  final String brandImageLink;
  final Timestamp dueDate;
  final DateTime createdAt;
  final int pointsToAward;
 
  SponsoredChallengesModel({
    required this.id,
    required this.title,
    required this.description,
    required this.partnerLogoKey,
    required this.partnerName,
    required this.storeLink,
    required this.brandImageLink,
    required this.dueDate,
    required this.createdAt,
    required this.pointsToAward,
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
      brandImageLink: data['brandImage']?? '',
      dueDate: data['dueDate'] ?? Timestamp.now(),
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      pointsToAward: data['pointsEarned']?? 0,
    );
  }

static SponsoredChallengesModel fromFirestore(Map<String, dynamic> doc, {String id = ''}) {
  return SponsoredChallengesModel(
    id: id,
    title: doc['title'] ?? '',
    description: doc['description'] ?? '',
    partnerLogoKey: doc['partnerLogoKey'] ?? '',
    partnerName: doc['partnerName'] ?? '',
    storeLink: doc['storeLink'] ?? '',
    brandImageLink: doc['brandImage']?? '',
    dueDate: doc['dueDate'] ?? Timestamp.now(),
    createdAt: (doc['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    pointsToAward: doc['pointsEarned']?? 0,
  );

}}
