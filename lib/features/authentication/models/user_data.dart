import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String uid;
  final String email;
  final String username;
  final String? photoUrl;

  final DateTime createdAt;
  final DateTime lastActive;
  final DateTime lastReset;

  final int streak;
  final bool isAdmin;

  final int quizzesCompleted;
  final int dailyHabitsCompleted;
  final int wasteReductionCompleted;
  final int totalChallengesCompleted;
  final int todayChallengesCompleted;

  final int dailyGoal;
  final bool notificationsEnabled;

  final int groupsJoined;
  final int pointsEarned;

  final String themeMode;
  final bool hasSeenIntro;

  final List<String> badgesEarned;
  final List<String> completedSponsored;
  final List<String> lastChallengeType;

  UserData({
    required this.uid,
    required this.email,
    required this.username,
    this.photoUrl,
    required this.createdAt,
    required this.lastActive,
    required this.lastReset,
    required this.streak,
    required this.isAdmin,
    required this.quizzesCompleted,
    required this.dailyHabitsCompleted,
    required this.wasteReductionCompleted,
    required this.totalChallengesCompleted,
    required this.todayChallengesCompleted,
    required this.dailyGoal,
    required this.notificationsEnabled,
    required this.groupsJoined,
    required this.pointsEarned,
    required this.themeMode,
    required this.hasSeenIntro,
    required this.badgesEarned,
    required this.completedSponsored,
    required this.lastChallengeType,
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
      lastReset: (data['lastReset'] as Timestamp?)?.toDate() ?? DateTime.now(),
      streak: data['streak'] ?? 0,
      isAdmin: data['isAdmin'] ?? false,
      quizzesCompleted: data['quizzesCompleted'] ?? 0,
      dailyHabitsCompleted: data['dailyHabitsCompleted'] ?? 0,
      wasteReductionCompleted: data['wasteReductionCompleted'] ?? 0,
      totalChallengesCompleted: data['totalChallengesCompleted'] ?? 0,
      todayChallengesCompleted: data['todayChallengesCompleted'] ?? 0,
      dailyGoal: data['dailyGoal'] ?? 3,
      notificationsEnabled: data['notificationsEnabled'] ?? true,
      groupsJoined: data['groupsJoined'] ?? 0,
      pointsEarned: data['pointsEarned'] ?? 0,
      themeMode: data['themeMode'] ?? 'dark',
      hasSeenIntro: data['hasSeenIntro'] ?? false,
      badgesEarned: List<String>.from(data['badgesEarned'] ?? []),
      completedSponsored: List<String>.from(data['completedSponsored'] ?? []),
      lastChallengeType: List<String>.from(data['lastChallengeType'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'username': username,
      'photoUrl': photoUrl,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastActive': Timestamp.fromDate(lastActive),
      'lastReset': Timestamp.fromDate(lastReset),
      'streak': streak,
      'isAdmin': isAdmin,
      'quizzesCompleted': quizzesCompleted,
      'dailyHabitsCompleted': dailyHabitsCompleted,
      'wasteReductionCompleted': wasteReductionCompleted,
      'totalChallengesCompleted': totalChallengesCompleted,
      'todayChallengesCompleted': todayChallengesCompleted,
      'dailyGoal': dailyGoal,
      'notificationsEnabled': notificationsEnabled,
      'groupsJoined': groupsJoined,
      'pointsEarned': pointsEarned,
      'themeMode': themeMode,
      'hasSeenIntro': hasSeenIntro,
      'badgesEarned': badgesEarned,
      'completedSponsored': completedSponsored,
      'lastChallengeType': lastChallengeType,
    };
  }
}
