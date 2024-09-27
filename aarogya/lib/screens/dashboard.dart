import 'dart:io';

import 'package:aarogya/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _image;

  // Text field controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _bloodTypeController = TextEditingController();

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadProfile(); // Load user profile data when screen opens
  }

  // Load profile data from Firestore
  Future<void> _loadProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (doc.exists) {
        setState(() {
          _nameController.text = doc['name'] ?? '';
          _heightController.text = doc['height'] ?? '';
          _weightController.text = doc['weight'] ?? '';
          _ageController.text = doc['age'] ?? '';
          _bloodTypeController.text = doc['blood_type'] ?? '';
        });
      }
    }
  }

  // Save profile data to Firestore
  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;

        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'name': _nameController.text,
          'height': _heightController.text,
          'weight': _weightController.text,
          'age': _ageController.text,
          'blood_type': _bloodTypeController.text,
        }).then((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Profile saved successfully!')),
          );
        }).catchError((error) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save profile: $error')),
          );
        });

        setState(() {
          isEditing = false;
        });
      }
    }
  }

  // Sign out the user
  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context)
        .pushReplacementNamed('/login'); // Navigate to login screen
  }

  // Pick image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      // Upload to Firebase Storage
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref = storage.ref().child('user_profile_images/$uid.jpg');

        UploadTask uploadTask = ref.putFile(File(pickedFile.path));
        TaskSnapshot taskSnapshot = await uploadTask;

        // Get download URL and save to Firestore
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'profile_image_url': downloadUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile image uploaded successfully!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:
            IconThemeData(color: Colors.white), // Set the back arrow to white

        title: Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor:
            backgroundColor, // teal color similar to the provided image
        actions: [
          IconButton(
            icon: Icon(
              Icons.logout,
              color: Colors.white,
            ),
            onPressed: _signOut, // Signout button added here
          ),
          if (!isEditing)
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              onPressed: () {
                setState(() {
                  isEditing = true;
                });
              },
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: isEditing ? _buildEditableForm() : _buildProfileView(),
        ),
      ),
    );
  }

  Widget _buildEditableForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Profile picture with edit icon
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _image != null
                      ? FileImage(_image!)
                      : AssetImage('assets/profile.png'),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor: Color(0xFF26A69A),
                      child: Icon(Icons.edit, color: Colors.white, size: 18),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),

          // Name field
          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          SizedBox(height: 16),

          // Height field
          TextFormField(
            controller: _heightController,
            decoration: InputDecoration(
              labelText: 'Height (ft)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.height),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your height';
              }
              return null;
            },
          ),
          SizedBox(height: 16),

          // Weight field
          TextFormField(
            controller: _weightController,
            decoration: InputDecoration(
              labelText: 'Weight (kg)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.line_weight),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your weight';
              }
              return null;
            },
          ),
          SizedBox(height: 16),

          // Age field
          TextFormField(
            controller: _ageController,
            decoration: InputDecoration(
              labelText: 'Age',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.cake),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your age';
              }
              return null;
            },
          ),
          SizedBox(height: 16),

          // Blood type field
          TextFormField(
            controller: _bloodTypeController,
            decoration: InputDecoration(
              labelText: 'Blood Type',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.bloodtype),
            ),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Please enter your blood type';
              }
              return null;
            },
          ),
          SizedBox(height: 24),

          // Save Button
          ElevatedButton(
            onPressed: _saveProfile,
            child: Text('Save Profile'),
            style: ElevatedButton.styleFrom(
              //primary: Color(0xFF26A69A),
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileView() {
    return Column(
      children: [
        // Profile picture
        Center(
          child: CircleAvatar(
            radius: 50,
            backgroundImage: _image != null
                ? FileImage(_image!)
                : AssetImage('assets/profile.png'),
          ),
        ),
        SizedBox(height: 20),

        Text(
          '${_nameController.text.isNotEmpty ? _nameController.text : 'Your Name'}',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),

        SizedBox(height: 20),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildProfileDetail(
                'Height',
                _heightController.text.isNotEmpty
                    ? _heightController.text
                    : '5.8',
                Icons.height),
            _buildProfileDetail(
                'Weight',
                _weightController.text.isNotEmpty
                    ? _weightController.text
                    : '70',
                Icons.line_weight),
            _buildProfileDetail(
                'Age',
                _ageController.text.isNotEmpty ? _ageController.text : '25',
                Icons.cake),
            _buildProfileDetail(
                'Blood',
                _bloodTypeController.text.isNotEmpty
                    ? _bloodTypeController.text
                    : 'B+',
                Icons.bloodtype),
          ],
        ),
      ],
    );
  }

  Widget _buildProfileDetail(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 28, color: backgroundColor),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(fontSize: 14, color: Colors.grey),
        ),
      ],
    );
  }
}
