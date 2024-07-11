// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class CaptureImagesScreen extends StatefulWidget {
//   final Function(List<File>) onImagesCaptured;

//   const CaptureImagesScreen({required this.onImagesCaptured, Key? key}) : super(key: key);

//   @override
//   _CaptureImagesScreenState createState() => _CaptureImagesScreenState();
// }

// class _CaptureImagesScreenState extends State<CaptureImagesScreen> {
//   final List<File> _images = [];
//   final ImagePicker _picker = ImagePicker();

//   Future<void> _captureImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.camera);
//     if (pickedFile != null) {
//       setState(() {
//         _images.add(File(pickedFile.path));
//       });
//     }
//   }

//   void _doneCapturing() {
//     Navigator.pop(context);
//     widget.onImagesCaptured(_images);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Capture Images'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.done),
//             onPressed: _doneCapturing,
//           )
//         ],
//       ),
//       body: Column(
//         children: [
//           ElevatedButton(
//             onPressed: _captureImage,
//             child: Text('Capture Image'),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: _images.length,
//               itemBuilder: (context, index) {
//                 return ListTile(
//                   leading: Image.file(_images[index]),
//                   title: Text(_images[index].path.split('/').last),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';

// class CaptureImagesScreen extends StatefulWidget {
//   final Future<File?> Function(List<File>) onImagesCaptured;

//   const CaptureImagesScreen({required this.onImagesCaptured, Key? key}) : super(key: key);

//   @override
//   _CaptureImagesScreenState createState() => _CaptureImagesScreenState();
// }

// class _CaptureImagesScreenState extends State<CaptureImagesScreen> {
//   final List<File> _images = [];
//   final ImagePicker _picker = ImagePicker();

//   Future<void> _captureImage() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.camera);
//     if (pickedFile != null) {
//       setState(() {
//         _images.add(File(pickedFile.path));
//       });
//     }
//   }

//   void _doneCapturing() async {
//     File? pdfFile = await widget.onImagesCaptured(_images);
//     Navigator.pop(context, pdfFile);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Capture Images'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.done),
//             onPressed: _doneCapturing,
//           )
//         ],
//       ),
//       body: Column(
//         children: [
//           ElevatedButton(
//             onPressed: _captureImage,
//             child: Text('Capture Image'),
//           ),
//           Expanded(
//             child: GridView.builder(
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2, // Change this value to control the number of columns in the grid
//               ),
//               itemCount: _images.length,
//               itemBuilder: (context, index) {
//                 return Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Image.file(_images[index], fit: BoxFit.cover),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }



import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CaptureImagesScreen extends StatefulWidget {
  final Future<File?> Function(List<File>) onImagesCaptured;
  final String fileName;

  const CaptureImagesScreen({required this.onImagesCaptured, required this.fileName, Key? key}) : super(key: key);

  @override
  _CaptureImagesScreenState createState() => _CaptureImagesScreenState();
}

class _CaptureImagesScreenState extends State<CaptureImagesScreen> {
  final List<File> _images = [];
  final ImagePicker _picker = ImagePicker();

  Future<void> _captureImage() async {
    if (await _requestCameraPermission()) {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        setState(() {
          _images.add(File(pickedFile.path));
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Camera permission is required to capture images.')),
      );
    }
  }

  Future<bool> _requestCameraPermission() async {
    if (await Permission.camera.isGranted) {
      return true;
    }
    return await Permission.camera.request().isGranted;
  }

  void _doneCapturing() async {
    if (_images.isNotEmpty) {
      File? pdfFile = await widget.onImagesCaptured(_images);
      if (pdfFile != null) {
        Navigator.pop(context, pdfFile);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create PDF file.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No images captured.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Capture Images'),
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: _doneCapturing,
          )
        ],
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _captureImage,
            child: Text('Capture Image'),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Change this value to control the number of columns in the grid
              ),
              itemCount: _images.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.file(_images[index], fit: BoxFit.cover),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
