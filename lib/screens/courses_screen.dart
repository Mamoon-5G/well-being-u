import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellbeingu3/models/course_model.dart';
import 'package:wellbeingu3/screens/course_detail_screen.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  final List<String> tabs = ['All', 'Mental Health', 'Nutrition'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tabs.length, vsync: this);
  }

  Stream<QuerySnapshot> _getCourses(String category) {
    final collection = FirebaseFirestore.instance.collection('courses');
    if (category == 'All') {
      return collection.snapshots();
    } else {
      return collection.where('category', isEqualTo: category).snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Color(0xFF1B3CC7),
          unselectedLabelColor: Colors.grey,
          indicatorColor: Color(0xFF1B3CC7),
          tabs: tabs.map((tab) => Tab(text: tab)).toList(),
        ),
        title: const Text('Courses', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: TabBarView(
        controller: _tabController,
        children: tabs.map((category) {
          return StreamBuilder<QuerySnapshot>(
            stream: _getCourses(category),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No courses available.'));
              }

              List<CourseModel> courses = snapshot.data!.docs.map((doc) {
                return CourseModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
              }).toList();

              return ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final course = courses[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: ListTile(
                      leading: Image.network(course.imageUrl, width: 50, height: 50, fit: BoxFit.cover),
                      title: Text(course.title),
                      subtitle: Text(course.description.length > 50
                          ? '${course.description.substring(0, 50)}...'
                          : course.description),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => CourseDetailScreen(course: course)),
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
