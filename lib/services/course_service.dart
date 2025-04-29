import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wellbeingu/models/course_model.dart';

class CourseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all courses
  Future<List<CourseModel>> getAllCourses() async {
    try {
      final coursesSnapshot = await _firestore.collection('courses').get();
      
      return coursesSnapshot.docs
          .map((doc) => CourseModel.fromMap({'id': doc.id, ...doc.data()}))
          .toList();
    } catch (e) {
      print('Error getting courses: $e');
      return [];
    }
  }

  // Get courses by category
  Future<List<CourseModel>> getCoursesByCategory(String category) async {
    try {
      final coursesSnapshot = await _firestore
          .collection('courses')
          .where('category', isEqualTo: category)
          .get();
      
      return coursesSnapshot.docs
          .map((doc) => CourseModel.fromMap({'id': doc.id, ...doc.data()}))
          .toList();
    } catch (e) {
      print('Error getting courses by category: $e');
      return [];
    }
  }

  // Get course by ID
  Future<CourseModel?> getCourseById(String courseId) async {
    try {
      final courseDoc = await _firestore
          .collection('courses')
          .doc(courseId)
          .get();
      
      if (courseDoc.exists) {
        return CourseModel.fromMap({'id': courseDoc.id, ...courseDoc.data()!});
      }
      return null;
    } catch (e) {
      print('Error getting course by ID: $e');
      return null;
    }
  }
  
  // Get badges
  Future<List<BadgeModel>> getAllBadges() async {
    try {
      final badgesSnapshot = await _firestore.collection('badges').get();
      
      return badgesSnapshot.docs
          .map((doc) => BadgeModel.fromMap({'id': doc.id, ...doc.data()}))
          .toList();
    } catch (e) {
      print('Error getting badges: $e');
      return [];
    }
  }

  // Get badge by ID
  Future<BadgeModel?> getBadgeById(String badgeId) async {
    try {
      final badgeDoc = await _firestore
          .collection('badges')
          .doc(badgeId)
          .get();
      
      if (badgeDoc.exists) {
        return BadgeModel.fromMap({'id': badgeDoc.id, ...badgeDoc.data()!});
      }
      return null;
    } catch (e) {
      print('Error getting badge by ID: $e');
      return null;
    }
  }
}