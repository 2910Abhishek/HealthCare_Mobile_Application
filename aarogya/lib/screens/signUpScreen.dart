import 'package:aarogya/widgets/TextBox.dart';
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
      appBar: AppBar(
        title: Text('Aarogya'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: Image.asset('assets/images/onboarding_screen.png'),
              ),
              SizedBox(height: 20),
              TextBox(text: 'Sign Up with Email'),
              SizedBox(height: 20),
              TextBox(text: 'Password'),
              SizedBox(height: 20),
              Divider(
                thickness: 1,
                color: Colors.black,
              ), // Adjusted height for better spacing
            ],
          ),
        ),
      ),
    );
  }
}
