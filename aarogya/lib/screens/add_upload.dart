
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'multiple_image.dart';

Future<void> addUpload(BuildContext context, Function(String, File) onAdd) async {
  // Request storage permission
  if (!await _requestStoragePermission(context)) {
    return;
  }

  // Select report type
  String? reportType = await _selectReportType(context);
  if (reportType == null) return;

  // Select file source
  String? source = await _selectFileSource(context);
  if (source == null) return;

  File? pickedFile;

  if (source == 'Choose from Phone') {
    pickedFile = await _pickFileFromPhone();
  } else if (source == 'Take Photos') {
    String? fileName = await _promptFileName(context);
    if (fileName == null || fileName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File name is required.')),
      );
      return;
    }
    pickedFile = await _takePhotos(context, fileName);
  }

  if (pickedFile != null) {
    if (pickedFile.path.endsWith('.pdf')) {
      print('PDF file created: ${pickedFile.path}');
      onAdd(reportType, pickedFile);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a PDF file.')),
      );
    }
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('No file selected.')),
    );
  }
}

Future<bool> _requestStoragePermission(BuildContext context) async {
  bool storagePermissionGranted = await Permission.storage.isGranted ||
      await Permission.storage.request().isGranted ||
      await Permission.manageExternalStorage.isGranted ||
      await Permission.manageExternalStorage.request().isGranted;

  if (!storagePermissionGranted) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Storage permission is required to select a file.')),
    );
  }
  return storagePermissionGranted;
}

Future<String?> _selectReportType(BuildContext context) async {
  return await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: const Text('Select Report Type'),
        children: <Widget>[
          SimpleDialogOption(onPressed: () => Navigator.pop(context, 'Lab Reports'), child: const Text('Lab Reports')),
          SimpleDialogOption(onPressed: () => Navigator.pop(context, 'Doctor Notes'), child: const Text('Doctor Notes')),
          SimpleDialogOption(onPressed: () => Navigator.pop(context, 'Imaging'), child: const Text('Imaging')),
          SimpleDialogOption(onPressed: () => Navigator.pop(context, 'Prescription'), child: const Text('Prescription')),
          SimpleDialogOption(onPressed: () => Navigator.pop(context, 'Vaccination'), child: const Text('Vaccination')),
          SimpleDialogOption(onPressed: () => Navigator.pop(context, 'Other'), child: const Text('Other')),
        ],
      );
    },
  );
}

Future<String?> _selectFileSource(BuildContext context) async {
  return await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: const Text('Select File Source'),
        children: <Widget>[
          SimpleDialogOption(onPressed: () => Navigator.pop(context, 'Choose from Phone'), child: const Text('Choose from Phone')),
          SimpleDialogOption(onPressed: () => Navigator.pop(context, 'Take Photos'), child: const Text('Take Photos')),
        ],
      );
    },
  );
}

Future<File?> _pickFileFromPhone() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    allowMultiple: false,
    type: FileType.custom,
    allowedExtensions: ['pdf'],
  );
  if (result != null && result.files.single.path != null) {
    return File(result.files.single.path!);
  }
  return null;
}

Future<String?> _promptFileName(BuildContext context) async {
  TextEditingController fileNameController = TextEditingController();

  return await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Enter File Name'),
        content: TextField(
          controller: fileNameController,
          decoration: InputDecoration(hintText: "File Name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, null),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, fileNameController.text),
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}

Future<File?> _takePhotos(BuildContext context, String fileName) async {
  return await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => CaptureImagesScreen(
        fileName: fileName,
        onImagesCaptured: (List<File> images) async {
          if (images.isNotEmpty) {
            return await _convertImagesToPdf(images, fileName);
          }
          return null;
        },
      ),
    ),
  );
}

Future<File?> _convertImagesToPdf(List<File> imageFiles, String fileName) async {
  final pdf = pw.Document();

  for (var imageFile in imageFiles) {
    final image = pw.MemoryImage(imageFile.readAsBytesSync());
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Center(child: pw.Image(image));
        },
      ),
    );
  }

  final output = await getTemporaryDirectory();
  final file = File('${output.path}/$fileName.pdf');
  await file.writeAsBytes(await pdf.save());

  return file;
}
