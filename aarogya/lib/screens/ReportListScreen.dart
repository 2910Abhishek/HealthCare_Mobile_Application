
// import 'package:flutter/material.dart';
// import 'dart:io';
// import 'package:path_provider/path_provider.dart';
// import 'package:flutter_file_downloader/flutter_file_downloader.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';

// class ReportListScreen extends StatelessWidget {
//   final String title;
//   final List<File> reports;

//   const ReportListScreen({
//     Key? key,
//     required this.title,
//     required this.reports,
//   }) : super(key: key);

//   Future<void> _downloadFile(File file) async {
//     try {
//       // Get the application's document directory
//       Directory appDocDir = await getApplicationDocumentsDirectory();
//       String appDocPath = appDocDir.path;

//       // Create a new file in the document directory
//       String newFilePath = '$appDocPath/${file.path.split('/').last}';
//       File newFile = File(newFilePath);

//       // Copy the file to the new location
//       await newFile.writeAsBytes(await file.readAsBytes());

//       // Notify the user of the successful download
//       print('File downloaded to $newFilePath');
//     } catch (e) {
//       // Handle any errors
//       print('Error downloading file: $e');
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
//                 ? Image.file(file, width: 25, height: 25, fit: BoxFit.cover)
//                 : _isPdfFile(file)
//                     ? Icon(Icons.picture_as_pdf)
//                     : Icon(Icons.insert_drive_file),
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
//                 _downloadFile(file);
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
//                 : Text('Cannot display this file type'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView.builder(
        itemCount: reports.length,
        itemBuilder: (context, index) {
          final file = reports[index];
          return ListTile(
            leading: _isImageFile(file)
                ? Image.file(file, width: 25, height: 25, fit: BoxFit.cover)
                : _isPdfFile(file)
                    ? Icon(Icons.picture_as_pdf)
                    : Icon(Icons.insert_drive_file),
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
                _downloadFile(context, file);  // Pass context here
              },
            ),
          );
        },
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
                : Text('Cannot display this file type'),
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
