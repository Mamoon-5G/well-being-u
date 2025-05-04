class CourseModel {
  final String id;
  final String title;
  final String description;
  final String category; // e.g., Mental Health, Nutrition
  final String imageUrl;

  CourseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.imageUrl,
  });

  factory CourseModel.fromMap(String id, Map<String, dynamic> data) {
    return CourseModel(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
    );
  }
}
