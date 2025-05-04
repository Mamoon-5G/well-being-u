import 'package:flutter/material.dart';
import '../models/quiz_model.dart'; // Make sure to import the correct file

class QuizCard extends StatefulWidget {
  final Question question;  // Use the Question model

  const QuizCard({super.key, required this.question});

  @override
  State<QuizCard> createState() => _QuizCardState();
}

class _QuizCardState extends State<QuizCard> {
  int? selectedIndex; // Track selected option
  bool isAnswered = false; // Check if the question has been answered

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the question
            Text(widget.question.question, 
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            
            // Display options as radio buttons
            ...List.generate(widget.question.options.length, (index) {
              final isCorrect = index == widget.question.correctAnswerIndex;

              return RadioListTile<int>(
                title: Text(widget.question.options[index]),
                value: index,
                groupValue: selectedIndex,
                onChanged: isAnswered
                    ? null  // Disable changing option once answered
                    : (value) {
                        setState(() {
                          selectedIndex = value!;
                          isAnswered = true;
                        });
                      },
                selected: selectedIndex == index,
                activeColor: isAnswered
                    ? (isCorrect ? Colors.green : Colors.red)  // Show correct/incorrect color
                    : Theme.of(context).primaryColor,
              );
            }),
            
            // Display correct/incorrect message after answering
            if (isAnswered)
              Text(
                selectedIndex == widget.question.correctAnswerIndex ? 'Correct!' : 'Wrong Answer',
                style: TextStyle(
                  color: selectedIndex == widget.question.correctAnswerIndex ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
