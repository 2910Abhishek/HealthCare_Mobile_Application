import 'dart:convert';

import 'package:aarogya/screens/bookAppointmentScreen.dart';
import 'package:flutter/material.dart';

class DoctorCard extends StatelessWidget {
  final String hospitalName;
  final String name;
  final String speciality;
  final String imagePath;
  final String address;
  final int doctorId; // Add doctorId

  DoctorCard({
    required this.hospitalName,
    required this.name,
    required this.speciality,
    required this.imagePath,
    required this.address,
    required this.doctorId, // Accept doctorId
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate to the BookAppointmentScreen when the doctor card is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookAppointmentScreen(
              doctorName: name,
              speciality: speciality,
              hospitalName: hospitalName,
              imagePath: imagePath,
              doctorId: doctorId, // Pass doctorId dynamically
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage:
                    imagePath.startsWith('data:image/jpeg;base64,') ||
                            imagePath.startsWith('data:image/png;base64,')
                        ? MemoryImage(base64Decode(imagePath
                            .split(',')
                            .last)) // Decode and load base64 image
                        : AssetImage('assets/images/doctor_image.png')
                            as ImageProvider, // Fallback to asset image
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      speciality,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      address,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
