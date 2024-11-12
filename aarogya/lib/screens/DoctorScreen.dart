import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:aarogya/widgets/doctor_card.dart';
import 'package:aarogya/screens/bookAppointmentScreen.dart';

class DoctorScreen extends StatefulWidget {
  final String hospitalName;

  DoctorScreen({required this.hospitalName});

  @override
  _DoctorScreenState createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  // Use Map<String, Object> to handle both String and int
  List<Map<String, dynamic>> doctors = [];
  List<Map<String, dynamic>> filteredDoctors = [];

  @override
  void initState() {
    super.initState();
    fetchDoctors();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setStatusBarColor();
    });
  }

  Future<void> fetchDoctors() async {
    final url = Uri.parse('http://192.168.127.175:5000/doctors');

    // Prepare the data to send in the POST request
    final Map<String, dynamic> requestBody = {
      'hospitalName': widget.hospitalName,
    };

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      List<dynamic> doctorsData = data['doctors'];

      setState(() {
        // Cast doctor data properly, using Object to handle both types
        doctors = doctorsData.map<Map<String, Object>>((doctor) {
          return {
            "doctorId": doctor['id'] ?? 0,
            "name": doctor['name']?.toString() ?? '',
            "speciality": doctor['speciality']?.toString() ?? '',
            "imagePath": doctor['profile_image']?.toString() ?? '',
            "address": doctor['address']?.toString() ?? '',
          };
        }).toList();

        filteredDoctors = List.from(doctors); // Initialize filtered list
      });
    } else {
      throw Exception('Failed to load doctors');
    }
  }

  Future<void> _setStatusBarColor() async {
    await FlutterStatusbarcolor.setStatusBarColor(
        Color.fromRGBO(11, 143, 172, 1));
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
          .where((doctor) => doctor["name"]!
              .toString()
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.hospitalName),
        backgroundColor: Color.fromRGBO(11, 143, 172, 1),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: searchController,
              onChanged: searchDoctors,
              decoration: InputDecoration(
                hintText: 'Search for Doctors',
                prefixIcon: Icon(Icons.search),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),
          Expanded(
            child: isSearching ? _buildSearchResults() : _buildDoctorList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      itemCount: filteredDoctors.length,
      itemBuilder: (context, index) {
        final doctor = filteredDoctors[index];
        return DoctorCard(
          hospitalName: widget.hospitalName,
          name: doctor["name"] as String,
          speciality: doctor["speciality"] as String,
          imagePath: doctor["imagePath"] as String,
          address: doctor["address"] as String,
          doctorId: doctor["doctorId"] as int, // Explicitly cast to int
        );
      },
    );
  }

  Widget _buildDoctorList() {
    return ListView.builder(
      itemCount: doctors.length,
      itemBuilder: (context, index) {
        final doctor = doctors[index];
        return DoctorCard(
          hospitalName: widget.hospitalName,
          name: doctor["name"] as String,
          speciality: doctor["speciality"] as String,
          imagePath: doctor["imagePath"] as String,
          address: doctor["address"] as String,
          doctorId: doctor["doctorId"] as int, // Explicitly cast to int
        );
      },
    );
  }
}
