import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellbeingu/models/course_model.dart';
import 'package:wellbeingu/providers/auth_provider.dart';
import 'package:wellbeingu/providers/course_provider.dart';
import 'package:wellbeingu/providers/progress_provider.dart';
import 'package:wellbeingu/screens/courses/course_detail_screen.dart';
import 'package:wellbeingu/screens/courses/courses_screen.dart';
import 'package:wellbeingu/screens/profile/profile_screen.dart';
import 'package:wellbeingu/screens/gamification/achievements_screen.dart';
import 'package:wellbeingu/widgets/course_card.dart';
import 'package:wellbeingu/widgets/level_indicator.dart';
import 'package:wellbeingu/config/theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  final List<Widget> _screens = [
    const HomeContent(),
    const CoursesScreen(),
    const AchievementsScreen(),
    const ProfileScreen(),
  ];
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  Future<void> _loadData() async {
    final courseProvider = Provider.of<CourseProvider>(context, listen: false);
    final progressProvider = Provider.of<ProgressProvider>(context, listen: false);
    
    await Future.wait([
      courseProvider.loadCourses(),
      courseProvider.loadBadges(),
      progressProvider.loadUserProgress(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppTheme.primaryColor,
        unselectedItemColor: Colors.grey,
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

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final courseProvider = Provider.of<CourseProvider>(context);
    final progressProvider = Provider.of<ProgressProvider>(context);
    
    final recommenedCourses = courseProvider.getRecommendedCourses();
    final mentalHealthCourses = courseProvider.getMentalHealthCourses();
    final nutritionCourses = courseProvider.getNutritionCourses();
    
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await Provider.of<CourseProvider>(context, listen: false).loadCourses();
          await Provider.of<ProgressProvider>(context, listen: false).loadUserProgress();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User greeting and level
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, ${authProvider.user?.name ?? 'User'}',
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Level ${progressProvider.level} • ${progressProvider.points} points',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: AppTheme.primaryColor,
                      child: Text(
                        authProvider.user?.name.substring(0, 1).toUpperCase() ?? 'U',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Level progress
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: LevelIndicator(
                  level: progressProvider.level,
                  points: progressProvider.points,
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Continue learning section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'Continue Learning',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
              ),
              
              const SizedBox(height: 12),
              
              SizedBox(
                height: 160,
                child: progressProvider.enrolledCourses.isEmpty
                    ? const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Center(
                          child: Text(
                            'You haven\'t enrolled in any courses yet. \nExplore our courses to get started!',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        itemCount: progressProvider.enrolledCourses.length,
                        itemBuilder: (context, index) {
                          final courseId = progressProvider.enrolledCourses[index];
                          final course = courseProvider.courses.firstWhere(
                            (c) => c.id == courseId,
                            orElse: () => CourseModel(
                              id: '',
                              title: 'Loading...',
                              description: '',
                              imageUrl: '',
                              category: '',
                              pointsReward: 0,
                              badgeId: '',
                              lessons: [],
                              quizzes: [],
                              difficulty: 1,
                              estimatedMinutes: 0,
                            ),
                          );
                          
                          final progress = progressProvider.getCourseProgress(courseId);
                          
                          return CourseCard(
                            course: course,
                            progress: progress,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => CourseDetailScreen(courseId: courseId),
                                ),
                              );
                            }, title: 'Course Card', description: 'This is course card',
                          );
                        },
                      ),
              ),
              
              const SizedBox(height: 24),
              
              // Recommended courses section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Recommended For You',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => const CoursesScreen()),
                        );
                      },
                      child: const Text('See All'),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
              SizedBox(
                height: 160,
                child: courseProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : recommenedCourses.isEmpty
                        ? const Center(child: Text('No courses available'))
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            itemCount: recommenedCourses.length > 5 ? 5 : recommenedCourses.length,
                            itemBuilder: (context, index) {
                              final course = recommenedCourses[index];
                              final progress = progressProvider.getCourseProgress(course.id);
                              return null;
                              
                              // return CourseCard(
                              //   course: course,
                              //   progress: progress,
                              //   onTap: () {
                              //     Navigator.of(context).push(
                              //       MaterialPageRoute(
                              //         builder: (_) => CourseDetailScreen(courseId: course.id),
                              //       ),
                              //     );
                              //   }, title: '', description: '',
                              // );
                            },
                          ),
              ),
              
              const SizedBox(height: 24),
              
              // Mental Health Courses section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Mental Health',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const CoursesScreen(initialCategory: 'mental_health'),
                          ),
                        );
                      },
                      child: const Text('See All'),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
              SizedBox(
                height: 160,
                child: courseProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : mentalHealthCourses.isEmpty
                        ? const Center(child: Text('No mental health courses available'))
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            itemCount: mentalHealthCourses.length > 5 ? 5 : mentalHealthCourses.length,
                            itemBuilder: (context, index) {
                              final course = mentalHealthCourses[index];
                              final progress = progressProvider.getCourseProgress(course.id);
                              return null;
                              
                              // return CourseCard(
                              //   course: course,
                              //   progress: progress,
                              //   onTap: () {
                              //     Navigator.of(context).push(
                              //       MaterialPageRoute(
                              //         builder: (_) => CourseDetailScreen(courseId: course.id),
                              //       ),
                              //     );
                              //   },
                              // );
                            },
                          ),
              ),
              
              const SizedBox(height: 24),
              
              // Nutrition Courses section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Nutrition',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const CoursesScreen(initialCategory: 'nutrition'),
                          ),
                        );
                      },
                      child: const Text('See All'),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
              SizedBox(
                height: 160,
                child: courseProvider.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : nutritionCourses.isEmpty
                        ? const Center(child: Text('No nutrition courses available'))
                        : ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            itemCount: nutritionCourses.length > 5 ? 5 : nutritionCourses.length,
                            itemBuilder: (context, index) {
                              final course = nutritionCourses[index];
                              final progress = progressProvider.getCourseProgress(course.id);
                              return null;
                              
                              // return CourseCard(
                              //   course: course,
                              //   progress: progress,
                              //   onTap: () {
                              //     Navigator.of(context).push(
                              //       MaterialPageRoute(
                              //         builder: (_) => CourseDetailScreen(courseId: course.id),
                              //       ),
                              //     );
                              //   },
                              // );
                            },
                          ),
              ),
              
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}