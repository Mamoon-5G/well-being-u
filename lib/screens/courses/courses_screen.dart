import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellbeingu/providers/course_provider.dart';
import 'package:wellbeingu/providers/progress_provider.dart';
import 'package:wellbeingu/screens/courses/course_detail_screen.dart';
import 'package:wellbeingu/widgets/course_list_item.dart';
import 'package:wellbeingu/config/theme.dart';

class CoursesScreen extends StatefulWidget {
  final String? initialCategory;
  
  const CoursesScreen({super.key, this.initialCategory});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    
    if (widget.initialCategory != null) {
      // Set initial tab based on category
      if (widget.initialCategory == 'mental_health') {
        _tabController.animateTo(1);
      } else if (widget.initialCategory == 'nutrition') {
        _tabController.animateTo(2);
      }
    }
    
    _loadData();
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  
  Future<void> _loadData() async {
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    await courseProvider.loadCourses();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Courses'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryColor,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppTheme.primaryColor,
          tabs: const [
            Tab(text: 'All'),
            Tab(text: 'Mental Health'),
            Tab(text: 'Nutrition'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _CourseList(category: null),
          _CourseList(category: 'mental_health'),
          _CourseList(category: 'nutrition'),
        ],
      ),
    );
  }
}

class _CourseList extends StatelessWidget {
  final String? category;
  
  const _CourseList({this.category});

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);
    final progressProvider = Provider.of<ProgressProvider>(context);
    
    final courses = category == null
        ? courseProvider.courses
        : category == 'mental_health'
            ? courseProvider.getMentalHealthCourses()
            : courseProvider.getNutritionCourses();
    
    if (courseProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    
    if (courses.isEmpty) {
      return Center(
        child: Text(
          category == null
              ? 'No courses available'
              : 'No ${category == 'mental_health' ? 'mental health' : 'nutrition'} courses available',
        ),
      );
    }
    
    return RefreshIndicator(
      onRefresh: () async {
        await Provider.of<CourseProvider>(context, listen: false).loadCourses();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          final progress = progressProvider.getCourseProgress(course.id);
          final isCompleted = progressProvider.isCourseCompleted(course.id);
          final isEnrolled = progressProvider.isCourseEnrolled(course.id);
          
          return CourseListItem(
            course: course,
            progress: progress,
            isCompleted: isCompleted,
            isEnrolled: isEnrolled,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => CourseDetailScreen(courseId: course.id),
                ),
              );
            }, title: 'Course',
          );
        },
      ),
    );
  }
}