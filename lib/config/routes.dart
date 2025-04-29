import 'package:flutter/material.dart';
import 'package:wellbeingu/screens/auth/login_screen.dart';
import 'package:wellbeingu/screens/home/home_screen.dart';
import 'package:wellbeingu/screens/courses/course_detail_screen.dart';
import 'package:wellbeingu/screens/auth/register_screen.dart';
import 'package:wellbeingu/screens/courses/courses_screen.dart';
import 'package:wellbeingu/screens/profile/profile_screen.dart';
import 'package:wellbeingu/screens/gamification/achievements_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String courses = '/courses';
  static const String courseDetail = '/courses-detail';
  static const String profile = '/profile';
  static const String achievements = '/achievements';

  static Map<String, WidgetBuilder> get routes => {
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    home: (context) => const HomeScreen(),
    courses: (context) => const CoursesScreen(),
    courseDetail: (context) => const CourseDetailScreen(courseId: '',),
    profile: (context) => const ProfileScreen(),
    achievements: (context) => const AchievementsScreen(),
  };
}