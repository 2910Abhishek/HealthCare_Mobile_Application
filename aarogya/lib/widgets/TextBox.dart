import 'package:flutter/material.dart';

class TextBox extends StatelessWidget {
  const TextBox({super.key, required this.text});

  final text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.5,
          color: Colors.grey.shade400, // Border color
        ),
        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: text,
          border: InputBorder.none, // Remove the border of the TextField
          contentPadding:
              EdgeInsets.symmetric(horizontal: 10), // Optional padding
        ),
      ),
    );
  }
}
