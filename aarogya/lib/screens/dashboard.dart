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
  String? _profileImageUrl; // Added to store the image URL

  // Text field controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _bloodTypeController = TextEditingController();

  // Added for dropdowns
  String _selectedGender = 'Male';
  String _selectedBloodGroup = 'A+';

  // Lists for dropdown items
  final List<String> _genders = ['Male', 'Female', 'Other'];
  final List<String> _bloodGroups = [
    'A+',
    'A-',
    'B+',
    'B-',
    'O+',
    'O-',
    'AB+',
    'AB-'
  ];

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  // Updated load profile function to include image URL
  Future<void> _loadProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (doc.exists) {
        var data = doc.data() as Map<String, dynamic>;
        setState(() {
          _nameController.text = data['name'] ?? '';
          _heightController.text = data['height'] ?? '';
          _weightController.text = data['weight'] ?? '';
          _ageController.text = data['age'] ?? '';
          _selectedGender = data['gender'] ?? 'Male';
          _selectedBloodGroup = data['blood_type'] ?? 'A+';
          _profileImageUrl = data['profile_image_url'];
        });
      }
    }
  }

  // Updated save profile function to include gender
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
          'gender': _selectedGender,
          'blood_type': _selectedBloodGroup,
          'profile_image_url': _profileImageUrl, // Save the image URL
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

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  // Updated image picker function
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref = storage.ref().child('user_profile_images/$uid.jpg');

        UploadTask uploadTask = ref.putFile(File(pickedFile.path));
        TaskSnapshot taskSnapshot = await uploadTask;

        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        setState(() {
          _profileImageUrl = downloadUrl;
        });

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
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: backgroundColor,
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: _signOut,
          ),
          if (!isEditing)
            IconButton(
              icon: Icon(Icons.edit, color: Colors.white),
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
          Center(
            child: Stack(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _getProfileImage(),
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

          TextFormField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person),
            ),
            validator: (value) {
              if (value!.isEmpty) return 'Please enter your name';
              return null;
            },
          ),
          SizedBox(height: 16),

          // Added Gender Dropdown
          DropdownButtonFormField<String>(
            value: _selectedGender,
            decoration: InputDecoration(
              labelText: 'Gender',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person_outline),
            ),
            items: _genders.map((String gender) {
              return DropdownMenuItem(
                value: gender,
                child: Text(gender),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedGender = newValue;
                });
              }
            },
          ),
          SizedBox(height: 16),

          TextFormField(
            controller: _heightController,
            decoration: InputDecoration(
              labelText: 'Height (ft)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.height),
            ),
            validator: (value) {
              if (value!.isEmpty) return 'Please enter your height';
              return null;
            },
          ),
          SizedBox(height: 16),

          TextFormField(
            controller: _weightController,
            decoration: InputDecoration(
              labelText: 'Weight (kg)',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.line_weight),
            ),
            validator: (value) {
              if (value!.isEmpty) return 'Please enter your weight';
              return null;
            },
          ),
          SizedBox(height: 16),

          TextFormField(
            controller: _ageController,
            decoration: InputDecoration(
              labelText: 'Age',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.cake),
            ),
            validator: (value) {
              if (value!.isEmpty) return 'Please enter your age';
              return null;
            },
          ),
          SizedBox(height: 16),

          // Updated Blood Group Dropdown
          DropdownButtonFormField<String>(
            value: _selectedBloodGroup,
            decoration: InputDecoration(
              labelText: 'Blood Group',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.bloodtype),
            ),
            items: _bloodGroups.map((String bloodGroup) {
              return DropdownMenuItem(
                value: bloodGroup,
                child: Text(bloodGroup),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedBloodGroup = newValue;
                });
              }
            },
          ),
          SizedBox(height: 24),

          ElevatedButton(
            onPressed: _saveProfile,
            child: Text('Save Profile'),
            style: ElevatedButton.styleFrom(
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
        Center(
          child: CircleAvatar(
            radius: 50,
            backgroundImage: _getProfileImage(),
          ),
        ),
        SizedBox(height: 20),
        Text(
          _nameController.text.isNotEmpty ? _nameController.text : 'Your Name',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          _selectedGender,
          style: TextStyle(fontSize: 16, color: Colors.grey),
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
            _buildProfileDetail('Blood', _selectedBloodGroup, Icons.bloodtype),
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

  // Helper method to get profile image
  ImageProvider _getProfileImage() {
    if (_image != null) {
      return FileImage(_image!);
    } else if (_profileImageUrl != null && _profileImageUrl!.isNotEmpty) {
      return NetworkImage(_profileImageUrl!);
    }
    return AssetImage('assets/profile.png') as ImageProvider;
  }
}
