import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rentapp/services/firebase_service.dart';

class ProfileController extends GetxController {
  // Use FirebaseService for lazy initialization
  FirebaseAuth get _auth => FirebaseService.instance.auth;
  FirebaseFirestore get _firestore => FirebaseService.instance.firestore;
  FirebaseStorage get _storage => FirebaseService.instance.storage;
  final ImagePicker _picker = ImagePicker();

  var isLoading = false.obs;

  User? get currentUser => _auth.currentUser;

  /// Upload profile picture to Firebase Storage and update user document
  Future<String?> uploadProfilePicture() async {
    try {
      isLoading.value = true;

      final user = currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      // Pick image from gallery
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image == null) {
        print('No image selected');
        isLoading.value = false;
        return null;
      }

      print('🔵 Image selected: ${image.path}');

      // Create storage reference
      final storageRef = _storage.ref().child(
        'profile_pictures/${user.uid}/profile.jpg',
      );

      // Upload file
      print('🔵 Uploading image to Firebase Storage...');
      final uploadTask = await storageRef.putFile(File(image.path));

      // Get download URL
      final downloadURL = await uploadTask.ref.getDownloadURL();
      print('✅ Image uploaded successfully: $downloadURL');

      // Update Firestore user document
      await _firestore.collection('users').doc(user.uid).set({
        'photoURL': downloadURL,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Update Firebase Auth profile
      await user.updatePhotoURL(downloadURL);
      await user.reload();

      print('✅ Profile picture updated in Firestore and Auth');

      isLoading.value = false;
      return downloadURL;
    } catch (e) {
      print('🔴 Error uploading profile picture: $e');
      isLoading.value = false;
      throw Exception('Failed to upload profile picture: $e');
    }
  }

  /// Update user display name
  Future<void> updateDisplayName(String displayName) async {
    try {
      isLoading.value = true;

      final user = currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      // Update Firestore
      await _firestore.collection('users').doc(user.uid).set({
        'displayName': displayName,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Update Firebase Auth profile
      await user.updateDisplayName(displayName);
      await user.reload();

      print('✅ Display name updated: $displayName');

      isLoading.value = false;
    } catch (e) {
      print('🔴 Error updating display name: $e');
      isLoading.value = false;
      throw Exception('Failed to update display name');
    }
  }

  /// Update phone number in Firestore
  Future<void> updatePhoneNumber(String phoneNumber) async {
    try {
      isLoading.value = true;

      final user = currentUser;
      if (user == null) {
        throw Exception('No user logged in');
      }

      await _firestore.collection('users').doc(user.uid).set({
        'phoneNumber': phoneNumber,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      print('✅ Phone number updated: $phoneNumber');

      isLoading.value = false;
    } catch (e) {
      print('🔴 Error updating phone number: $e');
      isLoading.value = false;
      throw Exception('Failed to update phone number');
    }
  }
}
