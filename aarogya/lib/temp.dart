// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:geolocator/geolocator.dart';
// import 'package:permission_handler/permission_handler.dart';

// void main() {
//   runApp(MyApp());
// }

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Hospital Appointment',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         visualDensity: VisualDensity.adaptivePlatformDensity,
//       ),
//       home: HospitalAppointmentPage(),
//     );
//   }
// }

// class HospitalAppointmentPage extends StatefulWidget {
//   @override
//   _HospitalAppointmentState createState() => _HospitalAppointmentState();
// }

// class _HospitalAppointmentState extends State<HospitalAppointmentPage> {
//   TextEditingController _controller = TextEditingController();
//   String _duration = '';

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   Future<void> _getRoute(double currentLat, double currentLng, double destLat,
//       double destLng) async {
//     String apiKey =
//         '5b3ce3597851110001cf6248db523009310242dfb5e95e5cb0e24285'; // Replace with your OpenRouteService API key
//     String url = 'https://api.openrouteservice.org/v2/directions/driving-car';

//     final response = await http.post(
//       Uri.parse(url),
//       headers: {
//         'Authorization': apiKey,
//         'Content-Type': 'application/json',
//       },
//       body: jsonEncode({
//         'coordinates': [
//           [
//             currentLng,
//             currentLat
//           ], // Note: OpenRouteService requires [longitude, latitude]
//           [destLng, destLat]
//         ],
//         'profile': 'driving-car',
//         'format': 'json',
//       }),
//     );

//     if (response.statusCode == 200) {
//       Map<String, dynamic> data = json.decode(response.body);
//       print('API Response: $data'); // Print response to inspect its structure
//       try {
//         // Ensure nested keys exist before accessing
//         if (data != null &&
//             data['routes'] != null &&
//             data['routes'].isNotEmpty &&
//             data['routes'][0]['summary'] != null &&
//             data['routes'][0]['summary']['duration'] != null) {
//           double durationSeconds = data['routes'][0]['summary']['duration'];
//           int durationMinutes = (durationSeconds / 60).round();

//           setState(() {
//             _duration = '$durationMinutes mins';
//           });
//         } else {
//           setState(() {
//             _duration = 'Failed to fetch duration';
//           });
//         }
//       } catch (e) {
//         print('Error parsing API response: $e');
//         setState(() {
//           _duration = 'Error parsing API response';
//         });
//       }
//     } else {
//       setState(() {
//         _duration = 'Failed to fetch duration';
//       });
//     }
//   }

//   Future<void> _getCurrentLocationAndCalculateRoute() async {
//     // Check for location permissions
//     var status = await Permission.location.request();
//     if (status.isGranted) {
//       // Permission granted, proceed to fetch location
//       try {
//         Position position = await Geolocator.getCurrentPosition(
//             desiredAccuracy: LocationAccuracy.high);
//         double currentLat = position.latitude;
//         double currentLng = position.longitude;

//         _getRoute(
//             currentLat, currentLng, 22.600684402399683, 72.83353262881953);
//       } catch (e) {
//         print('Error fetching location: $e');
//         setState(() {
//           _duration = 'Error fetching location';
//         });
//       }
//     } else {
//       // Permission denied
//       setState(() {
//         _duration = 'Location permission denied';
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Hospital Appointment'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             ElevatedButton(
//               onPressed: () {
//                 _getCurrentLocationAndCalculateRoute();
//               },
//               child: Text('Estimate Time to Hospital'),
//             ),
//             SizedBox(height: 20.0),
//             Text(
//               'Estimated time to hospital: $_duration',
//               style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
