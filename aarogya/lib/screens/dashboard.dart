import 'package:aarogya/resources/auth_methods.dart';
import 'package:aarogya/widgets/customButton.dart';
import 'package:flutter/material.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({super.key});

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  AuthMethods _authMethods = AuthMethods();
  @override
  Widget build(BuildContext context) {
    return Center(
        child: CustomButton(
            text: "Sign Out ",
            onPressed: () {
              _authMethods.signOut();
            }));
  }
}
