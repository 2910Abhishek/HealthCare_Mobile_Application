// import 'package:flutter/material.dart';
// import 'package:aarogya/resources/auth_methods.dart';
// import 'package:aarogya/utils/colors.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class ProfileScreen extends StatefulWidget {
//   const ProfileScreen({Key? key}) : super(key: key);

//   @override
//   State<ProfileScreen> createState() => _ProfileScreenState();
// }

// class _ProfileScreenState extends State<ProfileScreen> {
//   final AuthMethods _authMethods = AuthMethods();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   bool _isLoading = true;
//   String _fullName = '';
//   String _height = '';
//   String _weight = '';
//   String _age = '';
//   String _bloodGroup = '';

//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }

//   Future<void> _loadUserData() async {
//     setState(() => _isLoading = true);
//     User? user = _auth.currentUser;
//     if (user != null) {
//       try {
//         DocumentSnapshot userDoc =
//             await _firestore.collection('users').doc(user.uid).get();
//         if (userDoc.exists) {
//           Map<String, dynamic> userData =
//               userDoc.data() as Map<String, dynamic>;
//           setState(() {
//             _fullName = userData['fullName'] ?? '';
//             _height = userData['height']?.toString() ?? '';
//             _weight = userData['weight']?.toString() ?? '';
//             _age = userData['age']?.toString() ?? '';
//             _bloodGroup = userData['bloodGroup'] ?? '';
//           });
//         }
//       } catch (e) {
//         print("Error loading user data: $e");
//       } finally {
//         setState(() => _isLoading = false);
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: backgroundColor,
//       appBar: AppBar(
//         backgroundColor: backgroundColor,
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () => Navigator.of(context).pop(),
//         ),
//         title: Text('Profile', style: TextStyle(color: Colors.white)),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.logout, color: Colors.white),
//             onPressed: () async {
//               await _authMethods.signOut();
//               Navigator.pushNamedAndRemoveUntil(
//                   context, '/login', (route) => false);
//             },
//           ),
//         ],
//       ),
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator(color: Colors.white))
//           : SingleChildScrollView(
//               child: Column(
//                 children: [
//                   _buildProfileHeader(),
//                   _buildInfoCards(),
//                   _buildPastAppointmentsButton(),
//                   _buildBookAppointmentButton(),
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _buildProfileHeader() {
//     return Container(
//       padding: EdgeInsets.all(16),
//       child: Column(
//         children: [
//           CircleAvatar(
//             radius: 50,
//             backgroundImage: AssetImage('assets/images/default_avatar.png'),
//           ),
//           SizedBox(height: 16),
//           Text(
//             _fullName,
//             style: TextStyle(
//                 fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//           SizedBox(height: 8),
//           Container(
//             padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(20),
//             ),
//             child: Text(
//               'Patient',
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoCards() {
//     return Container(
//       padding: EdgeInsets.all(16),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           _buildInfoCard(Icons.height, 'Height', '$_height cm'),
//           _buildInfoCard(Icons.fitness_center, 'Weight', '$_weight kg'),
//           _buildInfoCard(Icons.cake, 'Age', _age),
//           _buildInfoCard(Icons.bloodtype, 'Blood', _bloodGroup),
//         ],
//       ),
//     );
//   }

//   Widget _buildInfoCard(IconData icon, String title, String value) {
//     return Column(
//       children: [
//         Container(
//           padding: EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Icon(icon, color: backgroundColor),
//         ),
//         SizedBox(height: 8),
//         Text(title, style: TextStyle(color: Colors.white70)),
//         Text(value,
//             style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
//       ],
//     );
//   }

//   Widget _buildPastAppointmentsButton() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: ElevatedButton(
//         child: Text('View Past Appointments'),
//         onPressed: () {
//           // Navigate to past appointments screen
//         },
//         style: ElevatedButton.styleFrom(
//           //primary: Colors.white,
//           //onPrimary: backgroundColor,
//           padding: EdgeInsets.symmetric(vertical: 16),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//       ),
//     );
//   }

//   Widget _buildBookAppointmentButton() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: ElevatedButton(
//         child: Text('Book New Appointment'),
//         onPressed: () {
//           // Navigate to book appointment screen
//         },
//         style: ElevatedButton.styleFrom(
//           padding: EdgeInsets.symmetric(vertical: 16),
//           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
//         ),
//       ),
//     );
//   }
// }
