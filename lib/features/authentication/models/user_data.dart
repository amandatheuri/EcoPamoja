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
  final int quizzesCompleted;
  final int dailyHabitsCompleted;
  final int wasteReductionCompleted;
  final int totalChallengesCompleted;
  final int todayChallengesCompleted;
  final int dailyGoal;
  final bool notificationsEnabled;
  final List<String> completedSponsored;
  final String themeMode;
  final bool hasSeenIntro;
  final int groupsJoined;
  final int pointsEarned;
  final List<String> badgesEarned;
  final DateTime lastReset; 

  UserData({
    required this.uid,
    required this.email,
    required this.username,
    this.photoUrl,
    required this.createdAt,
    required this.lastActive,
    required this.streak,
    required this.isAdmin,
    required this.badgesEarned,
    required this.quizzesCompleted,
    required this.dailyHabitsCompleted,
    required this.wasteReductionCompleted,
    required this.totalChallengesCompleted,
    required this.todayChallengesCompleted,
    required this.dailyGoal,
    required this.notificationsEnabled,
    //required this.preferredCategories,
    required this.themeMode,
    required this.hasSeenIntro,
    required this.groupsJoined,
    required this.pointsEarned,
    required this.lastReset,
    required this.completedSponsored
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
      lastReset: (data['lastReset'] as Timestamp?)?.toDate()?? DateTime.now(),
      streak: data['streak'] ?? 0,
      isAdmin: data['isAdmin'] ?? false,
      quizzesCompleted: data['quizzesCompleted'] ?? 0,
      dailyHabitsCompleted: data['actionsCompleted'] ?? 0,
      totalChallengesCompleted: data['totalChallengesCompleted'] ?? 0,
      dailyGoal: data['dailyGoal'] ?? 3,
      todayChallengesCompleted: data['todayChallengesCompleted'] ?? 0,
      notificationsEnabled: data['notificationsEnabled'] ?? true,
      badgesEarned: List<String>.from(data['badgesEarned'] ?? []),
      completedSponsored: List<String>.from(data['completedSponsored'] ?? []),
      themeMode: data['themeMode'] ?? 'dark',
      hasSeenIntro: data['hasSeenIntro'] ?? false,
      groupsJoined: data['groupsJoined']?? 0,
      pointsEarned: data['pointsEarned']?? 0,
      wasteReductionCompleted: data['wasteReductionCompleted']?? 0,
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
      'badgesEarned': badgesEarned,
      'quizzesCompleted': quizzesCompleted,
      'dailyHabitsCompleted': dailyHabitsCompleted,
      'totalChallengesCompleted': totalChallengesCompleted,
      'todayChallengesCompleted': todayChallengesCompleted,
      'dailyGoal': dailyGoal,
      'wasteReductionCompleted': wasteReductionCompleted,
      'notificationsEnabled': notificationsEnabled,
      //'preferredCategories': preferredCategories,
      'themeMode': themeMode,
      'hasSeenIntro': hasSeenIntro,
      'pointsEarned': pointsEarned,
      'groupsJoined': groupsJoined,
      'lastReset':lastReset,
      'completedSponsored': completedSponsored,
    };
  }
}
