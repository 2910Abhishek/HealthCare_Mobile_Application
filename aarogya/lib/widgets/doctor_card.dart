import 'package:aarogya/screens/DoctorScreen.dart';
import 'package:aarogya/screens/bookAppointmentScreen.dart';
import 'package:flutter/material.dart';

class DoctorCard extends StatelessWidget {
  DoctorCard({
    Key? key,
    required this.name,
    required this.speciality,
    required this.imagePath,
    this.rating = "5.0",
    required this.address,
    required this.hospitalName,
  }) : super(key: key);

  final String name;
  final String speciality;
  final String imagePath;
  final String rating;
  final String address;
  final String hospitalName;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookAppointmentScreen(
              doctorName: name,
              speciality: speciality,
              hospitalName: hospitalName,
              imagePath: imagePath,
              rating: rating,
              doctorId: 1,
            ),
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
                      speciality,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Text(
                      address,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.yellow, size: 18),
                        SizedBox(width: 4),
                        Text(
                          rating,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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
