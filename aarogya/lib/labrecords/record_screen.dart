import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';
import 'dart:io';
import 'add_upload.dart';
import 'ReportListScreen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Color.fromRGBO(11, 143, 172, 1),
    statusBarIconBrightness: Brightness.light,
  ));
  runApp(MaterialApp(
    theme: ThemeData(
      primaryColor: Color.fromRGBO(11, 143, 172, 1),
      appBarTheme: AppBarTheme(
        backgroundColor: Color.fromRGBO(11, 143, 172, 1),
        elevation: 0,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Color.fromRGBO(11, 143, 172, 1),
          statusBarIconBrightness: Brightness.light,
        ),
      ),
    ),
    home: Upload(),
  ));
}

class Upload extends StatefulWidget {
  const Upload({Key? key}) : super(key: key);

  @override
  State<Upload> createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  List<File> _labReports = [];
  List<File> _doctornotes = [];
  List<File> _imaging = [];
  List<File> _vaccination = [];
  List<File> _prescription = [];
  List<File> _other = [];

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color.fromRGBO(11, 143, 172, 1),
      statusBarIconBrightness: Brightness.light,
    ));
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _setStatusBarColor();
    });
  }

  @override
  void dispose() {
    _resetStatusBarColor();
    super.dispose();
  }

  Future<void> _setStatusBarColor() async {
    await FlutterStatusbarcolor.setStatusBarColor(
      Color.fromRGBO(11, 143, 172, 1),
    );
    await FlutterStatusbarcolor.setStatusBarWhiteForeground(true);
  }

  Future<void> _resetStatusBarColor() async {
    await FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    await FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
  }

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
          _imaging.add(imageFile);
          break;
        case 'Vaccination':
          _vaccination.add(imageFile);
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

  Widget _buildCard(
      String title, IconData icon, int count, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Container(
          padding: EdgeInsets.all(4),
          height: 100,
          width: 100,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40),
              SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(height: 4),
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
      extendBodyBehindAppBar: false,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(11, 143, 172, 1),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top,
                  left: 16,
                  right: 16,
                  bottom: 10,
                ),
                decoration: BoxDecoration(
                  color: Color.fromRGBO(11, 143, 172, 1),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 100),
                    Text(
                      'Records',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: _buildCard(
                            'Lab Reports', Icons.bloodtype, _labReports.length,
                            () {
                          _showReportList(context, 'Lab Reports', _labReports);
                        }),
                      ),
                      _buildCard('Doctor Notes', Icons.bloodtype_outlined,
                          _doctornotes.length, () {
                        _showReportList(context, 'Doctor Notes', _doctornotes);
                      }),
                      _buildCard(
                          'Imaging', Icons.medical_services, _imaging.length,
                          () {
                        _showReportList(context, 'Imaging', _imaging);
                      }),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: _buildCard(
                            'Vaccination', Icons.bloodtype, _vaccination.length,
                            () {
                          _showReportList(context, 'Vaccination', _vaccination);
                        }),
                      ),
                      _buildCard(
                          'Prescription', Icons.note, _prescription.length, () {
                        _showReportList(context, 'Prescription', _prescription);
                      }),
                      _buildCard('Other', Icons.folder, _other.length, () {
                        _showReportList(context, 'Other', _other);
                      }),
                    ],
                  ),
                  SizedBox(height: 40),
                  GestureDetector(
                    onTap: () => addUpload(context, _handleAddUpload),
                    child: Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        color: Color.fromRGBO(11, 143, 172, 1),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 4,
                            offset: Offset(0, 3),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
