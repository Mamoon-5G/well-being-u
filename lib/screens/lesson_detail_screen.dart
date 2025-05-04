import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wellbeingu3/models/quiz_model.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../models/lesson_model.dart';
import 'quiz_detail_screen.dart';

class LessonDetailScreen extends StatefulWidget {
  final LessonModel lesson;

  const LessonDetailScreen({super.key, required this.lesson});

  @override
  State<LessonDetailScreen> createState() => _LessonDetailScreenState();
}

class _LessonDetailScreenState extends State<LessonDetailScreen> {
  late YoutubePlayerController _controller;
  late String? videoId;

  @override
  void initState() {
    super.initState();
    videoId = YoutubePlayerController.convertUrlToId(
      widget.lesson.videoUrl ?? '',
    );
    _controller = YoutubePlayerController.fromVideoId(
      videoId: videoId ?? '',
      autoPlay: false,
      params: const YoutubePlayerParams(
        showControls: true,
        showFullscreenButton: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool hasVideo = videoId != null && videoId!.isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
        backgroundColor: const Color(0xFF1B3CC7),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasVideo) ...[
                const Text(
                  "Lesson Video",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B3CC7),
                  ),
                ),
                const SizedBox(height: 10),
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: YoutubePlayer(controller: _controller),
                  ),
                ),
                const SizedBox(height: 20),
              ],
              const Text(
                "Lesson Content",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B3CC7),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                widget.lesson.content,
                style: const TextStyle(fontSize: 16, height: 1.6),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final courseId =
                      widget
                          .lesson
                          .courseId; // Ensure this is provided in your LessonModel
                  final quizDoc =
                      await FirebaseFirestore.instance
                          .collection('courses')
                          .doc(courseId)
                          .collection('quizzes')
                          .doc('quiz1') // You can make this dynamic later
                          .get();

                  if (quizDoc.exists) {
                    final quizData = quizDoc.data();
                    if (quizData != null) {
                      final quizModel = QuizModel.fromMap(quizDoc.id, quizData);
                      if (context.mounted) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => QuizDetailScreen(
                                  courseId: widget.lesson.courseId, // ✅ Pass courseId here
                                  quiz: quizModel,
                                ),
                          ),
                        );
                      }
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No quiz found for this lesson'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1B3CC7),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Start Quiz', style: TextStyle(fontSize: 16)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
