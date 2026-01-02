class MascotState {
  final String? id;
  final int minDaysInactive;
  final int maxDaysInactive;
  final String message;
  final String image;
  final List<String>? challengeTypes; // e.g., ['sponsored', 'quiz', 'dailyHabits']

  MascotState({
    this.id,
    required this.minDaysInactive,
    required this.maxDaysInactive,
    required this.message,
    required this.image,
    this.challengeTypes,
  });

  factory MascotState.fromMap(Map<String, dynamic> map, {String? id}) {
    return MascotState(
      id: id,
      minDaysInactive: map['minDaysInactive'],
      maxDaysInactive: map['maxDaysInactive'],
      message: map['message'],
      image: map['image'],
      challengeTypes: map['challengeTypes'] != null
          ? List<String>.from(map['challengeTypes'])
          : null,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'minDaysInactive': minDaysInactive,
      'maxDaysInactive': maxDaysInactive,
      'message': message,
      'image': image,
      'challengeTypes': challengeTypes,
    };
  }

  MascotState copyWith({
    String? id,
    int? minDaysInactive,
    int? maxDaysInactive,
    String? message,
    String? image,
    List<String>? challengeTypes,
  }) {
    return MascotState(
      id: id ?? this.id,
      minDaysInactive: minDaysInactive ?? this.minDaysInactive,
      maxDaysInactive: maxDaysInactive ?? this.maxDaysInactive,
      message: message ?? this.message,
      image: image ?? this.image,
      challengeTypes: challengeTypes ?? this.challengeTypes,
    );
  }
}
