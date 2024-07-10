import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authChanges => _auth.authStateChanges();
  User get user => _auth.currentUser!;

  Future<bool> signInWithGoogle(BuildContext context) async {
    bool res = false;

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      User? user = userCredential.user;

      if (user != null) {
        // Store user data in Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'email': user.email,
          'username': user.displayName,
        });

        res = true;
      }
    } on FirebaseAuthException catch (e) {
      res = false;
      print("Error Signing in with Google: $e");
    }
    return res;
  }

  Future<bool> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    bool res = false;

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      res = true;
    } on FirebaseAuthException catch (e) {
      res = false;
      print("Error Signing in with email and password: $e");
    }

    return res;
  }

  void signOut() async {
    try {
      _auth.signOut();
    } catch (e) {
      print(e);
    }
  }
}
