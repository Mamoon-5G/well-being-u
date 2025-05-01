import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class CourseUpload extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sample course JSON data
  final Map<String, dynamic> courseData = {
    "id": "course_1",
    "title": "Mental Health Awareness",
    "description": "A course to raise awareness about mental health.",
    "imageUrl": "https://example.com/image.jpg",
    "category": "mental_health",
    "pointsReward": 50,
    "badgeId": "badge_123",
    "lessons": [
      {
        "id": "lesson_1",
        "title": "Introduction to Mental Health",
        "content": "Content for intro to mental health.",
        "pointsReward": 10,
        "order": 1
      },
      {
        "id": "lesson_2",
        "title": "Mental Health Myths",
        "content": "Content for mental health myths.",
        "pointsReward": 15,
        "order": 2
      }
    ],
    "quizzes": [
      {
        "id": "quiz_1",
        "title": "Mental Health Basics Quiz",
        "pointsReward": 20,
        "questions": [
          {
            "id": "question_1",
            "text": "What is mental health?",
            "options": ["A", "B", "C", "D"],
            "correctOptionIndex": 0
          }
        ],
        "order": 1
      }
    ],
    "difficulty": 3,
    "estimatedMinutes": 60,
  };

  Future<void> uploadCourse() async {
    try {
      await _firestore.collection('courses').add(courseData);
      print('Course uploaded successfully!');
    } catch (e) {
      print('Error uploading course: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Course'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: uploadCourse,
          child: Text('Upload Course'),
        ),
      ),
    );
  }
}
