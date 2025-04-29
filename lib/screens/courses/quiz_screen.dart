import 'package:flutter/material.dart';
import 'package:wellbeingu/models/course_model.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key, required String courseId, required QuizModel quiz});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiz')),
      body: const Center(
        child: Text('Quiz content will be shown here.'),
      ),
    );
  }
}
