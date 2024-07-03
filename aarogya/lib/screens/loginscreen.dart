import 'package:flutter/material.dart';
import 'package:aarogya/widgets/TextBox.dart';
import 'package:aarogya/widgets/customButton.dart';
import 'package:aarogya/widgets/customButtonForGoogle.dart';
import 'package:aarogya/resources/auth_service.dart'; // Import AuthService

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  final AuthService _authService = AuthService(); // Instance of AuthService

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signInWithEmailAndPassword() async {
    String? uid = await _authService.signInWithEmailAndPassword(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (uid != null) {
      // Navigate to home screen or show success message
      print("Logged in successfully");
      // Example: Navigate to home screen after successful login
      // Navigator.pushReplacementNamed(context, '/home');
    } else {
      // Show error message to the user
      print("Failed to log in");
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
                        "Welcome back",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Log in to your account to continue",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 35),
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
                        text: 'Log In',
                        onPressed: _signInWithEmailAndPassword,
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
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/signup');
              },
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "Don't have an account? ",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ),
                    SizedBox(height: 5),
                    Center(
                      child: Text(
                        "Create Account",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
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
