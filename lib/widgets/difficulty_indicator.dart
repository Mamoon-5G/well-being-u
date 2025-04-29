import 'package:flutter/material.dart';

class DifficultyIndicator extends StatelessWidget {
  final String level;

  const DifficultyIndicator({super.key, required this.level, required int difficulty});

  Color get color {
    switch (level.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color),
      ),
      child: Text(
        level,
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
