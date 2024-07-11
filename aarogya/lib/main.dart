import 'package:aarogya/screens/homescreen.dart';
import 'package:aarogya/screens/loginscreen.dart';
import 'package:aarogya/screens/onboardingscreen.dart';
import 'package:aarogya/screens/profilescreen.dart';
import 'package:aarogya/screens/signUpScreen.dart';
import 'package:aarogya/screens/tabsscreen.dart';
import 'package:aarogya/utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aarogya Health App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/onboarding': (context) => OnBoardingScreen(),
        '/login': (context) => const LogInScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const TabsScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (snapshot.hasData) {
            return const TabsScreen();
          }
          return OnBoardingScreen();
        },
      ),
    );
  }
}
