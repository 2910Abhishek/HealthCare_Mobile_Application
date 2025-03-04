import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:aarogya/screens/DoctorScreen.dart';
import 'package:aarogya/utils/colors.dart';
import 'package:aarogya/widgets/customButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookAppointmentScreen extends StatefulWidget {
  final String doctorName;
  final String speciality;
  final String hospitalName;
  final String imagePath;
  final int doctorId; // Add this

  BookAppointmentScreen({
    required this.doctorName,
    required this.speciality,
    required this.hospitalName,
    required this.imagePath,
    required this.doctorId, // Add this
  });

  @override
  _BookAppointmentScreenState createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay? selectedTime;
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  List<String> availableTimeSlots = [];
  bool _isLoadingSlots = false;

  double? latitude;
  double? longitude;
  String? address;

  // Add location permission handling
  Future<void> _getLocation() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      latitude = position.latitude;
      longitude = position.longitude;
    });
  }

  @override
  void initState() {
    super.initState();
    _checkLocationPermission();
    _fetchAvailableSlots();
  }

  Future<void> _fetchAvailableSlots() async {
    setState(() {
      _isLoadingSlots = true;
      availableTimeSlots = [];
    });

    try {
      final response = await http.post(
        Uri.parse('http://192.168.80.175:5000/api/flutter/doctor-slots'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'doctorId': widget.doctorId,
          'date': DateFormat('yyyy-MM-dd').format(selectedDate),
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['success'] && data['data'] != null) {
          setState(() {
            if (data['data']['availableSlots'] != null) {
              // Convert the slots to List<String>
              availableTimeSlots =
                  List<String>.from(data['data']['availableSlots']);
            }
          });
        } else {
          print('No slots available or error in response: $data');
        }
      } else {
        throw Exception('Failed to load time slots: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching slots: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load available time slots')),
      );
    } finally {
      setState(() {
        _isLoadingSlots = false;
      });
    }
  }

  Future<void> _checkLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Show dialog that location is required
        showDialog(
          context: context,
          builder: (BuildContext context) => AlertDialog(
            title: Text('Location Required'),
            content: Text(
                'Location permission is required to calculate travel time to hospital.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: _isLoading
              ? null
              : () {
                  Navigator.of(context).pushReplacementNamed('/home');
                },
          child: Icon(
            Icons.arrow_back_rounded,
            color: Colors.white,
          ),
        ),
        title: Text(
          'Book Appointment',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: backgroundColor,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: AbsorbPointer(
              absorbing: _isLoading,
              child: Column(
                children: [
                  // Doctor info section (unchanged)
                  Container(
                    padding: EdgeInsets.all(16),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: widget.imagePath.startsWith(
                                          'data:image/jpeg;base64,') ||
                                      widget.imagePath
                                          .startsWith('data:image/png;base64,')
                                  ? MemoryImage(base64Decode(widget.imagePath
                                      .split(',')
                                      .last)) // Decode and load base64 image
                                  : AssetImage('assets/images/doctor_image.png')
                                      as ImageProvider, // Fallback to asset image
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.doctorName,
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    widget.speciality,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.star,
                                          color: Colors.yellow, size: 16),
                                      Text(
                                        " (80 reviews)",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Description",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "${widget.doctorName} is a highly skilled ${widget.speciality} with years of experience in treating patients at ${widget.hospitalName}.",
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),

                  // Appointment section
                  Container(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Appointment",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 16),
                        ListTile(
                          title: Text(
                              "Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}"),
                          trailing: Icon(Icons.calendar_today),
                          onTap: () => _selectDate(context),
                        ),
                        SizedBox(height: 16),
                        Text(
                          "Available Time Slots",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        if (_isLoadingSlots)
                          Center(child: CircularProgressIndicator())
                        else if (availableTimeSlots.isEmpty)
                          Center(
                            child: Text(
                              "No available slots for selected date",
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        else
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: availableTimeSlots
                                .map((time) => _buildTimeSlot(time))
                                .toList(),
                          ),
                        SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            text: 'Book Appointment',
                            onPressed: selectedTime == null || _isLoading
                                ? null
                                : _bookAppointment,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }

  String formatTimeSlot(String slot) {
    try {
      // Assuming slot format is "HH:mm"
      final parts = slot.split(':');
      final hour = int.parse(parts[0]);
      final minute = parts[1];

      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);

      return '$displayHour:$minute $period';
    } catch (e) {
      print('Error formatting time slot: $e');
      return slot; // Return original if formatting fails
    }
  }

  Widget _buildTimeSlots() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Available Time Slots",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          if (_isLoadingSlots)
            Center(child: CircularProgressIndicator())
          else if (availableTimeSlots.isEmpty)
            Center(
              child: Text(
                "No available slots for selected date",
                style: TextStyle(color: Colors.grey),
              ),
            )
          else
            GridView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 2.5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: availableTimeSlots.length,
              itemBuilder: (context, index) =>
                  _buildTimeSlot(availableTimeSlots[index]),
            ),
        ],
      ),
    );
  }

  Widget _buildTimeSlot(String time) {
    String cleanTime =
        time.replaceAll(' AM AM', ' AM').replaceAll(' PM AM', ' PM');
    bool isSelected = selectedTime != null && isTimeEqual(selectedTime!, time);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _isLoading
            ? null
            : () {
                setState(() {
                  selectedTime = parseTimeString(time);
                });
              },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? backgroundColor : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(12),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: backgroundColor.withOpacity(0.3),
                      blurRadius: 4,
                      offset: Offset(0, 2),
                    )
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              cleanTime,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

// Update parseTimeString method to handle the cleaned time format
  TimeOfDay parseTimeString(String timeString) {
    // Remove duplicate AM/PM first
    timeString =
        timeString.replaceAll(' AM AM', ' AM').replaceAll(' PM AM', ' PM');

    final components = timeString.split(' ');
    final time = components[0].split(':');
    int hour = int.parse(time[0]);
    final minute = int.parse(time[1]);
    final period = components[1];

    if (period.toUpperCase() == 'PM' && hour != 12) {
      hour += 12;
    } else if (period.toUpperCase() == 'AM' && hour == 12) {
      hour = 0;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  Future<void> _selectDate(BuildContext context) async {
    if (_isLoading) return;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 90)),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        selectedTime = null; // Reset selected time when date changes
      });
      _fetchAvailableSlots(); // Fetch new slots for selected date
    }
  }

  // Keep all existing helper methods
  // TimeOfDay parseTimeString(String timeString) {
  //   final components = timeString.split(' ');
  //   final time = components[0].split(':');
  //   int hour = int.parse(time[0]);
  //   final minute = int.parse(time[1]);
  //   final period = components[1];

  //   if (period.toLowerCase() == 'pm' && hour != 12) {
  //     hour += 12;
  //   } else if (period.toLowerCase() == 'am' && hour == 12) {
  //     hour = 0;
  //   }

  //   return TimeOfDay(hour: hour, minute: minute);
  // }

  bool isTimeEqual(TimeOfDay time1, String time2String) {
    final time2 = parseTimeString(time2String);
    return time1.hour == time2.hour && time1.minute == time2.minute;
  }

  // Future<void> _selectDate(BuildContext context) async {
  //   if (_isLoading) return;

  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: selectedDate,
  //     firstDate: DateTime.now(),
  //     lastDate: DateTime.now().add(Duration(days: 90)),
  //   );
  //   if (picked != null && picked != selectedDate) {
  //     setState(() {
  //       selectedDate = picked;
  //     });
  //   }
  // }

  Future<Map<String, dynamic>> _getUserProfileData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
    }
    return {'age': 0, 'gender': 'Not Specified'}; // Default values
  }

  Future<void> _bookAppointment() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Retrieve age and gender from Firestore
      Map<String, dynamic> profileData = await _getUserProfileData();
      String gender = profileData['gender'] ?? 'Not Specified';
      int age = int.tryParse(profileData['age'] ?? '0') ?? 0;
      // Get current location first
      final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Get current date and time, format them properly
      final now = DateTime.now();
      final formattedDate =
          DateFormat('yyyy-MM-dd').format(now); // Get today's date
      final formattedTime =
          '${selectedTime!.hour}:${selectedTime!.minute}'; // Get selected time
      final reportingTime =
          '$formattedDate $formattedTime'; // Combine date and time into 'YYYY-MM-DD HH:mm'

      // First make the API call to add patient with location
      final response = await http.post(
        Uri.parse('http://192.168.80.175:5000/add-patient'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': _auth.currentUser!.displayName,
          'gender': gender,
          'age': age,
          'reporting_time': reportingTime, // Pass combined date and time
          'doctor_id': widget.doctorId,
          'latitude': position.latitude,
          'longitude': position.longitude,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to add patient to backend');
      }

      final responseData = json.decode(response.body);
      final backendPatientId = responseData['patient']['id'];
      final travelDetails =
          responseData['travel_details']; // New travel time data

      // Get the next appointment ID from Firestore
      final appointmentCountDoc = await FirebaseFirestore.instance
          .collection('appointmentCount')
          .doc('counter')
          .get();

      int nextAppointmentId = 1;
      if (appointmentCountDoc.exists) {
        nextAppointmentId = (appointmentCountDoc.data()?['count'] ?? 0) + 1;
      }

      // Update the appointment count in Firestore
      await FirebaseFirestore.instance
          .collection('appointmentCount')
          .doc('counter')
          .set({'count': nextAppointmentId});

      String appointmentId = nextAppointmentId.toString().padLeft(6, '0');
      final pdf = await _generatePDF(appointmentId);
      final output = await getTemporaryDirectory();
      final file = File("${output.path}/appointment.pdf");
      await file.writeAsBytes(await pdf.save());

      bool emailSent = await _sendEmail(file.path);
      print('Email sent: $emailSent');

      // Save appointment details to Firestore with location and travel info
      await FirebaseFirestore.instance.collection('appointments').add({
        'appointmentId': appointmentId,
        'patientName': _auth.currentUser!.displayName,
        'doctorName': widget.doctorName,
        'date': selectedDate,
        'time': '${selectedTime!.hour}:${selectedTime!.minute}',
        'speciality': widget.speciality,
        'hospitalName': widget.hospitalName,
        'userId': _auth.currentUser!.uid,
        'backendPatientId': backendPatientId,
        // Add location and travel details
        'patientLatitude': position.latitude,
        'patientLongitude': position.longitude,
        'estimatedTravelTime': travelDetails['travel_time_minutes'],
        'suggestedLeaveTime': travelDetails['suggested_leave_time'],
        'bufferTime': travelDetails['buffer_time_minutes'],
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Appointment Booked"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Your appointment has been booked for ${DateFormat('yyyy-MM-dd').format(selectedDate)} at ${selectedTime!.format(context)}.",
                ),
                SizedBox(height: 10),
                // Add travel time information
                Text(
                  "Estimated travel time: ${travelDetails['travel_time_minutes']} minutes",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "Suggested departure time: ${travelDetails['suggested_leave_time']}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Text(
                  emailSent
                      ? "A confirmation PDF has been sent to your email."
                      : "We couldn't send the confirmation email. Please contact support.",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: emailSent ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/home',
                    (route) => false,
                  );
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      print('Error: $e');
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(
                "An error occurred while booking the appointment. Please try again later."),
            actions: <Widget>[
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<pw.Document> _generatePDF(String appointmentId) async {
    final pdf = pw.Document();

    final formattedTime =
        "${selectedTime!.hour.toString().padLeft(2, '0')}:${selectedTime!.minute.toString().padLeft(2, '0')}";

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              // Header Section
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Appointment Confirmation',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(
                    'Date: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
                    style: pw.TextStyle(
                      fontSize: 12,
                      color: PdfColors.grey700,
                    ),
                  ),
                ],
              ),
              pw.Divider(),
              pw.SizedBox(height: 20),

              // Appointment Details Section
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey400, width: 1),
                  borderRadius: pw.BorderRadius.circular(8),
                  color: PdfColors.grey100,
                ),
                padding: pw.EdgeInsets.all(16),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Appointment Details',
                      style: pw.TextStyle(
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blueGrey800,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Text('Appointment ID: $appointmentId'),
                    pw.Text('Patient Name: ${_auth.currentUser!.displayName}'),
                    pw.Text('Doctor: ${widget.doctorName}'),
                    pw.Text(
                        'Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}'),
                    pw.Text('Time: $formattedTime'),
                    pw.Text('Speciality: ${widget.speciality}'),
                    pw.Text('Hospital: ${widget.hospitalName}'),
                  ],
                ),
              ),
              pw.SizedBox(height: 20),

              // QR Code Section
              // Uncomment if you add the QR code logic
              // pw.Center(
              //   child: pw.Container(
              //     padding: pw.EdgeInsets.all(16),
              //     decoration: pw.BoxDecoration(
              //       border: pw.Border.all(color: PdfColors.grey400, width: 1),
              //       borderRadius: pw.BorderRadius.circular(8),
              //     ),
              //     child: pw.Image(
              //       pw.MemoryImage(qrImage!.buffer.asUint8List()),
              //       width: 150,
              //       height: 150,
              //     ),
              //   ),
              // ),
              // pw.SizedBox(height: 20),

              // Footer Section
              pw.Spacer(),
              pw.Divider(),
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.Text(
                  'Thank you for choosing our services!',
                  style: pw.TextStyle(
                    fontSize: 12,
                    fontStyle: pw.FontStyle.italic,
                    color: PdfColors.grey600,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  Future<bool> _sendEmail(String filePath) async {
    final smtpServer = gmail('22cs046@charusat.edu.in',
        'nril vcmk rxro zhag'); // Replace with your credentials
    final message = Message()
      ..from = Address('22cs046@charusat.edu.in', 'Appointment Confirmation')
      ..recipients
          .add(_auth.currentUser!.email!) // Replace with the recipient email
      ..subject = 'Appointment Confirmation'
      ..text = 'Please find your appointment confirmation attached.'
      ..attachments.add(FileAttachment(File(filePath)));

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ${sendReport.toString()}');
      return true;
    } catch (e) {
      print('Error sending email: $e');
      return false;
    }
  }
}
