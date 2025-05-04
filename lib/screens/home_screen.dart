import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final String name;
  const HomeScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Hello $name 👋\nWelcome to WellBeingU!',
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 24),
      ),
    );
  }
}
