// lib/resources/storage_services.dart

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get currentUserId => _auth.currentUser?.uid;

  Future<String> uploadFile(File file, String folderName) async {
    if (currentUserId == null) throw Exception('No user logged in');

    String fileName =
        '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';

    Reference ref =
        _storage.ref().child(currentUserId!).child(folderName).child(fileName);

    await ref.putFile(file);
    String downloadUrl = await ref.getDownloadURL();
    return downloadUrl;
  }

  Future<List<Map<String, String>>> getFiles(String folderName) async {
    if (currentUserId == null) throw Exception('No user logged in');

    List<Map<String, String>> files = [];

    try {
      ListResult result = await _storage
          .ref()
          .child(currentUserId!)
          .child(folderName)
          .listAll();

      for (var item in result.items) {
        String downloadUrl = await item.getDownloadURL();
        files.add({
          'name': item.name,
          'url': downloadUrl,
        });
      }
    } catch (e) {
      print('Error getting files: $e');
    }

    return files;
  }

  Future<void> deleteFile(String folderName, String fileName) async {
    if (currentUserId == null) throw Exception('No user logged in');

    try {
      await _storage
          .ref()
          .child(currentUserId!)
          .child(folderName)
          .child(fileName)
          .delete();
    } catch (e) {
      print('Error deleting file: $e');
      throw e;
    }
  }
}
