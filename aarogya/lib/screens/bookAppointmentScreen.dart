import 'package:flutter/material.dart';
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
    required this.imagePath,
    required this.rating,
  });

  @override
  _BookAppointmentScreenState createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay(hour: 8, minute: 30);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    DoctorScreen(hospitalName: widget.hospitalName),
              ),
            );
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
      body: SingleChildScrollView(
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
                      onPressed: _bookAppointment,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeSlot(String time) {
    bool isSelected = isTimeEqual(selectedTime, time);
    return GestureDetector(
      onTap: () {
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
          color: isSelected ? Colors.blue : Colors.grey.shade200,
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

  void _bookAppointment() async {
    String appointmentId = DateTime.now().millisecondsSinceEpoch.toString();
    final pdf = await _generatePDF(appointmentId);
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/appointment.pdf");
    await file.writeAsBytes(await pdf.save());

    bool emailSent = await _sendEmail(file.path);

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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<pw.Document> _generatePDF(String appointmentId) async {
    final pdf = pw.Document();

    String formattedTime = DateFormat('hh:mm a').format(DateTime(
      2022,
      1,
      1,
      selectedTime.hour,
      selectedTime.minute,
    ));

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Appointment Details',
                  style: pw.TextStyle(
                      fontSize: 20, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Patient Name: [Patient Name]'),
              pw.Text('Doctor Name: ${widget.doctorName}'),
              pw.Text('Hospital Name: ${widget.hospitalName}'),
              pw.Text('Date: ${DateFormat('yyyy-MM-dd').format(selectedDate)}'),
              pw.Text('Time: $formattedTime'),
              pw.SizedBox(height: 20),
              pw.Text('Appointment ID: $appointmentId'),
              pw.SizedBox(height: 20),
              pw.BarcodeWidget(
                barcode: pw.Barcode.qrCode(),
                data: appointmentId,
                width: 200,
                height: 200,
              ),
            ],
          );
        },
      ),
    );

    return pdf;
  }

  Future<bool> _sendEmail(String attachmentPath) async {
    String username = '22cs046@charusat.edu.in';
    String password = 'zxae wivo lacd gnni'; // Use secure methods to store this

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'Abhishek ')
      ..recipients.add(
          '29abhishek.parmar@gmail.com') // Replace with actual patient email
      ..subject = 'Appointment Confirmation'
      ..text = 'Please find attached your appointment details.'
      ..attachments = [FileAttachment(File(attachmentPath))];

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      return true;
    } on MailerException catch (e) {
      print('Message not sent. \n' + e.toString());
      return false;
    }
  }
}
