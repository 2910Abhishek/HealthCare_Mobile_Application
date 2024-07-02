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
              const SizedBox(height: 20),
              TextBox(
                text: 'Enter your full name',
                icon: const Icon(Icons.person_2),
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 20),
              TextBox(
                text: 'Enter your phone number',
                icon: const Icon(Icons.local_phone_sharp),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              TextBox(
                text: 'Enter your email',
                icon: const Icon(Icons.email_outlined),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              TextBox(
                text: 'Enter your Password',
                icon: const Icon(Icons.lock),
                keyboardType: TextInputType.none,
                obscureText: true,
              ),
              const SizedBox(height: 20),
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
