import 'package:flutter/material.dart';

class HealthTracker extends StatefulWidget {
  const HealthTracker({super.key});

  @override
  State<HealthTracker> createState() => _HealthTrackerState();
}

class _HealthTrackerState extends State<HealthTracker> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Welcome to Healthtracker Screen!",
        style: TextStyle(fontSize: 24, color: Colors.black),
      ),
    );
  }
}
