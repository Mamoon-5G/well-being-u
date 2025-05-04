import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuizUpload extends StatelessWidget {
  const QuizUpload({super.key});

  void uploadQuizData() async {
    // Quiz data
    final quizData = {
      "title": "Mental Health Basics",
      "questions": [
        {
          "question": "What is stress?",
          "options": ["A virus", "A hormone", "A response to pressure", "A vitamin"],
          "correctAnswerIndex": 2
        },
        {
          "question": "Which one helps reduce anxiety?",
          "options": ["Caffeine", "Exercise", "Isolation", "Overthinking"],
          "correctAnswerIndex": 1
        }
      ]
    };

    try {
      await FirebaseFirestore.instance
          .collection('courses')
          .doc('course_1')
          .collection('quizzes')
          .doc('quiz1')
          .set(quizData);
      debugPrint("✅ Quiz uploaded successfully");
    } catch (e) {
      debugPrint("❌ Failed to upload quiz: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Upload Quiz"),
        backgroundColor: const Color(0xFF1B3CC7),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: uploadQuizData,
          child: const Text("Upload Quiz to Firebase"),
        ),
      ),
    );
  }
}
