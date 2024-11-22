import 'dart:io';

import 'package:aarogya/screens/homescreen.dart';
import 'package:aarogya/screens/tabsscreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../utils/colors.dart';

class ProfileScreen extends StatefulWidget {
  final bool isFirstTimeSetup;

  const ProfileScreen({Key? key, this.isFirstTimeSetup = false})
      : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _image;
  String? _profileImageUrl;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  String _selectedGender = 'Male';
  String _selectedBloodGroup = 'A+';
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

  bool isEditing = true;
  bool isProfileComplete = false;

  @override
  void initState() {
    super.initState();
    if (widget.isFirstTimeSetup) {
      isEditing = true;
    } else {
      _loadProfile();
    }
  }

  Future<void> _loadProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

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

          // Determine if the profile is complete
          isProfileComplete = _nameController.text.isNotEmpty &&
              _heightController.text.isNotEmpty &&
              _weightController.text.isNotEmpty &&
              _ageController.text.isNotEmpty &&
              _profileImageUrl != null &&
              _profileImageUrl!.isNotEmpty;

          // Disable editing if profile is complete
          isEditing = !isProfileComplete;
        });
      }
    }
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('User not authenticated. Please log in again.'),
            backgroundColor: Colors.red,
          ),
        );
        Navigator.pushNamed(context, '/home');
        return;
      }

      if (_nameController.text.isEmpty ||
          _heightController.text.isEmpty ||
          _weightController.text.isEmpty ||
          _ageController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please fill in all required fields'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      if (_profileImageUrl == null || _profileImageUrl!.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please upload a profile picture'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      try {
        Map<String, dynamic> profileData = {
          'name': _nameController.text,
          'height': _heightController.text,
          'weight': _weightController.text,
          'age': _ageController.text,
          'gender': _selectedGender,
          'blood_type': _selectedBloodGroup,
          'profile_image_url': _profileImageUrl,
          'profile_completed': true,
        };

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .set(profileData, SetOptions(merge: true));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Profile saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );

        setState(() {
          isEditing = false;
          isProfileComplete = true;
        });

        // Navigate to /home after saving the profile
        Navigator.pushReplacementNamed(context, '/home');
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save profile: ${error.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

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
          isProfileComplete ? 'Your Profile' : 'Complete Your Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: backgroundColor,
        actions: [
          if (isProfileComplete)
            IconButton(
              icon: Icon(Icons.edit, color: Colors.white),
              onPressed: () {
                setState(() {
                  isEditing = true;
                });
              },
            ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: _signOut,
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
          _buildTextField(
              controller: _nameController,
              labelText: 'Name',
              icon: Icons.person),
          SizedBox(height: 16),
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
          _buildTextField(
              controller: _heightController,
              labelText: 'Height (ft)',
              icon: Icons.height),
          SizedBox(height: 16),
          _buildTextField(
              controller: _weightController,
              labelText: 'Weight (kg)',
              icon: Icons.monitor_weight),
          SizedBox(height: 16),
          _buildTextField(
              controller: _ageController, labelText: 'Age', icon: Icons.cake),
          SizedBox(height: 16),
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
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _saveProfile,
            child: Text('Save Profile'),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 14, horizontal: 50),
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
        _buildInfoTile(Icons.person, 'Name', _nameController.text),
        _buildInfoTile(Icons.person_outline, 'Gender', _selectedGender),
        _buildInfoTile(Icons.height, 'Height', '${_heightController.text} ft'),
        _buildInfoTile(
            Icons.monitor_weight, 'Weight', '${_weightController.text} kg'),
        _buildInfoTile(Icons.cake, 'Age', '${_ageController.text} years'),
        _buildInfoTile(Icons.bloodtype, 'Blood Group', _selectedBloodGroup),
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String value) {
    return ListTile(
      leading: Icon(icon, color: backgroundColor),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(value),
    );
  }

  ImageProvider _getProfileImage() {
    if (_image != null) {
      return FileImage(_image!);
    } else if (_profileImageUrl != null) {
      return NetworkImage(_profileImageUrl!);
    } else {
      return AssetImage('assets/images/profile.png');
    }
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'This field is required';
        }
        return null;
      },
    );
  }
}
