import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String uid;
  final String email;
  final String username;
  final String? photoUrl;
  final DateTime createdAt;
  final DateTime lastActive;
  final int streak;
  final bool isAdmin;
  final int medalCount;
  final int trophiesEarned;
  final bool ecoWarrior;
  final int quizzesCompleted;
  final int actionsCompleted;
  final int totalChallengesCompleted;
  final int dailyGoal;
  final int todayChallengesCompleted;
  final List<String> completedChallenges;
  final bool notificationsEnabled;
  final List<String> preferredCategories;
  final String themeMode;
  final bool hasSeenIntro;

  UserData({
    required this.uid,
    required this.email,
    required this.username,
    this.photoUrl,
    required this.createdAt,
    required this.lastActive,
    required this.streak,
    required this.isAdmin,
    required this.medalCount,
    required this.trophiesEarned,
    required this.ecoWarrior,
    required this.quizzesCompleted,
    required this.actionsCompleted,
    required this.totalChallengesCompleted,
    required this.dailyGoal,
    required this.todayChallengesCompleted,
    required this.completedChallenges,
    required this.notificationsEnabled,
    required this.preferredCategories,
    required this.themeMode,
    required this.hasSeenIntro,
  });

  factory UserData.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return UserData(
      uid: doc.id,
      email: data['email'] ?? '',
      username: data['username'] ?? '',
      photoUrl: data['photoUrl'],
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      lastActive: (data['lastActive'] as Timestamp?)?.toDate() ?? DateTime.now(),
      streak: data['streak'] ?? 0,
      isAdmin: data['isAdmin'] ?? false,
      medalCount: data['medalCount'] ?? 0,
      trophiesEarned: data['trophiesEarned'] ?? 0,
      ecoWarrior: data['ecoWarrior'] ?? false,
      quizzesCompleted: data['quizzesCompleted'] ?? 0,
      actionsCompleted: data['actionsCompleted'] ?? 0,
      totalChallengesCompleted: data['totalChallengesCompleted'] ?? 0,
      dailyGoal: data['dailyGoal'] ?? 3,
      todayChallengesCompleted: data['todayChallengesCompleted'] ?? 0,
      completedChallenges: List<String>.from(data['completedChallenges'] ?? []),
      notificationsEnabled: data['notificationsEnabled'] ?? true,
      preferredCategories: List<String>.from(data['preferredCategories'] ?? []),
      themeMode: data['themeMode'] ?? 'dark',
      hasSeenIntro: data['hasSeenIntro'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
      'photoUrl': photoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastActive': Timestamp.fromDate(lastActive),
      'streak': streak,
      'isAdmin': isAdmin,
      'medalCount': medalCount,
      'trophiesEarned': trophiesEarned,
      'ecoWarrior': ecoWarrior,
      'quizzesCompleted': quizzesCompleted,
      'actionsCompleted': actionsCompleted,
      'totalChallengesCompleted': totalChallengesCompleted,
      'dailyGoal': dailyGoal,
      'todayChallengesCompleted': todayChallengesCompleted,
      'completedChallenges': completedChallenges,
      'notificationsEnabled': notificationsEnabled,
      'preferredCategories': preferredCategories,
      'themeMode': themeMode,
      'hasSeenIntro': hasSeenIntro,
    };
  }
}
