import 'package:aarogya/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:aarogya/widgets/TextBox.dart';
import 'package:aarogya/widgets/customButton.dart';
import 'package:aarogya/widgets/customButtonForGoogle.dart';
import 'package:aarogya/resources/auth_service.dart'; // Import AuthService

class LogInScreen extends StatefulWidget {
  const LogInScreen({Key? key});

  @override
  State<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen>
    with TickerProviderStateMixin {
  final AuthService _authMethods = AuthService();

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

  Future<void> _signInWithEmailAndPassword() async {
    setState(() {
      _isLoading = true;
    });
    _controller.forward();

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog('Please fill all fields');
      setState(() {
        _isLoading = false;
      });
      _controller.reverse();
      return;
    }

    try {
      final String? uid =
          await _authMethods.signInWithEmailAndPassword(email, password);

      if (uid != null) {
        Navigator.pushNamed(context, '/home');
      } else {
        _showErrorDialog('Invalid email or password. Please try again.');
      }
    } catch (e) {
      print('Error signing in: $e');
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
    final spinkit = SpinKitFadingFour(
      color: Colors.black,
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
                                  Navigator.pushNamed(context, '/profile');
                                },
                                child: Icon(
                                  Icons.arrow_back_sharp,
                                  size: 36,
                                  color: buttonColor,
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
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    _controller.forward();

                                    final bool res =
                                        await _authMethods.signInWithGoogle();

                                    if (res) {
                                      Navigator.pushNamed(context, '/home');
                                    }

                                    setState(() {
                                      _isLoading = false;
                                    });
                                    _controller.reverse();
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
                        padding: EdgeInsets.symmetric(vertical: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Text(
                                "Don't have an account? ",
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ),
                            SizedBox(width: 5),
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
