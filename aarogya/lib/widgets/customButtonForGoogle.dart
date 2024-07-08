import 'package:aarogya/utils/colors.dart';
import 'package:flutter/material.dart';

class CustomButtonForGoogle extends StatelessWidget {
  const CustomButtonForGoogle({Key? key, required this.onPressed})
      : super(key: key);

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 50,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: buttonColor, // Light brownish color
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
                    color: buttonColor, // Light brownish color
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
