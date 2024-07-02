import 'package:flutter/material.dart';

class CustomButtonForGoogle extends StatelessWidget {
  const CustomButtonForGoogle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color:
                const Color.fromARGB(255, 175, 96, 66), // Light brownish color
          ),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 0.5),
              child: Image.asset(
                'assets/images/google.png', // Path to your image asset
                height: 24, // Adjust the height as needed
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  "Continue with Google",
                  style: TextStyle(
                    fontSize: 15,
                    color: const Color.fromARGB(
                        255, 175, 96, 66), // Light brownish color
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
