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



// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';

// class CaptureImagesScreen extends StatefulWidget {
//   final Future<File?> Function(List<File>) onImagesCaptured;
//   final String fileName;

//   const CaptureImagesScreen({required this.onImagesCaptured, required this.fileName, Key? key}) : super(key: key);

//   @override
//   _CaptureImagesScreenState createState() => _CaptureImagesScreenState();
// }

// class _CaptureImagesScreenState extends State<CaptureImagesScreen> {
//   final List<File> _images = [];
//   final ImagePicker _picker = ImagePicker();

//   Future<void> _captureImage() async {
//     if (await _requestCameraPermission()) {
//       final pickedFile = await _picker.pickImage(source: ImageSource.camera);
//       if (pickedFile != null) {
//         setState(() {
//           _images.add(File(pickedFile.path));
//         });
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Camera permission is required to capture images.')),
//       );
//     }
//   }

//   Future<bool> _requestCameraPermission() async {
//     if (await Permission.camera.isGranted) {
//       return true;
//     }
//     return await Permission.camera.request().isGranted;
//   }

//   void _doneCapturing() async {
//     if (_images.isNotEmpty) {
//       File? pdfFile = await widget.onImagesCaptured(_images);
//       if (pdfFile != null) {
//         Navigator.pop(context, pdfFile);
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Failed to create PDF file.')),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('No images captured.')),
//       );
//     }
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
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class CaptureImagesScreen extends StatefulWidget {
  final Future<File?> Function(List<File>) onImagesCaptured;
  final String fileName;

  const CaptureImagesScreen({required this.onImagesCaptured, required this.fileName, Key? key}) : super(key: key);

  @override
  _CaptureImagesScreenState createState() => _CaptureImagesScreenState();
}

class _CaptureImagesScreenState extends State<CaptureImagesScreen> {
  late List<CameraDescription> cameras;
  CameraController? controller;
  List<File> capturedImages = [];
  bool isCapturing = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    if (await _requestCameraPermission()) {
      cameras = await availableCameras();
      controller = CameraController(cameras[0], ResolutionPreset.medium);
      await controller!.initialize();
      setState(() {});
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

  Future<void> _captureImage() async {
    if (!controller!.value.isInitialized || isCapturing) {
      return;
    }

    setState(() {
      isCapturing = true;
    });

    try {
      final image = await controller!.takePicture();
      setState(() {
        capturedImages.add(File(image.path));
      });
    } catch (e) {
      print('Error capturing image: $e');
    } finally {
      setState(() {
        isCapturing = false;
      });
    }
  }

  void _doneCapturing() async {
    if (capturedImages.isNotEmpty) {
      File? pdfFile = await widget.onImagesCaptured(capturedImages);
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
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null || !controller!.value.isInitialized) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
          Expanded(
            flex: 3,
            child: CameraPreview(controller!),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    icon: Icon(Icons.camera_alt, color: Colors.white),
                    onPressed: _captureImage,
                  ),
                  Text(
                    '${capturedImages.length} images',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
              ),
              itemCount: capturedImages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Image.file(capturedImages[index], fit: BoxFit.cover),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
