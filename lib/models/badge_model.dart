// models/badge_model.dart
class BadgeModel {
  final String id;
  final String title;
  final String description;
  final String imageUrl; // Optional: You can add an image URL for the badge
  final bool isUnlocked;

  BadgeModel({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.isUnlocked,
  });

  // FromMap constructor for Firestore data
  factory BadgeModel.fromMap(String id, Map<String, dynamic> map) {
    return BadgeModel(
      id: id,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '', // Optional
      isUnlocked: map['isUnlocked'] ?? false,
    );
  }

  // ToMap for saving the badge to Firestore
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'isUnlocked': isUnlocked,
    };
  }
}
