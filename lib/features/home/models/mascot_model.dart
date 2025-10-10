class MascotState {
  final String? id; // <-- Optional Firestore document ID
  final int minDaysInactive;
  final int maxDaysInactive;
  final String message;
  final String image;

  MascotState({
    this.id,
    required this.minDaysInactive,
    required this.maxDaysInactive,
    required this.message,
    required this.image,
  });

  factory MascotState.fromMap(Map<String, dynamic> map, {String? id}) {
    return MascotState(
      id: id,
      minDaysInactive: map['minDaysInactive'],
      maxDaysInactive: map['maxDaysInactive'],
      message: map['message'],
      image: map['image'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'minDaysInactive': minDaysInactive,
      'maxDaysInactive': maxDaysInactive,
      'message': message,
      'image': image,
    };
  }

  MascotState copyWith({
    String? id,
    int? minDaysInactive,
    int? maxDaysInactive,
    String? message,
    String? image,
  }) {
    return MascotState(
      id: id ?? this.id,
      minDaysInactive: minDaysInactive ?? this.minDaysInactive,
      maxDaysInactive: maxDaysInactive ?? this.maxDaysInactive,
      message: message ?? this.message,
      image: image ?? this.image,
    );
  }
}
