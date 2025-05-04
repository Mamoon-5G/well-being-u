import 'package:flutter/material.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final achievements = [
      {'title': 'Completed First Lesson', 'icon': Icons.check_circle_outline},
      {'title': 'Finished Mental Health Course', 'icon': Icons.emoji_emotions},
      {'title': 'Scored 100% in a Quiz', 'icon': Icons.star_border},
      // Add more as needed
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B3CC7),
        title: const Text("Achievements", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: achievements.isEmpty
          ? const Center(
              child: Text(
                'No achievements yet.',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: achievements.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final achievement = achievements[index];
                return Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8EDFC),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      )
                    ],
                  ),
                  child: ListTile(
                    leading: Icon(
                      achievement['icon'] as IconData,
                      color: const Color(0xFF1B3CC7),
                      size: 30,
                    ),
                    title: Text(
                      achievement['title'].toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1B3CC7),
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
