import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wellbeingu3/models/lesson_model.dart';
import 'package:wellbeingu3/screens/lesson_detail_screen.dart';
import '../models/course_model.dart';

class CourseDetailScreen extends StatefulWidget {
  final CourseModel course;
  const CourseDetailScreen({super.key, required this.course});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  bool isEnrolled = false;
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    checkEnrollment();
  }

  Future<void> checkEnrollment() async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .collection('enrollments')
        .doc(widget.course.id)
        .get();

    setState(() {
      isEnrolled = doc.exists;
    });
  }

  Future<void> enrollUser() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser!.uid)
        .collection('enrollments')
        .doc(widget.course.id)
        .set({'enrolledAt': Timestamp.now()});

    setState(() {
      isEnrolled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.course.title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              widget.course.imageUrl,
              height: 200,
              errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
            ),
            const SizedBox(height: 10),
            Text(
              widget.course.description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            if (isEnrolled) ...[
              const Text(
                'Lessons',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('courses')
                      .doc(widget.course.id) // ✅ FIXED HERE
                      .collection('lessons')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No lessons available.'));
                    }

                    List<LessonModel> lessons =
                        snapshot.data!.docs.map((doc) {
                      return LessonModel.fromMap(
                        doc.id,
                        doc.data() as Map<String, dynamic>,
                        widget.course.id, // ✅ FIXED HERE
                      );
                    }).toList();

                    return ListView.builder(
                      itemCount: lessons.length,
                      itemBuilder: (context, index) {
                        final lesson = lessons[index];
                        return ListTile(
                          title: Text(lesson.title),
                          subtitle: Text(
                            lesson.content.length > 50
                                ? '${lesson.content.substring(0, 50)}...'
                                : lesson.content,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    LessonDetailScreen(lesson: lesson),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isEnrolled ? Colors.grey : const Color(0xFF1B3CC7),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          onPressed: isEnrolled ? null : enrollUser,
          child: Text(
            isEnrolled ? 'Enrolled' : 'Enroll Now',
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
