import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wellbeingu3/screens/course_detail_screen.dart';
import 'package:wellbeingu3/screens/courses_screen.dart';
import 'package:wellbeingu3/screens/home_screen.dart';
import 'package:wellbeingu3/screens/profile_screen.dart';
import 'package:wellbeingu3/screens/achievements_screen.dart';
import 'package:wellbeingu3/models/course_model.dart'; // Assuming you have a CourseModel

class MainScreen extends StatefulWidget {
  final String name;
  const MainScreen({super.key, required this.name});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<CourseModel> enrolledCourses = [];

  final List<Widget> _screens = [];

  @override
  void initState() {
    super.initState();
    final String userEmail = FirebaseAuth.instance.currentUser?.email ?? 'No Email';

    // Add the different screens
    _screens.addAll([
      HomeScreen(name: widget.name),
      const CoursesScreen(),
      const AchievementsScreen(),
      ProfileScreen(
        name: widget.name,
        email: userEmail,
      ),
    ]);

    // Fetch enrolled courses
    fetchEnrolledCourses();
  }

  // Fetch enrolled courses from Firestore
Future<void> fetchEnrolledCourses() async {
  final userId = FirebaseAuth.instance.currentUser!.uid;
  try {
    // Fetch enrolled courses
    final coursesSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('enrollments')
        .get();

    final coursesList = await Future.wait(coursesSnapshot.docs.map((doc) async {
      final courseId = doc.id;
      
      // Fetch course details including imageUrl
      final courseDoc = await FirebaseFirestore.instance
          .collection('courses')
          .doc(courseId)
          .get();

      final courseData = courseDoc.data();
      if (courseData != null) {
        return CourseModel.fromMap(courseId, courseData);
      }
      return null;
    }).toList());

    setState(() {
      enrolledCourses = coursesList.whereType<CourseModel>().toList();
    });
  } catch (e) {
    print("Error fetching enrolled courses: $e");
  }
}

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('Welcome, ${widget.name}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ],
        ),
        backgroundColor: const Color(0xFF1B3CC7),
        elevation: 0,
      ),
      body: _selectedIndex == 0 // If Home Screen is selected
          ? Column(
              children: [
                // Display enrolled courses
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  child: Text(
                    'Your Enrolled Courses',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                ),
                if (enrolledCourses.isEmpty)
                  const Center(child: Text('No enrolled courses yet.'))
                else
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 1.5,
                      ),
                      itemCount: enrolledCourses.length,
                      itemBuilder: (context, index) {
                        final course = enrolledCourses[index];
                        return CourseCard(course: course);
                      },
                    ),
                  ),
              ],
            )
          : _screens[_selectedIndex], // For other screens like Courses, Achievements, Profile
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Color(0xFF1B3CC7),
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: 'Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Achievements',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// CourseCard Widget
class CourseCard extends StatelessWidget {
  final CourseModel course;

  const CourseCard({Key? key, required this.course}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailScreen(course: course), // <-- You must have this screen
          ),
        );
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                course.title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              const SizedBox(height: 8),
              Text(
                course.description ?? 'No description available',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
