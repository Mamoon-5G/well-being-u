import 'package:flutter/foundation.dart';
import 'package:wellbeingu/services/progress_service.dart';

class ProgressProvider with ChangeNotifier {
  final ProgressService _progressService = ProgressService();
  
  Map<String, dynamic> _progressData = {};
  bool _isLoading = false;
  String? _error;
  
  Map<String, dynamic> get progressData => _progressData;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  int get points => _progressData['points'] ?? 0;
  int get level => _progressData['level'] ?? 1;
  List<String> get badges => List<String>.from(_progressData['badges'] ?? []);
  List<String> get completedCourses => List<String>.from(_progressData['completedCourses'] ?? []);
  List<String> get enrolledCourses => List<String>.from(_progressData['enrolledCourses'] ?? []);
  Map<String, int> get progress => Map<String, int>.from(_progressData['progress'] ?? {});
  
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  
  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }
  
  Future<void> loadUserProgress() async {
    try {
      _setLoading(true);
      _progressData = await _progressService.getUserProgressData();
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }
  
  Future<void> enrollInCourse(String courseId) async {
    try {
      _setLoading(true);
      await _progressService.enrollInCourse(courseId);
      await loadUserProgress();
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }
  
  Future<void> updateCourseProgress(String courseId, int progress) async {
    try {
      _setLoading(true);
      await _progressService.updateCourseProgress(courseId, progress);
      await loadUserProgress();
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }
  
  Future<void> completeCourse(String courseId, int pointsReward, String badgeId) async {
    try {
      _setLoading(true);
      await _progressService.completeCourse(courseId, pointsReward, badgeId);
      await loadUserProgress();
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }
  
  Future<void> completeLesson(String courseId, String lessonId, int pointsReward) async {
    try {
      _setLoading(true);
      await _progressService.completeLesson(courseId, lessonId, pointsReward);
      await loadUserProgress();
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }
  
  Future<void> completeQuiz(String courseId, String quizId, int score, int pointsReward) async {
    try {
      _setLoading(true);
      await _progressService.completeQuiz(courseId, quizId, score, pointsReward);
      await loadUserProgress();
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }
  
  bool isCourseCompleted(String courseId) {
    return completedCourses.contains(courseId);
  }
  
  bool isCourseEnrolled(String courseId) {
    return enrolledCourses.contains(courseId);
  }
  
  int getCourseProgress(String courseId) {
    return progress[courseId] ?? 0;
  }
  
  bool hasCompletedLesson(String courseId, String lessonId) {
    return (_progressData['completedLessons'] as List<dynamic>?)?.contains("$courseId:$lessonId") ?? false;
  }
  
  bool hasCompletedQuiz(String courseId, String quizId) {
    return (_progressData['completedQuizzes'] as List<dynamic>?)?.contains("$courseId:$quizId") ?? false;
  }
  
  int? getQuizScore(String courseId, String quizId) {
    final quizScores = _progressData['quizScores'] as Map<String, dynamic>? ?? {};
    final courseScores = quizScores[courseId] as Map<String, dynamic>? ?? {};
    return courseScores[quizId] as int?;
  }
}