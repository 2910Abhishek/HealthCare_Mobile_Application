import 'dart:convert';
import 'package:aarogya/utils/colors.dart';
import 'package:aarogya/widgets/Doctor_Category.dart';
import 'package:aarogya/widgets/Hospital_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late User? _user;
  String _username = 'Guest';
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;
  List<Map<String, dynamic>> hospitals = [];
  List<Map<String, dynamic>> filteredHospitals = [];

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;
    filteredHospitals = hospitals;

    if (_user != null) {
      _fetchUsername();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setStatusBarColor();
    });

    // Fetch hospital data on screen load
    fetchHospitals();
  }

  @override
  void dispose() {
    _resetStatusBarColor();
    searchController.dispose();
    super.dispose();
  }

  Future<void> _setStatusBarColor() async {
    await FlutterStatusbarcolor.setStatusBarColor(
      Color.fromRGBO(11, 143, 172, 1),
    );
  }

  Future<void> _resetStatusBarColor() async {
    await FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    await FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
  }

  Future<void> _fetchUsername() async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(_user!.uid).get();
      if (userDoc.exists) {
        setState(() {
          _username = userDoc['username'];
        });
      }
    } catch (e) {
      print("Error fetching username: $e");
    }
  }

  // Function to fetch hospital data from API
  Future<void> fetchHospitals() async {
    try {
      final response =
          await http.get(Uri.parse('http://192.168.80.175:5000/hospitals'));

      if (response.statusCode == 200) {
        Map<String, dynamic> data = jsonDecode(response.body);

        // Ensure the response is parsed correctly
        List<String> hospitalNames = List<String>.from(data['hospitals']);

        setState(() {
          hospitals = hospitalNames.map((name) {
            return {
              "name": name,
              "imagePath":
                  'assets/images/doctor_image.png', // You can adjust this if you have image URLs
              "address": '', // Replace with actual addresses if available
            };
          }).toList();
          filteredHospitals = hospitals;
        });
      } else {
        throw Exception('Failed to load hospitals');
      }
    } catch (e) {
      print("Error fetching hospitals: $e");
    }
  }

  void searchHospitals(String query) {
    setState(() {
      isSearching = query.isNotEmpty;
      filteredHospitals = hospitals
          .where((hospital) =>
              hospital["name"]!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    _setStatusBarColor();

    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // App Bar
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top,
              left: 16,
              right: 16,
              bottom: 16,
            ),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Hi $_username, 👋",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.notifications_none,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        // Handle notifications
                      },
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  "Need some help today?",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                SizedBox(height: 16),
                SizedBox(
                  height: 54,
                  width: double.infinity,
                  child: Center(
                    child: TextField(
                      controller: searchController,
                      onChanged: searchHospitals,
                      decoration: InputDecoration(
                        hintText: 'Search hospitals',
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Conditional content
          Expanded(
            child: isSearching ? _buildSearchResults() : _buildMainContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: filteredHospitals.length,
      itemBuilder: (context, index) {
        var hospital = filteredHospitals[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: HospitalCard(
            name: hospital["name"]!,
            imagePath: hospital["imagePath"]!,
            address: hospital["address"]!,
          ),
        );
      },
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Categories",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text("See all"),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Categories
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DoctorCategoryWidget(
                    title: "Urology", icon: Icons.local_hospital),
                DoctorCategoryWidget(
                    title: "Neurology", icon: Icons.psychology),
                DoctorCategoryWidget(title: "Cardiology", icon: Icons.favorite),
              ],
            ),
            SizedBox(height: 24),
            // Consult Doctors Card
            Card(
              color: backgroundColor,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Consult Doctors',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Get expert advice from expert doctors',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                      ),
                    ),
                    Image.asset(
                      'assets/images/doctor_image.png',
                      width: 100,
                      height: 100,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 24),
            // Top Hospitals section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Top Hospitals",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text("See all"),
                ),
              ],
            ),
            SizedBox(height: 16),
            // Hospitals list
            Column(
              children: hospitals.map((hospital) {
                return Column(
                  children: [
                    HospitalCard(
                      name: hospital["name"]!,
                      imagePath: hospital["imagePath"]!,
                      address: hospital["address"]!,
                    ),
                    SizedBox(height: 16),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
