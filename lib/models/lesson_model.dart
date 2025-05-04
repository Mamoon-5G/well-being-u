class LessonModel {
  final String id;
  final String title;
  final String content;
  final String? videoUrl;
  final String courseId; // ✅ Add this

  LessonModel({
    required this.id,
    required this.title,
    required this.content,
    this.videoUrl,
    required this.courseId, // ✅ Make required
  });

  factory LessonModel.fromMap(String id, Map<String, dynamic> data, String courseId) {
    return LessonModel(
      id: id,
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      videoUrl: data['videoUrl'],
      courseId: courseId, // ✅ Save courseId
    );
  }
}
