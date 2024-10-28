import 'dart:io';
import 'package:aarogya/resources/ReportListScreen.dart';
import 'package:aarogya/resources/add_upload.dart';
import 'package:aarogya/resources/record_model.dart';
import 'package:aarogya/resources/storage_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_statusbarcolor_ns/flutter_statusbarcolor_ns.dart';

class RecordScreen extends StatefulWidget {
  const RecordScreen({Key? key}) : super(key: key);

  @override
  State<RecordScreen> createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  final StorageService _storageService = StorageService();

  Map<String, List<MedicalRecord>> _records = {
    'Lab Reports': [],
    'Doctor Notes': [],
    'Imaging': [],
    'Vaccination': [],
    'Prescription': [],
    'Other': [],
  };

  @override
  void initState() {
    super.initState();
    _loadAllRecords(); // Load records when screen initializes
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

  Future<void> _loadAllRecords() async {
    for (String folder in _records.keys) {
      try {
        final files = await _storageService.getFiles(folder);
        setState(() {
          _records[folder] = files
              .map((file) => MedicalRecord(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    fileName: file['name'] ?? '',
                    downloadUrl: file['url'] ?? '',
                    type: folder,
                    uploadDate: DateTime.now(),
                  ))
              .toList();
        });
      } catch (e) {
        print('Error loading $folder: $e');
      }
    }
  }

  Future<void> _handleAddRecordScreen(String reportType, File imageFile) async {
    try {
      String downloadUrl =
          await _storageService.uploadFile(imageFile, reportType);

      print(downloadUrl);

      final newRecord = MedicalRecord(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        fileName: imageFile.path.split('/').last,
        downloadUrl: downloadUrl,
        type: reportType,
        uploadDate: DateTime.now(),
      );

      setState(() {
        _records[reportType]?.add(newRecord);
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading file: $e')),
      );
    }
  }

  void _showReportList(
      BuildContext context, String title, List<MedicalRecord> reports) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReportListScreen(
          title: title,
          records: reports,
          onDelete: (record) async {
            try {
              await _storageService.deleteFile(record.type, record.fileName);
              setState(() {
                _records[record.type]?.removeWhere((r) => r.id == record.id);
              });
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error deleting file: $e')),
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildCard(String title, IconData icon, VoidCallback onTap) {
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
                '${_records[title]?.length ?? 0}',
                style: TextStyle(fontSize: 15, color: Colors.grey),
              ),
            ],
          ),
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
                          'Lab Reports',
                          Icons.bloodtype,
                          () => _showReportList(
                            context,
                            'Lab Reports',
                            _records['Lab Reports'] ?? [],
                          ),
                        ),
                      ),
                      _buildCard(
                        'Doctor Notes',
                        Icons.bloodtype_outlined,
                        () => _showReportList(
                          context,
                          'Doctor Notes',
                          _records['Doctor Notes'] ?? [],
                        ),
                      ),
                      _buildCard(
                        'Imaging',
                        Icons.medical_services,
                        () => _showReportList(
                          context,
                          'Imaging',
                          _records['Imaging'] ?? [],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Flexible(
                        child: _buildCard(
                          'Vaccination',
                          Icons.bloodtype,
                          () => _showReportList(
                            context,
                            'Vaccination',
                            _records['Vaccination'] ?? [],
                          ),
                        ),
                      ),
                      _buildCard(
                        'Prescription',
                        Icons.note,
                        () => _showReportList(
                          context,
                          'Prescription',
                          _records['Prescription'] ?? [],
                        ),
                      ),
                      _buildCard(
                        'Other',
                        Icons.folder,
                        () => _showReportList(
                          context,
                          'Other',
                          _records['Other'] ?? [],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  GestureDetector(
                    onTap: () => addUpload(context, _handleAddRecordScreen),
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
