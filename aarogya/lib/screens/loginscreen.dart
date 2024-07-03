import 'package:aarogya/resources/auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  final AuthMethods _authMethods = AuthMethods();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signInWithEmailAndPassword() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    bool res =
        await _authMethods.signInWithEmailAndPassword(email, password, context);

    if (res) {
      // Navigate to home screen or any other screen after successful login
      Navigator.pushNamed(context, '/home');
    } else {
      // Show error message or handle the failed login scenario
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Login Failed'),
          content: Text('Invalid email or password. Please try again.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
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
                          Navigator.pushNamed(context, '/signup');
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
                          onPressed: () async {
                            bool res =
                                await _authMethods.signInWithGoogle(context);
                            if (res) {
                              Navigator.pushNamed(context, '/home');
                            }
                          },
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
