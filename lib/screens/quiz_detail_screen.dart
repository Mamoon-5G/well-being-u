import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wellbeingu3/models/quiz_model.dart';

class QuizDetailScreen extends StatefulWidget {
  final QuizModel quiz;
  final String courseId; // Add courseId here

  const QuizDetailScreen({super.key, required this.quiz, required this.courseId});

  @override
  State<QuizDetailScreen> createState() => _QuizDetailScreenState();
}

class _QuizDetailScreenState extends State<QuizDetailScreen> {
  int currentQuestionIndex = 0;
  int? selectedOptionIndex;
  int score = 0;

  void _nextQuestion() {
    // Check if the selected answer is correct
    if (selectedOptionIndex == widget.quiz.questions[currentQuestionIndex].correctAnswerIndex) {
      score++;
    }

    // Move to the next question or show the result dialog if it's the last question
    if (currentQuestionIndex < widget.quiz.questions.length - 1) {
      setState(() {
        currentQuestionIndex++;
        selectedOptionIndex = null;
      });
    } else {
      _showResult();
    }
  }

  void _showResult() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('quiz_results')
          .doc(widget.quiz.id)
          .set({
        'courseId': widget.courseId,
        'quizTitle': widget.quiz.title,
        'score': score,
        'total': widget.quiz.questions.length,
        'completedAt': Timestamp.now(),
      });
    }

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Quiz Completed'),
        content: Text('Your score: $score / ${widget.quiz.questions.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Exit quiz screen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.quiz.questions[currentQuestionIndex]; // Accessing current question

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.title),
        backgroundColor: const Color(0xFF1B3CC7),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Question ${currentQuestionIndex + 1}/${widget.quiz.questions.length}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1B3CC7)),
            ),
            const SizedBox(height: 20),
            Text(
              question.question, // Display question text
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            ...List.generate(question.options.length, (index) {
              final option = question.options[index]; // Get option text
              final isSelected = selectedOptionIndex == index;

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedOptionIndex = index; // Update selected option
                  });
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF1B3CC7).withOpacity(0.1) : Colors.white,
                    border: Border.all(
                      color: isSelected ? const Color(0xFF1B3CC7) : Colors.grey.shade300,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(option, style: TextStyle(color: isSelected ? const Color(0xFF1B3CC7) : Colors.black)),
                ),
              );
            }),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: selectedOptionIndex != null ? _nextQuestion : null, // Enable button only if option is selected
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B3CC7),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text(
                  currentQuestionIndex == widget.quiz.questions.length - 1 ? 'Submit' : 'Next', // Button text based on position
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
