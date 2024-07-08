import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? _currentUser;
  String _username = '';
  String _email = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      setState(() {
        _currentUser = currentUser;
      });
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      if (userData.exists) {
        setState(() {
          _username = userData['username'];
          _email = userData['email'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(
            Icons.account_circle,
            size: 48,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/profile');
          },
        ),
        title: Text(
          "Hi, Welcome Back \n$_username",
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Your content goes here
          ],
        ),
      ),
    );
  }
}
