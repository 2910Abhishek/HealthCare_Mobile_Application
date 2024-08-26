// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';

// class ReportListScreen extends StatelessWidget {
//   final String title;
//   final List<File> reports;

//   const ReportListScreen({
//     Key? key,
//     required this.title,
//     required this.reports,
//   }) : super(key: key);

//   Future<void> _downloadFile(BuildContext context, File file) async {
//     try {
//       // Request storage permission
//       if (await Permission.storage.request().isGranted) {
//         // Get the application's document directory
//         Directory appDocDir = await getApplicationDocumentsDirectory();
//         String appDocPath = appDocDir.path;

//         // Create a new file in the document directory
//         String newFilePath = '$appDocPath/${file.path.split('/').last}';
//         File newFile = File(newFilePath);

//         // Copy the file to the new location
//         await newFile.writeAsBytes(await file.readAsBytes());

//         // Notify the user of the successful download
//         print('File downloaded to $newFilePath');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('File downloaded to $newFilePath')),
//         );
//       } else {
//         print('Storage permission denied');
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Storage permission denied')),
//         );
//       }
//     } catch (e) {
//       // Handle any errors
//       print('Error downloading file: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error downloading file: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(title),
//       ),
//       body: ListView.builder(
//         itemCount: reports.length,
//         itemBuilder: (context, index) {
//           final file = reports[index];
//           return ListTile(
//             leading: _isImageFile(file)
//                 ? Image.file(file, width: 50, height: 50, fit: BoxFit.cover)
//                 : _isPdfFile(file)
//                     ? Icon(Icons.picture_as_pdf, size: 50)
//                     : Icon(Icons.insert_drive_file, size: 50),
//             title: Text(file.path.split('/').last),
//             onTap: () {
//               // Open the file for viewing
//               Navigator.push(
//                 context,
//                 MaterialPageRoute(
//                   builder: (context) => ViewReportScreen(file: file),
//                 ),
//               );
//             },
//             trailing: IconButton(
//               icon: Icon(Icons.download),
//               onPressed: () {
//                 _downloadFile(context, file);
//               },
//             ),
//           );
//         },
//       ),
//     );
//   }

//   bool _isImageFile(File file) {
//     final ext = file.path.split('.').last.toLowerCase();
//     return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(ext);
//   }

//   bool _isPdfFile(File file) {
//     final ext = file.path.split('.').last.toLowerCase();
//     return ext == 'pdf';
//   }
// }

// class ViewReportScreen extends StatelessWidget {
//   final File file;

//   const ViewReportScreen({Key? key, required this.file}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(file.path.split('/').last),
//       ),
//       body: Center(
//         child: _isImageFile(file)
//             ? Image.file(file)
//             : _isPdfFile(file)
//                 ? PDFView(
//                     filePath: file.path,
//                   )
//                 : Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Text('Cannot display this file type'),
//                   ),
//       ),
//     );
//   }

//   bool _isImageFile(File file) {
//     final ext = file.path.split('.').last.toLowerCase();
//     return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(ext);
//   }

//   bool _isPdfFile(File file) {
//     final ext = file.path.split('.').last.toLowerCase();
//     return ext == 'pdf';
//   }
// }

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:share_plus/share_plus.dart';
import 'package:cross_file/cross_file.dart';

class ReportListScreen extends StatelessWidget {
  final String title;
  final List<File> reports;

  const ReportListScreen({
    Key? key,
    required this.title,
    required this.reports,
  }) : super(key: key);

  Future<void> _downloadFile(BuildContext context, File file) async {
    try {
      // Request storage permission
      if (await Permission.storage.request().isGranted) {
        // Get the application's document directory
        Directory appDocDir = await getApplicationDocumentsDirectory();
        String appDocPath = appDocDir.path;

        // Create a new file in the document directory
        String newFilePath = '$appDocPath/${file.path.split('/').last}';
        File newFile = File(newFilePath);

        // Copy the file to the new location
        await newFile.writeAsBytes(await file.readAsBytes());

        // Notify the user of the successful download
        print('File downloaded to $newFilePath');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('File downloaded to $newFilePath')),
        );
      } else {
        print('Storage permission denied');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Storage permission denied')),
        );
      }
    } catch (e) {
      // Handle any errors
      print('Error downloading file: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error downloading file: $e')),
      );
    }
  }

  Future<void> _shareFiles(BuildContext context, List<File> selectedFiles) async {
    try {
      List<XFile> xFiles = selectedFiles.map((file) => XFile(file.path)).toList();
      await Share.shareXFiles(xFiles, text: 'Sharing reports');
    } catch (e) {
      print('Error sharing files: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error sharing files: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              _showMultiSelect(context);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: reports.length,
        itemBuilder: (context, index) {
          final file = reports[index];
          return ListTile(
            leading: _isImageFile(file)
                ? Image.file(file, width: 50, height: 50, fit: BoxFit.cover)
                : _isPdfFile(file)
                    ? Icon(Icons.picture_as_pdf, size: 50)
                    : Icon(Icons.insert_drive_file, size: 50),
            title: Text(file.path.split('/').last),
            onTap: () {
              // Open the file for viewing
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewReportScreen(file: file),
                ),
              );
            },
            trailing: IconButton(
              icon: Icon(Icons.download),
              onPressed: () {
                _downloadFile(context, file);
              },
            ),
          );
        },
      ),
    );
  }

  void _showMultiSelect(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return MultiSelectDialog(
          reports: reports,
          onSharePressed: (selectedFiles) {
            _shareFiles(context, selectedFiles);
          },
        );
      },
    );
  }

  bool _isImageFile(File file) {
    final ext = file.path.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(ext);
  }

  bool _isPdfFile(File file) {
    final ext = file.path.split('.').last.toLowerCase();
    return ext == 'pdf';
  }
}

class MultiSelectDialog extends StatefulWidget {
  final List<File> reports;
  final Function(List<File>) onSharePressed;

  const MultiSelectDialog({
    Key? key,
    required this.reports,
    required this.onSharePressed,
  }) : super(key: key);

  @override
  _MultiSelectDialogState createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  List<File> _selectedFiles = [];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Select files to share'),
      content: SingleChildScrollView(
        child: ListBody(
          children: widget.reports.map((file) {
            return CheckboxListTile(
              title: Text(file.path.split('/').last),
              value: _selectedFiles.contains(file),
              onChanged: (bool? value) {
                setState(() {
                  if (value == true) {
                    _selectedFiles.add(file);
                  } else {
                    _selectedFiles.remove(file);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Share'),
          onPressed: () {
            widget.onSharePressed(_selectedFiles);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}

class ViewReportScreen extends StatelessWidget {
  final File file;

  const ViewReportScreen({Key? key, required this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(file.path.split('/').last),
      ),
      body: Center(
        child: _isImageFile(file)
            ? Image.file(file)
            : _isPdfFile(file)
                ? PDFView(
                    filePath: file.path,
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text('Cannot display this file type'),
                  ),
      ),
    );
  }

  bool _isImageFile(File file) {
    final ext = file.path.split('.').last.toLowerCase();
    return ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'].contains(ext);
  }

  bool _isPdfFile(File file) {
    final ext = file.path.split('.').last.toLowerCase();
    return ext == 'pdf';
  }
}