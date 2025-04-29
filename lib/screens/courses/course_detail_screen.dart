import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellbeingu/providers/course_provider.dart';
import 'package:wellbeingu/providers/progress_provider.dart';
import 'package:wellbeingu/screens/courses/lesson_screen.dart';
import 'package:wellbeingu/screens/courses/quiz_screen.dart';
import 'package:wellbeingu/widgets/difficulty_indicator.dart';
import 'package:wellbeingu/widgets/circular_progress_indicator.dart';
import 'package:wellbeingu/models/course_model.dart';
import 'package:wellbeingu/config/theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';

class CourseDetailScreen extends StatefulWidget {
  final String courseId;
  
  const CourseDetailScreen({super.key, required this.courseId});

  @override
  State<CourseDetailScreen> createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen> {
  late ConfettiController _confettiController;
  
  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _loadCourse();
  }
  
  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }
  
  Future<void> _loadCourse() async {
    await Provider.of<CourseProvider>(context, listen: false)
        .loadCourseById(widget.courseId);
  }
  
  Future<void> _enrollInCourse() async {
    await Provider.of<ProgressProvider>(context, listen: false)
        .enrollInCourse(widget.courseId);
  }
  
  void _startConfetti() {
    _confettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    final courseProvider = Provider.of<CourseProvider>(context);
    final progressProvider = Provider.of<ProgressProvider>(context);
    
    final course = courseProvider.selectedCourse;
    final badge = course != null ? courseProvider.getBadgeById(course.badgeId) : null;
    final progress = progressProvider.getCourseProgress(widget.courseId);
    final isEnrolled = progressProvider.isCourseEnrolled(widget.courseId);
    final isCompleted = progressProvider.isCourseCompleted(widget.courseId);
    
    if (courseProvider.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    if (course == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Course Details')),
        body: const Center(child: Text('Course not found')),
      );
    }
    
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(course.title),
                  background: CachedNetworkImage(
                    imageUrl: course.imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Container(
                      color: Colors.grey[300],
                      child: const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (context, url, error) => Container(
                      color: Colors.grey[300],
                      child: const Icon(Icons.error),
                    ),
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Course info and progress
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Category and difficulty
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: course.category == 'mental_health'
                                            ? Colors.blue.withOpacity(0.2)
                                            : Colors.green.withOpacity(0.2),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        course.category == 'mental_health'
                                            ? 'Mental Health'
                                            : 'Nutrition',
                                        style: TextStyle(
                                          color: course.category == 'mental_health'
                                              ? Colors.blue
                                              : Colors.green,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    DifficultyIndicator(difficulty: course.difficulty, level: 'H',),
                                  ],
                                ),
                                
                                const SizedBox(height: 8),
                                
                                // Estimated time
                                Row(
                                  children: [
                                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${course.estimatedMinutes} minutes',
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          
                          // Progress indicator
                          if (isEnrolled && !isCompleted)
                            CustomCircularProgressIndicator(
                              progress: progress / 100,
                              size: 50,
                              strokeWidth: 8,
                              backgroundColor: Colors.grey[300]!,
                              progressColor: AppTheme.primaryColor,
                              child: Text(
                                '$progress%',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          
                          // Completed indicator
                          if (isCompleted)
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check,
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Course description
                      Text(
                        'About this course',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(course.description),
                      
                      const SizedBox(height: 24),
                      
                      // Rewards section
                      Text(
                        'Rewards',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          // Points reward
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.amber.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${course.pointsReward} Points',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(width: 16),
                          
                          // Badge reward
                          if (badge != null)
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.purple.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.emoji_events,
                                    color: Colors.purple,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    badge.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Course content
                      Text(
                        'Course Content',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 16),
                      
                      // Lessons list
                      ...course.lessons.map((lesson) {
                        final isLessonCompleted = progressProvider.hasCompletedLesson(
                          course.id,
                          lesson.id,
                        );
                        
                        return ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isLessonCompleted
                                  ? Colors.green
                                  : AppTheme.primaryColor.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: isLessonCompleted
                                  ? const Icon(Icons.check, color: Colors.white)
                                  : Text(
                                      '${lesson.order + 1}',
                                      style: TextStyle(
                                        color: AppTheme.primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                          title: Text(lesson.title),
                          subtitle: Text(
                            'Lesson • ${lesson.pointsReward} points',
                            style: TextStyle(color: Colors.grey),
                          ),
                          trailing: isEnrolled
                              ? const Icon(Icons.arrow_forward_ios, size: 16)
                              : null,
                          enabled: isEnrolled,
                          onTap: isEnrolled
                              ? () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => LessonScreen(
                                        courseId: course.id,
                                        lesson: lesson,
                                      ),
                                    ),
                                  );
                                }
                              : null,
                        );
                      }).toList(),
                      
                      // Quizzes list
                      ...course.quizzes.map((quiz) {
                        final isQuizCompleted = progressProvider.hasCompletedQuiz(
                          course.id,
                          quiz.id,
                        );
                        final quizScore = progressProvider.getQuizScore(
                          course.id,
                          quiz.id,
                        );
                        
                        return ListTile(
                          leading: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: isQuizCompleted
                                  ? Colors.green
                                  : Colors.amber.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: isQuizCompleted
                                  ? const Icon(Icons.check, color: Colors.white)
                                  : const Icon(
                                      Icons.quiz,
                                      color: Colors.amber,
                                    ),
                            ),
                          ),
                          title: Text(quiz.title),
                          subtitle: Text(
                            quizScore != null
                                ? 'Quiz • Score: $quizScore%'
                                : 'Quiz • ${quiz.pointsReward} points',
                            style: TextStyle(color: Colors.grey),
                          ),
                          trailing: isEnrolled
                              ? const Icon(Icons.arrow_forward_ios, size: 16)
                              : null,
                          enabled: isEnrolled,
                          onTap: isEnrolled
                              ? () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => QuizScreen(
                                        courseId: course.id,
                                        quiz: quiz,
                                      ),
                                    ),
                                  );
                                }
                              : null,
                        );
                      }).toList(),
                      
                      const SizedBox(height: 100), // Space for the button
                    ],
                  ),
                ),
              ),
            ],
          ),
          
          // Enrollment button
          if (!isEnrolled)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: progressProvider.isLoading
                      ? null
                      : () async {
                          await _enrollInCourse();
                          _startConfetti();
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: progressProvider.isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Enroll Now'),
                ),
              ),
            ),
          
          // Confetti
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [
                Colors.green,
                Colors.blue,
                Colors.pink,
                Colors.orange,
                Colors.purple,
              ],
            ),
          ),
        ],
      ),
    );
  }
}