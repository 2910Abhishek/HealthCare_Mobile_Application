import 'package:flutter/material.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({super.key});

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Center(
        child: Text(
          "Welcome to Records Screen!",
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
      ),
    );
  }
}
