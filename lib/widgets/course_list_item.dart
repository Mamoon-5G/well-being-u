import 'package:flutter/material.dart';
import 'package:wellbeingu/models/course_model.dart';

class CourseListItem extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final int progress;
  final CourseModel course;
  final bool isCompleted;
  final bool isEnrolled;

  const CourseListItem({
    super.key,
    required this.title,
    required this.onTap,
    required this.progress,
    required this.course,
    required this.isCompleted,
    required this.isEnrolled,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text(
        'Progress: $progress% | ${isEnrolled ? 'Enrolled' : 'Not Enrolled'} | ${isCompleted ? 'Completed' : 'In Progress'}',
      ),
      trailing: const Icon(Icons.arrow_forward),
      onTap: onTap,
    );
  }
}
