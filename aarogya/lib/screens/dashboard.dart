import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:aarogya/utils/colors.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  File? _image;
  String? _imageUrl;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _bloodTypeController = TextEditingController();

  String? _selectedGender;
  final List<String> _genderOptions = [
    'Male',
    'Female',
    'Other',
    'Prefer not to say'
  ];

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      DocumentSnapshot doc =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        setState(() {
          _nameController.text = data['name'] ?? '';
          _ageController.text = data['age'] ?? '';
          _bloodTypeController.text = data['blood_type'] ?? '';
          _selectedGender = data['gender'] ?? 'Prefer not to say';
          _imageUrl = data['profile_image_url'];
        });
      }
    }
  }

  void _saveProfile() async {
    if (_formKey.currentState!.validate()) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String uid = user.uid;

        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'name': _nameController.text,
          'age': _ageController.text,
          'blood_type': _bloodTypeController.text,
          'gender': _selectedGender,
          'profile_image_url': _imageUrl,
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

  Future<void> _pickImage() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You must be logged in to upload an image.')),
      );
      return;
    }

    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });

      String uid = user.uid;
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('user_profile_images/$uid.jpg');

      try {
        UploadTask uploadTask = ref.putFile(_image!);
        TaskSnapshot taskSnapshot = await uploadTask;

        String downloadUrl = await taskSnapshot.ref.getDownloadURL();
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'profile_image_url': downloadUrl,
        });

        setState(() {
          _imageUrl = downloadUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile image uploaded successfully!')),
        );
      } catch (e) {
        String errorMessage = 'Failed to upload image';
        if (e is FirebaseException) {
          errorMessage = 'Firebase error: ${e.message}';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
        print('Error uploading image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text('Profile', style: TextStyle(color: Colors.white)),
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
          TextFormField(
            controller: _bloodTypeController,
            decoration: InputDecoration(
              labelText: 'Blood Type',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.bloodtype),
            ),
            validator: (value) {
              if (value!.isEmpty) return 'Please enter your blood type';
              return null;
            },
          ),
          SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _selectedGender,
            decoration: InputDecoration(
              labelText: 'Gender',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.person_outline),
            ),
            items: _genderOptions.map((String gender) {
              return DropdownMenuItem<String>(
                value: gender,
                child: Text(gender),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedGender = newValue;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty)
                return 'Please select your gender';
              return null;
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
          '${_nameController.text.isNotEmpty ? _nameController.text : 'Your Name'}',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
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
            _buildProfileDetail('Gender', _selectedGender ?? 'Not specified',
                Icons.person_outline),
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
        Text(value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey)),
      ],
    );
  }

  ImageProvider _getProfileImage() {
    if (_image != null) {
      return FileImage(_image!);
    } else if (_imageUrl != null && _imageUrl!.isNotEmpty) {
      return NetworkImage(_imageUrl!);
    } else {
      return AssetImage('assets/images/profile.png');
    }
  }
}
