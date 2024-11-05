import 'package:flutter/material.dart';
import 'package:aarogya/resources/record_model.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

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

  String _formatFileName(String fileName) {
    // Remove UUID or timestamp prefix if present (assuming it ends with underscore)
    final parts = fileName.split('_');
    if (parts.length > 1) {
      return parts
          .sublist(1)
          .join('_'); // Takes everything after first underscore
    }
    return fileName;
  }

  Future<void> _sharePdf(
      BuildContext context, String url, String fileName) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(child: CircularProgressIndicator());
        },
      );

      final response = await http.get(Uri.parse(url));
      final bytes = response.bodyBytes;
      final temp = await getTemporaryDirectory();
      final file = File('${temp.path}/$fileName');
      await file.writeAsBytes(bytes);

      Navigator.pop(context);

      final xFile = XFile(file.path, mimeType: 'application/pdf');
      await Share.shareXFiles(
        [xFile],
        text: 'Sharing medical record: $fileName',
      );
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sharing file: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Color.fromRGBO(11, 143, 172, 1),
      ),
      body: ListView.builder(
        itemCount: records.length,
        padding: EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final record = records[index];
          final displayName = _formatFileName(record.fileName);
          final date =
              record.uploadDate.toString().split(' ')[0]; // Get just the date

          return Card(
            elevation: 3,
            margin: EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PDFViewerScreen(
                      url: record.downloadUrl,
                      fileName: displayName,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    // PDF Icon Container
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(11, 143, 172, 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.picture_as_pdf,
                        color: Color.fromRGBO(11, 143, 172, 1),
                        size: 30,
                      ),
                    ),
                    SizedBox(width: 16),
                    // File Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Uploaded: $date',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Action Buttons
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.share),
                          color: Color.fromRGBO(11, 143, 172, 1),
                          onPressed: () => _sharePdf(
                            context,
                            record.downloadUrl,
                            record.fileName,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline),
                          color: Colors.red[400],
                          onPressed: () => onDelete(record),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PDFViewerScreen extends StatelessWidget {
  final String url;
  final String fileName;

  const PDFViewerScreen({
    Key? key,
    required this.url,
    required this.fileName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(fileName),
        backgroundColor: Color.fromRGBO(11, 143, 172, 1),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () async {
              try {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return Center(child: CircularProgressIndicator());
                  },
                );

                final response = await http.get(Uri.parse(url));
                final bytes = response.bodyBytes;
                final temp = await getTemporaryDirectory();
                final file = File('${temp.path}/$fileName');
                await file.writeAsBytes(bytes);

                Navigator.pop(context);

                final xFile = XFile(file.path, mimeType: 'application/pdf');
                await Share.shareXFiles(
                  [xFile],
                  text: 'Sharing medical record: $fileName',
                );
              } catch (e) {
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error sharing file: $e')),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: SfPdfViewer.network(
        url,
        canShowPaginationDialog: true,
      ),
    );
  }
}
