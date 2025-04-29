import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wellbeingu/providers/progress_provider.dart';
import 'package:wellbeingu/models/course_model.dart';
import 'package:wellbeingu/config/theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:confetti/confetti.dart';

class LessonScreen extends StatefulWidget {
  final String courseId;
  final LessonModel lesson;
  
  const LessonScreen({super.key, required this.courseId, required this.lesson});

  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _showCompleteButton = false;
  bool _hasReachedEnd = false;
  late ConfettiController _confettiController;
  
  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    
    // Listen to scroll events to determine if user has reached the end
    _scrollController.addListener(_scrollListener);
    
    // Check if lesson is already completed
    _checkLessonStatus();
  }
  
  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    _confettiController.dispose();
    super.dispose();
  }
  
  void _scrollListener() {
    // Show the complete button when user scrolls to the bottom
    if (_scrollController.offset >= _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      if (!_hasReachedEnd) {
        setState(() {
          _hasReachedEnd = true;
          _showCompleteButton = true;
        });
      }
    }
  }
  
  Future<void> _checkLessonStatus() async {
    final progressProvider = Provider.of<ProgressProvider>(context, listen: false);
    final isCompleted = progressProvider.hasCompletedLesson(
      widget.courseId,
      widget.lesson.id,
    );
    
    setState(() {
      _showCompleteButton = isCompleted;
      _hasReachedEnd = isCompleted;
    });
  }
  
  Future<void> _completeLesson() async {
    final progressProvider = Provider.of<ProgressProvider>(context, listen: false);
    
    // If already completed, don't award points again
    if (progressProvider.hasCompletedLesson(widget.courseId, widget.lesson.id)) {
      return;
    }
    
    await progressProvider.completeLesson(
      widget.courseId,
      widget.lesson.id,
      widget.lesson.pointsReward,
    );
    
    _confettiController.play();
  }

  @override
  Widget build(BuildContext context) {
    final progressProvider = Provider.of<ProgressProvider>(context);
    final isCompleted = progressProvider.hasCompletedLesson(
      widget.courseId,
      widget.lesson.id,
    );
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Chip(
              backgroundColor: AppTheme.accentColor.withOpacity(0.2),
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star, size: 16, color: AppTheme.accentColor),
                  const SizedBox(width: 4),
                  Text(
                    '${widget.lesson.pointsReward} pts',
                    style: const TextStyle(
                      color: AppTheme.accentColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Lesson content
          SingleChildScrollView(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Media content (if available)
                if (widget.lesson.mediaUrls.isNotEmpty)
                  ...widget.lesson.mediaUrls.map((mediaUrl) {
                    if (mediaUrl.contains('.mp4')) {
                      // Video placeholder
                      return Container(
                        height: 200,
                        width: double.infinity,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.play_circle_fill,
                            color: Colors.white,
                            size: 48,
                          ),
                        ),
                      );
                    } else {
                      // Image
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          imageUrl: mediaUrl,
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: Colors.grey[300],
                            child: const Center(child: CircularProgressIndicator()),
                                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                      );
                    }
                  }).toList(),

                const SizedBox(height: 16),

                // Lesson description
                Text(
                  widget.lesson.content,
                  style: const TextStyle(fontSize: 16, height: 1.5),
                ),
                const SizedBox(height: 100), // Add spacing to allow scroll
              ],
            ),
          ),

          // Confetti animation
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange],
              numberOfParticles: 30,
              emissionFrequency: 0.05,
            ),
          ),

          // Complete Lesson button
          if (_showCompleteButton && !isCompleted)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.accentColor,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: _completeLesson,
                  icon: const Icon(Icons.check_circle),
                  label: const Text(
                    'Mark as Complete',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),

          if (isCompleted)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  onPressed: null,
                  icon: const Icon(Icons.check),
                  label: const Text(
                    'Already Completed',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
