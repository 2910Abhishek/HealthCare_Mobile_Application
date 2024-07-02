import 'package:flutter/material.dart';

class TextBox extends StatelessWidget {
  const TextBox(
      {super.key,
      required this.text,
      required this.icon,
      required this.keyboardType,
      this.obscureText = false});
  final Icon icon;
  final text;
  final TextInputType keyboardType;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(
          width: 1.5,
          color: Colors.grey.shade400, // Border color
        ),
        borderRadius: BorderRadius.circular(40), // Rounded corners
      ),
      child: TextField(
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          prefixIcon: icon,
          hintText: text,
          border: InputBorder.none, // Remove the border of the TextField
          contentPadding: EdgeInsets.symmetric(vertical: 13, horizontal: 10),
        ),
      ),
    );
  }
}
