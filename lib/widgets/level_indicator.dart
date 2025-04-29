import 'package:flutter/material.dart';

class LevelIndicator extends StatelessWidget {
  final int level;

  const LevelIndicator({super.key, required this.level, required int points});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text('Level $level'),
      backgroundColor: Colors.blue.shade100,
    );
  }
}
