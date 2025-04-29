import 'package:flutter/foundation.dart';
import 'package:wellbeingu/models/course_model.dart';
import 'package:wellbeingu/services/course_service.dart';

class CourseProvider with ChangeNotifier {
  final CourseService _courseService = CourseService();
  
  List<CourseModel> _courses = [];
  CourseModel? _selectedCourse;
  List<BadgeModel> _badges = [];
  bool _isLoading = false;
  String? _error;
  
  List<CourseModel> get courses => _courses;
  CourseModel? get selectedCourse => _selectedCourse;
  List<BadgeModel> get badges => _badges;
  bool get isLoading => _isLoading;
  String? get error => _error;
  
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
  
  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }
  
  Future<void> loadCourses() async {
    try {
      _setLoading(true);
      _courses = await _courseService.getAllCourses();
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }
  
  Future<void> loadCoursesByCategory(String category) async {
    try {
      _setLoading(true);
      _courses = await _courseService.getCoursesByCategory(category);
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }
  
  Future<void> loadCourseById(String courseId) async {
    try {
      _setLoading(true);
      final course = await _courseService.getCourseById(courseId);
      if (course != null) {
        _selectedCourse = course;
      }
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }
  
  Future<void> loadBadges() async {
    try {
      _setLoading(true);
      _badges = await _courseService.getAllBadges();
      _setLoading(false);
    } catch (e) {
      _setError(e.toString());
      _setLoading(false);
    }
  }
  
  BadgeModel? getBadgeById(String badgeId) {
    try {
      return _badges.firstWhere((badge) => badge.id == badgeId);
    } catch (e) {
      return null;
    }
  }
  
  List<CourseModel> getMentalHealthCourses() {
    return _courses.where((course) => course.category == 'mental_health').toList();
  }
  
  List<CourseModel> getNutritionCourses() {
    return _courses.where((course) => course.category == 'nutrition').toList();
  }
  
  List<CourseModel> getRecommendedCourses() {
    // Simple recommendation: sort by difficulty ascending
    final recommended = List<CourseModel>.from(_courses);
    recommended.sort((a, b) => a.difficulty.compareTo(b.difficulty));
    return recommended.take(5).toList();
  }
  
  void clearSelectedCourse() {
    _selectedCourse = null;
    notifyListeners();
  }
}