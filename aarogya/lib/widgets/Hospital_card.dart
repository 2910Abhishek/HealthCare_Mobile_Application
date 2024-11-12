import 'package:flutter/material.dart';
import 'package:aarogya/screens/DoctorScreen.dart'; // Ensure the import path is correct

class HospitalCard extends StatelessWidget {
  final String name;
  final String imagePath;
  final String address;

  HospitalCard({
    Key? key,
    required this.name,
    required this.imagePath,
    required this.address,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to DoctorScreen and pass the selected hospital name
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DoctorScreen(hospitalName: name),
          ),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(imagePath),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
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
