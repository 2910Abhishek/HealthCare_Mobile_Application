import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:aarogya/widgets/TextBox.dart';
import 'package:aarogya/widgets/customButton.dart';
import 'package:aarogya/widgets/customButtonForGoogle.dart';
import 'package:aarogya/resources/auth_service.dart'; // Import AuthService

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  final AuthService _authService = AuthService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _signUpWithEmailAndPassword() async {
    setState(() {
      _isLoading = true;
    });
    _controller.forward();

    if (_nameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      _showErrorDialog('Please fill all fields');
      setState(() {
        _isLoading = false;
      });
      _controller.reverse();
      return;
    }

    try {
      final String? uid = await _authService.signUpWithEmailAndPassword(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );

      if (uid != null) {
        await _firestore.collection('users').doc(uid).set({
          'username': _nameController.text.trim(),
          'phone': _phoneController.text.trim(),
          'email': _emailController.text.trim(),
        });

        Navigator.pushReplacementNamed(context, '/home');
      } else {
        _showErrorDialog('Failed to create account');
      }
    } catch (e) {
      print('Error signing up: $e');
      _showErrorDialog('Error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
      _controller.reverse();
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
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

  @override
  Widget build(BuildContext context) {
    const spinkit = SpinKitRotatingCircle(
      color: Color.fromARGB(255, 0, 0, 0),
      size: 50.0,
    );

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Opacity(
              opacity: _isLoading ? 0.5 : 1.0,
              child: AbsorbPointer(
                absorbing: _isLoading,
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
                                  Navigator.pushNamed(context, '/');
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
                                  onPressed: () async {
                                    // Implement sign in with Google
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
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
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
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
            ),
            if (_isLoading)
              FadeTransition(
                opacity: _animation,
                child: Center(child: spinkit),
              ),
          ],
        ),
      ),
    );
  }
}
