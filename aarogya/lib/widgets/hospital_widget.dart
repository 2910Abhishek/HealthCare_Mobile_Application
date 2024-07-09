import 'package:flutter/material.dart';

class HospitalCardWidget extends StatelessWidget {
  HospitalCardWidget(
      {Key? key, required this.hospitalName, required this.hospitalAddress});

  final String hospitalName;
  final String hospitalAddress;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width * 0.4,
              height: 150, // Adjust as per your image aspect ratio
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  bottomLeft: Radius.circular(10),
                ),
                image: DecorationImage(
                  image: AssetImage(
                    'assets/images/doctor_image.png', // Replace with your image path
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hospitalName,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black, // Text color
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      hospitalAddress,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[700], // Text color
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
