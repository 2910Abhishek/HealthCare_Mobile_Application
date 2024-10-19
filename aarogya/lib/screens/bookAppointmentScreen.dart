import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:path_provider/path_provider.dart';
import 'package:aarogya/utils/colors.dart';
import 'package:aarogya/widgets/customButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:http/http.dart' as http;

class BookAppointmentScreen extends StatefulWidget {
  final String doctorName;
  final String speciality;
  final String hospitalName;
  final String imagePath;
  final String rating;

  BookAppointmentScreen({
    required this.doctorName,
    required this.speciality,
    required this.hospitalName,
    required this.rating,
    required this.imagePath,
  });

  @override
  _BookAppointmentScreenState createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 8, minute: 30);
  FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  TextEditingController _patientNameController = TextEditingController();

  @override
  void dispose() {
    _patientNameController.dispose();
    super.dispose();
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
                  Container(
                    padding: EdgeInsets.all(16),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundImage: AssetImage(widget.imagePath),
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
                                        widget.rating,
                                        style: TextStyle(fontSize: 14),
                                      ),
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
                          "Schedule",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            _buildTimeSlot("08:30 AM"),
                            _buildTimeSlot("10:30 AM"),
                            _buildTimeSlot("12:30 PM"),
                            _buildTimeSlot("02:30 PM"),
                            _buildTimeSlot("04:30 PM"),
                          ],
                        ),
                        SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: CustomButton(
                            text: 'Book Appointment',
                            onPressed: _isLoading
                                ? null
                                : () {
                                    _bookAppointment();
                                  },
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

  Widget _buildTimeSlot(String time) {
    bool isSelected = isTimeEqual(selectedTime, time);
    return GestureDetector(
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
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        margin: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: _isLoading
              ? Colors.grey.shade300
              : (isSelected ? Colors.blue : Colors.grey.shade200),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          time,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  TimeOfDay parseTimeString(String timeString) {
    final components = timeString.split(' ');
    final time = components[0].split(':');
    int hour = int.parse(time[0]);
    final minute = int.parse(time[1]);
    final period = components[1];

    if (period.toLowerCase() == 'pm' && hour != 12) {
      hour += 12;
    } else if (period.toLowerCase() == 'am' && hour == 12) {
      hour = 0;
    }

    return TimeOfDay(hour: hour, minute: minute);
  }

  bool isTimeEqual(TimeOfDay time1, String time2String) {
    final time2 = parseTimeString(time2String);
    return time1.hour == time2.hour && time1.minute == time2.minute;
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
      });
    }
  }

  Future<void> _bookAppointment() async {
    setState(() {
      _isLoading = true;
    });

    try {
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

      // Prepare the data to be sent to the API
      final data = {
        'name': _auth.currentUser!.displayName,
        'gender': 'Not Specified',
        'age': 0,
        'reporting_time':
            "${DateFormat('yyyy-MM-dd').format(selectedDate)} ${selectedTime.format(context)}",
        'patient_history_url': '',
        'lab_report_url': '',
        'doctor_id': 1,
      };

      // Send the data to the API
      await _sendDataToAPI(data);

      // Save appointment details to Firestore
      await FirebaseFirestore.instance.collection('appointments').add({
        'appointmentId': appointmentId,
        'patientName': _auth.currentUser!.displayName,
        'doctorName': widget.doctorName,
        'date': selectedDate,
        'time': '${selectedTime.hour}:${selectedTime.minute}',
        'speciality': widget.speciality,
        'hospitalName': widget.hospitalName,
        'userId': _auth.currentUser!.uid,
      });

      _showSuccessDialog(emailSent);
    } catch (e) {
      print('Error: $e');
      _showErrorDialog(e.toString());
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _sendDataToAPI(Map<String, dynamic> data) async {
    try {
      final response = await http
          .post(
            Uri.parse('http://192.168.46.175:5000/add-patient'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(data),
          )
          .timeout(Duration(seconds: 10)); // Add a 10-second timeout

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to book appointment through API: ${response.statusCode}');
      }
    } on SocketException catch (e) {
      print('SocketException: $e');
      throw Exception(
          'Unable to connect to the server. Please check your network connection and try again.');
    } on TimeoutException catch (e) {
      print('TimeoutException: $e');
      throw Exception(
          'Connection timed out. The server took too long to respond.');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('An unexpected error occurred. Please try again later.');
    }
  }

  Future<pw.Document> _generatePDF(String appointmentId) async {
    final pdf = pw.Document();
    final qrImage = await QrPainter(
      data: appointmentId,
      version: QrVersions.auto,
      gapless: false,
    ).toImageData(200.0);

    final formattedTime =
        "${selectedTime.hour.toString().padLeft(2, '0')}:${selectedTime.minute.toString().padLeft(2, '0')}";

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
              pw.Text('Appointment Confirmation',
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Appointment ID: $appointmentId'),
              pw.Text('Patient Name: ${_auth.currentUser!.displayName}'),
              pw.Text('Doctor: ${widget.doctorName}'),
              pw.Text('Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}'),
              pw.Text('Time: $formattedTime'),
              pw.Text('Speciality: ${widget.speciality}'),
              pw.Text('Hospital: ${widget.hospitalName}'),
              pw.SizedBox(height: 20),
              pw.Image(pw.MemoryImage(qrImage!.buffer.asUint8List()),
                  width: 200, height: 200),
            ],
          );
        },
      ),
    );
    return pdf;
  }

  Future<bool> _sendEmail(String filePath) async {
    final smtpServer = gmail('22cs046@charusat.edu.in', 'ilex vmfy tstp ajnr');
    final message = Message()
      ..from = Address('22cs046@charusat.edu.in', '22cs046')
      ..recipients.add(_auth.currentUser!.email)
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

  void _showSuccessDialog(bool emailSent) {
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
                "Your appointment has been booked for ${DateFormat('yyyy-MM-dd').format(selectedDate)} at ${selectedTime.format(context)}.",
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
                Navigator.of(context).pop(); // Close the dialog
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
  }

  void _showErrorDialog(String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(errorMessage),
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
  }
}
