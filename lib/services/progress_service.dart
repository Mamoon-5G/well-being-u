import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:wellbeingu/models/user_model.dart';

class ProgressService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Enroll in a course
  Future<void> enrollInCourse(String courseId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');
      
      await _firestore.collection('users').doc(userId).update({
        'enrolledCourses': FieldValue.arrayUnion([courseId]),
      });
    } catch (e) {
      print('Error enrolling in course: $e');
      rethrow;
    }
  }

  // Update course progress
  Future<void> updateCourseProgress(String courseId, int progress) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');
      
      await _firestore.collection('users').doc(userId).update({
        'progress.$courseId': progress,
      });
    } catch (e) {
      print('Error updating course progress: $e');
      rethrow;
    }
  }

  // Complete a course
  Future<void> completeCourse(String courseId, int pointsReward, String badgeId) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');
      
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) throw Exception('User document not found');
      
      final user = UserModel.fromMap({'id': userId, ...userDoc.data()!});
      
      // Add course to completed courses
      final updatedCompletedCourses = [...user.completedCourses, courseId];
      
      // Add badge if not already owned
      final updatedBadges = [...user.badges];
      if (!updatedBadges.contains(badgeId)) {
        updatedBadges.add(badgeId);
      }
      
      // Update points and maybe level
      final updatedPoints = user.points + pointsReward;
      final updatedLevel = _calculateLevel(updatedPoints);
      
      await _firestore.collection('users').doc(userId).update({
        'completedCourses': updatedCompletedCourses,
        'points': updatedPoints,
        'badges': updatedBadges,
        'level': updatedLevel,
      });
    } catch (e) {
      print('Error completing course: $e');
      rethrow;
    }
  }
  
  // Calculate user level based on points
  int _calculateLevel(int points) {
    // Basic level calculation: level = 1 + (points / 100)
    return 1 + (points ~/ 100);
  }
  
  // Complete a lesson
  Future<void> completeLesson(String courseId, String lessonId, int pointsReward) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');
      
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) throw Exception('User document not found');
      
      final user = UserModel.fromMap({'id': userId, ...userDoc.data()!});
      
      // Update points
      final updatedPoints = user.points + pointsReward;
      final updatedLevel = _calculateLevel(updatedPoints);
      
      await _firestore.collection('users').doc(userId).update({
        'points': updatedPoints,
        'level': updatedLevel,
        'completedLessons': FieldValue.arrayUnion(["$courseId:$lessonId"]),
});
    } catch (e) {
      print('Error completing lesson: $e');
      rethrow;
    }
  }
  
  // Complete a quiz
  Future<void> completeQuiz(String courseId, String quizId, int score, int pointsReward) async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');
      
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) throw Exception('User document not found');
      
      final user = UserModel.fromMap({'id': userId, ...userDoc.data()!});
      
      // Points awarded based on score percentage
      final pointsEarned = (pointsReward * score / 100).round();
      final updatedPoints = user.points + pointsEarned;
      final updatedLevel = _calculateLevel(updatedPoints);
      
      await _firestore.collection('users').doc(userId).update({
        'points': updatedPoints,
        'level': updatedLevel,
        'completedQuizzes': FieldValue.arrayUnion(["$courseId:$quizId"]),
        'quizScores.$courseId.$quizId': score,
      });
    } catch (e) {
      print('Error completing quiz: $e');
      rethrow;
    }
  }
  
  // Get user progress data
  Future<Map<String, dynamic>> getUserProgressData() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');
      
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (!userDoc.exists) throw Exception('User document not found');
      
      final userData = userDoc.data()!;
      
      return {
        'points': userData['points'] ?? 0,
        'level': userData['level'] ?? 1,
        'badges': userData['badges'] ?? [],
        'completedCourses': userData['completedCourses'] ?? [],
        'enrolledCourses': userData['enrolledCourses'] ?? [],
        'progress': userData['progress'] ?? {},
        'completedLessons': userData['completedLessons'] ?? [],
        'completedQuizzes': userData['completedQuizzes'] ?? [],
        'quizScores': userData['quizScores'] ?? {},
      };
    } catch (e) {
      print('Error getting user progress data: $e');
      return {};
    }
  }
}