


import 'package:flutter/material.dart';
import 'package:aarogya/widgets/TextBox.dart';
import 'package:aarogya/widgets/customButton.dart';
import 'package:aarogya/widgets/customButtonForGoogle.dart';
import 'package:aarogya/resources/auth_service.dart'; // Import AuthService

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final AuthService _authService = AuthService(); // Instance of AuthService

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signUpWithEmailAndPassword() async {
    String? uid = await _authService.signUpWithEmailAndPassword(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (uid != null) {
      // Navigate to home screen or show success message
      print("Account created successfully");
      // Example: Navigate to home screen after successful sign-up
      // Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Show error message to the user
      print("Failed to create account");
    }
  }

  Future<void> _signInWithGoogle() async {
    String? uid = await _authService.signInWithGoogle();

    if (uid != null) {
      // Navigate to home screen or show success message
      print("Signed in with Google successfully");
      // Example: Navigate to home screen after successful sign-in
      // Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Show error message to the user
      print("Failed to sign in with Google");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 35),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                      SizedBox(height: 30),
                      Text(
                        "Let's Get Started",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
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
                        controller: _nameController,
                      ),
                      SizedBox(height: 20),
                      TextBox(
                        text: 'Enter your phone number',
                        icon: Icon(Icons.phone),
                        keyboardType: TextInputType.phone,
                        controller: _phoneController,
                      ),
                      SizedBox(height: 20),
                      TextBox(
                        text: 'Enter your email',
                        icon: Icon(Icons.email),
                        keyboardType: TextInputType.emailAddress,
                        controller: _emailController,
                      ),
                      SizedBox(height: 20),
                      TextBox(
                        text: 'Enter your Password',
                        icon: Icon(Icons.lock),
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        controller: _passwordController,
                      ),
                      SizedBox(height: 20),
                      CustomButton(
                        text: 'Create Account',
                        onPressed: _signUpWithEmailAndPassword,
                      ),
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
                        child: CustomButtonForGoogle(
                          onPressed: _signInWithGoogle,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.white,
              padding: EdgeInsets.symmetric(vertical: 15),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Have an account? ",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    SizedBox(width: 5),
                    Text(
                      "Sign In",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
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
