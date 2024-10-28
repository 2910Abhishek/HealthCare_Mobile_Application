// lib/resources/ReportListScreen.dart

import 'package:aarogya/resources/record_model.dart';
import 'package:flutter/material.dart';

class ReportListScreen extends StatelessWidget {
  final String title;
  final List<MedicalRecord> records;
  final Function(MedicalRecord) onDelete;

  const ReportListScreen({
    Key? key,
    required this.title,
    required this.records,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Color.fromRGBO(11, 143, 172, 1),
      ),
      body: ListView.builder(
        itemCount: records.length,
        itemBuilder: (context, index) {
          final record = records[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(record.fileName),
              subtitle: Text(
                  'Uploaded: ${record.uploadDate.toString().split('.')[0]}'),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => onDelete(record),
              ),
              onTap: () {
                // Handle viewing the file - you can add PDF viewer or image viewer here
              },
            ),
          );
        },
      ),
    );
  }
}
