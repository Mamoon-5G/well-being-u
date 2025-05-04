import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CourseUploadScreen extends StatefulWidget {
  const CourseUploadScreen({super.key});

  @override
  State<CourseUploadScreen> createState() => _CourseUploadScreenState();
}

class _CourseUploadScreenState extends State<CourseUploadScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  String _selectedCategory = 'Mental Health';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> uploadCourse() async {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    final imageUrl = _imageUrlController.text.trim();
    final category = _selectedCategory;

    if (title.isEmpty || description.isEmpty || imageUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    try {
      // Generate a new course document ID like course_2, course_3, etc.
      final coursesSnapshot = await _firestore.collection('courses').get();
      int courseNumber = coursesSnapshot.docs.length + 1;
      String newCourseId = 'course_$courseNumber';

      await _firestore.collection('courses').doc(newCourseId).set({
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'category': category,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Course "$title" uploaded as $newCourseId')),
      );

      _titleController.clear();
      _descriptionController.clear();
      _imageUrlController.clear();
    } catch (e) {
      print("Error uploading course: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to upload course')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload New Course'),
        backgroundColor: const Color(0xFF1B3CC7),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Course Title'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
              maxLines: 3,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _imageUrlController,
              decoration: const InputDecoration(labelText: 'Image URL'),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              items: const [
                DropdownMenuItem(value: 'Mental Health', child: Text('Mental Health')),
                DropdownMenuItem(value: 'Nutrition', child: Text('Nutrition')),
              ],
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedCategory = value;
                  });
                }
              },
              decoration: const InputDecoration(labelText: 'Category'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: uploadCourse,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF1B3CC7)),
              child: const Text('Upload Course'),
            ),
          ],
        ),
      ),
    );
  }
}
