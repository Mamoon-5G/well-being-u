class UserModel {
  final String id;
  final String name;
  final String email;
  final String? photoUrl;
  final int points;
  final List<String> completedCourses;
  final List<String> enrolledCourses;
  final Map<String, int> progress;
  final List<String> badges;
  final int level;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    this.points = 0,
    this.completedCourses = const [],
    this.enrolledCourses = const [],
    this.progress = const {},
    this.badges = const [],
    this.level = 1,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'],
      points: map['points'] ?? 0,
      completedCourses: List<String>.from(map['completedCourses'] ?? []),
      enrolledCourses: List<String>.from(map['enrolledCourses'] ?? []),
      progress: Map<String, int>.from(map['progress'] ?? {}),
      badges: List<String>.from(map['badges'] ?? []),
      level: map['level'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'points': points,
      'completedCourses': completedCourses,
      'enrolledCourses': enrolledCourses,
      'progress': progress,
      'badges': badges,
      'level': level,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
    int? points,
    List<String>? completedCourses,
    List<String>? enrolledCourses,
    Map<String, int>? progress,
    List<String>? badges,
    int? level,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
      points: points ?? this.points,
      completedCourses: completedCourses ?? this.completedCourses,
      enrolledCourses: enrolledCourses ?? this.enrolledCourses,
      progress: progress ?? this.progress,
      badges: badges ?? this.badges,
      level: level ?? this.level,
    );
  }
}