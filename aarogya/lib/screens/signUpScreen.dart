import 'package:aarogya/widgets/TextBox.dart';
import 'package:aarogya/widgets/customButton.dart';
import 'package:aarogya/widgets/customButtonForGoogle.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 35),
                InkWell(
                  onTap: () {
                    // Handle onTap for your icon button
                  },
                  child: Icon(
                    Icons.arrow_back_sharp,
                    size: 36,
                    color: const Color.fromARGB(255, 175, 96, 66),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Let's Get Started",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Text(
                  "Create an account to continue",
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(height: 35),
                TextBox(
                  text: 'Enter your full name',
                  icon: Icon(Icons.person),
                  keyboardType: TextInputType.name,
                ),
                SizedBox(height: 20),
                TextBox(
                  text: 'Enter your phone number',
                  icon: Icon(Icons.phone),
                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 20),
                TextBox(
                  text: 'Enter your email',
                  icon: Icon(Icons.email),
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 20),
                TextBox(
                  text: 'Enter your Password',
                  icon: Icon(Icons.lock),
                  keyboardType: TextInputType.text,
                  obscureText: true,
                ),
                SizedBox(height: 20),
                CustomButton(text: 'Create Account'),
                SizedBox(height: 15),
                Center(
                  child: Text(
                    "OR",
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Center(
                  child: CustomButtonForGoogle(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
