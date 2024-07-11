import 'package:aarogya/utils/colors.dart';
import 'package:flutter/material.dart';

class DoctorCategoryWidget extends StatelessWidget {
  const DoctorCategoryWidget(
      {super.key, required this.title, required this.icon});
  final String title;
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Icon(icon, size: 30, color: backgroundColor),
        ),
        SizedBox(height: 8),
        Text(title),
      ],
    );
  }
}
