import 'package:flutter/material.dart';
import 'package:wellbeingu/models/course_model.dart';

class CourseListItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const CourseListItem({
    super.key,
    required this.title,
    required this.onTap, required int progress, required CourseModel course, required bool isCompleted, required bool isEnrolled,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward),
      onTap: onTap,
    );
  }
}
