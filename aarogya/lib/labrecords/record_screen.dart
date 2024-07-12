
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'add_upload.dart';
import 'ReportListScreen.dart'; // Import the new screen

class Upload extends StatefulWidget {
  const Upload({super.key});

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  List<File> _labReports = [];
  List<File> _doctornotes = [];
  List<File> _Imaging = [];
  List<File> _Vaccination = [];
  List<File> _prescription = [];
  List<File> _other = [];

  void _handleAddUpload(String reportType, File imageFile) {
    setState(() {
      switch (reportType) {
        case 'Lab Reports':
          _labReports.add(imageFile);
          break;
        case 'Doctor Notes':
          _doctornotes.add(imageFile);
          break;
        case 'Imaging':
          _Imaging.add(imageFile);
          break;
        case 'Vaccination':
          _Vaccination.add(imageFile);
          break;
        case 'Prescription':
          _prescription.add(imageFile);
          break;
        case 'Other':
          _other.add(imageFile);
          break;
      }
    });
  }

  Widget _buildCard(String title, IconData icon, int count, Function onTap) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Card(
        child: Container(
          width: 100,
          height: 100,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40),
              Text(
                title,
                style: TextStyle(fontSize: 12),
              ),
              Text(
                '$count',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReportList(BuildContext context, String title, List<File> reports) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportListScreen(
          title: title,
          reports: reports,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Records'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCard('Lab Reports', Icons.bloodtype, _labReports.length, () {
                      _showReportList(context, 'Lab Reports', _labReports);
                    }),
                    _buildCard('Doctor note', Icons.bloodtype_outlined, _doctornotes.length, () {
                      _showReportList(context, 'Doctor note', _doctornotes);
                    }),
                    _buildCard('Imaging', Icons.medical_services, _Imaging.length, () {
                      _showReportList(context, 'Imaging', _Imaging);
                    }),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCard('Vaccination', Icons.bloodtype, _Vaccination.length, () {
                      _showReportList(context, 'Vaccination', _Vaccination);
                    }),
                    _buildCard('Prescription', Icons.note, _prescription.length, () {
                      _showReportList(context, 'Prescription', _prescription);
                    }),
                    _buildCard('Other', Icons.folder, _other.length, () {
                      _showReportList(context, 'Other', _other);
                    }),
                  ],
                ),
              ],
            ),
            SizedBox(height: 20), // Add some space between cards and the button
            Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: GestureDetector(
                  onTap: () => addUpload(context, _handleAddUpload),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 12),  // Adjust padding
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30.0),
                      color: Color.fromRGBO(11, 143, 172, 1),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Text(
                      'Add New Records',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // Adjust space below the button
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Upload(),
  ));
}
