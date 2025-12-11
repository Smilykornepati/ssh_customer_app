import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;
import 'package:firebase_auth/firebase_auth.dart';

class StorageService {
  static final FirebaseStorage _storage = FirebaseStorage.instance;
  
  // Upload profile image
  static Future<String> uploadProfileImage(File imageFile) async {
    try {
      // Generate unique filename
      final fileName = 'profile_${DateTime.now().millisecondsSinceEpoch}${path.extension(imageFile.path)}';
      final reference = _storage.ref().child('profile_images/$fileName');
      
      // Upload file
      final uploadTask = reference.putFile(imageFile);
      final snapshot = await uploadTask;
      
      // Get download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (error) {
      throw Exception('Failed to upload image: $error');
    }
  }
  
  // Upload multiple images
  static Future<List<String>> uploadMultipleImages(List<File> imageFiles) async {
    try {
      final urls = <String>[];
      
      for (final imageFile in imageFiles) {
        final url = await uploadProfileImage(imageFile);
        urls.add(url);
      }
      
      return urls;
    } catch (error) {
      throw Exception('Failed to upload images: $error');
    }
  }
  
  // Delete image from storage
  static Future<void> deleteImage(String imageUrl) async {
    try {
      final ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (error) {
      throw Exception('Failed to delete image: $error');
    }
  }
  
  // Get file size
  static Future<int> getFileSize(File file) async {
    return await file.length();
  }
  
  // Check if file is within size limit (5MB)
  static bool isFileSizeValid(File file, {int maxSizeMB = 5}) {
    final sizeInBytes = file.lengthSync();
    final sizeInMB = sizeInBytes / (1024 * 1024);
    return sizeInMB <= maxSizeMB;
  }
}