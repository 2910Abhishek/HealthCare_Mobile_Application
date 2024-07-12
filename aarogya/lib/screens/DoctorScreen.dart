import 'package:aarogya/utils/colors.dart';
import 'package:aarogya/widgets/doctor_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';

class DoctorScreen extends StatefulWidget {
  DoctorScreen({super.key, required this.hospitalName});

  final String hospitalName;

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  List<Map<String, String>> doctors = [
    {
      "name": "Dr. Jayesh Shah",
      "speciality": "Cardiologist",
      "imagePath": "assets/images/doctor_image.png",
      "address": "vadodara",
      "rating": "5.0",
    },
    {
      "name": "Dr. Gaurang Patel",
      "speciality": "Physician",
      "imagePath": "assets/images/doctor_image.png",
      "address": "vadodara",
      "rating": "4.8",
    },
    {
      "name": "Dr. Abhishek Parmar",
      "speciality": "Computer Science Engineer",
      "imagePath": "assets/images/doctor_image.png",
      "address": "vadodara",
      "rating": "5.0",
    },
    // Add more doctors here if needed
  ];

  List<Map<String, String>> filteredDoctors = [];

  @override
  void initState() {
    super.initState();
    filteredDoctors = doctors;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setStatusBarColor();
    });
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

  @override
  void dispose() {
    _resetStatusBarColor();
    searchController.dispose();
    super.dispose();
  }

  void searchDoctors(String query) {
    setState(() {
      isSearching = query.isNotEmpty;
      filteredDoctors = doctors
          .where((doctor) =>
              doctor["name"]!.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                      "Please Book Your Appointment",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 75,
                    ),
                  ],
                ),
                SizedBox(height: 8),
                SizedBox(
                  height: 54,
                  width: double.infinity,
                  child: Center(
                    child: TextField(
                      controller: searchController,
                      onChanged: searchDoctors,
                      decoration: InputDecoration(
                        hintText: 'Search for Doctors',
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
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: filteredDoctors.length,
      itemBuilder: (context, index) {
        final doctor = filteredDoctors[index];
        return Column(
          children: [
            DoctorCard(
              name: doctor["name"]!,
              speciality: doctor["speciality"]!,
              imagePath: doctor["imagePath"]!,
              address: doctor["address"]!,
              rating: doctor["rating"]!,
            ),
            SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildMainContent() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                                'Book appointment for ${widget.hospitalName}',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
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
                SizedBox(height: 18),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Top Doctors",
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
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              final doctor = doctors[index];
              return Column(
                children: [
                  DoctorCard(
                    name: doctor["name"]!,
                    speciality: doctor["speciality"]!,
                    imagePath: doctor["imagePath"]!,
                    address: doctor["address"]!,
                    rating: doctor["rating"]!,
                  ),
                  SizedBox(height: 16),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
