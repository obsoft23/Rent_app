// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rentapp/view/Home/home_page.dart';
import 'package:rentapp/view/single_main_pages/location_permission.dart';
import 'package:rentapp/view/single_main_pages/notification_permissionrequestpage.dart';
import 'package:rentapp/services/firebase_service.dart';

class AuthController extends GetxController {
  // Use FirebaseService for lazy initialization
  FirebaseAuth get _auth => FirebaseService.instance.auth;
  FirebaseFirestore get _firestore => FirebaseService.instance.firestore;

  // Observable for loading state
  var isLoading = false.obs;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Stream of auth state changes
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign up with email and password
  Future<void> registerUser(
    String email,
    String password,
    BuildContext context,
  ) async {
    print('🔵 Starting registration for: $email');
    try {
      isLoading.value = true;
      print('🔵 Calling Firebase createUserWithEmailAndPassword...');

      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      print('🔵 User created: ${userCredential.user?.uid}');
      if (userCredential.user != null) {
        // Create user document in Firestore
        print('🔵 Creating user document...');
        await _createUserDocument(userCredential.user!.uid, email);
        print('🔵 User document created');

        // Navigate based on permission status
        print('🔵 Navigating based on permissions...');
        await _navigateBasedOnPermissions();
        print('🔵 Navigation completed');
      }
    } on FirebaseAuthException catch (e) {
      print('🔴 FirebaseAuthException: ${e.code} - ${e.message}');
      String message = '';

      switch (e.code) {
        case 'weak-password':
          message = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          message = 'An account already exists for that email.';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        default:
          message = 'An error occurred. Please try again.';
      }

      isLoading.value = false;
      throw Exception(message);
    } catch (e) {
      print('🔴 General exception: $e');
      isLoading.value = false;
      throw Exception('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // Sign in with email and password
  Future<void> loginUser(
    String email,
    String password,
    BuildContext context,
  ) async {
    try {
      isLoading.value = true;

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        // Navigate based on permission status
        await _navigateBasedOnPermissions();
      }
    } on FirebaseAuthException catch (e) {
      String message = '';

      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for that email.';
          break;
        case 'wrong-password':
          message = 'Wrong password provided.';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        case 'user-disabled':
          message = 'This user has been disabled.';
          break;
        case 'invalid-credential':
          message = 'Invalid email or password.';
          break;
        default:
          message = 'An error occurred. Please try again.';
      }

      isLoading.value = false;
      throw Exception(message);
    } catch (e) {
      isLoading.value = false;
      throw Exception('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw Exception('Failed to sign out. Please try again.');
    }
  }

  // Send password reset email
  Future<void> resetPassword(String email, BuildContext context) async {
    try {
      isLoading.value = true;
      await _auth.sendPasswordResetEmail(email: email);
      // Success - caller will show success message
    } on FirebaseAuthException catch (e) {
      String message = '';

      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for that email.';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        default:
          message = 'An error occurred. Please try again.';
      }

      isLoading.value = false;
      throw Exception(message);
    } catch (e) {
      isLoading.value = false;
      throw Exception('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  // Create user document in Firestore
  Future<void> _createUserDocument(String uid, String email) async {
    try {
      print('🔵 _createUserDocument called for uid: $uid');
      print('🔵 Attempting to write to Firestore...');
      print('🔵 Collection: users, Document: $uid');

      // Try to write with a longer timeout
      await _firestore
          .collection('users')
          .doc(uid)
          .set({
            'uid': uid,
            'email': email,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
            'displayName': '',
            'photoURL': '',
            'phoneNumber': '',
            'isAgent': false,
          })
          .timeout(
            Duration(seconds: 30),
            onTimeout: () {
              print('⚠️  Firestore write timed out after 30 seconds');
              print(
                '⚠️  This is not critical - you can continue using the app',
              );
              print('⚠️  Please ensure:');
              print('⚠️    1. Firestore is created in Firebase Console');
              print('⚠️    2. You have internet connection');
              print(
                '⚠️  Visit: https://console.firebase.google.com/project/ngrent-b6a74/firestore',
              );
              throw Exception('Firestore write timed out');
            },
          );

      print('✅ User document saved to Firestore successfully');

      // Verify document was created by reading it back
      final docSnapshot = await _firestore.collection('users').doc(uid).get();
      if (docSnapshot.exists) {
        print('✅ User document verified: ${docSnapshot.data()}');
      }
    } catch (e) {
      print('⚠️  Warning: Could not create user document in Firestore');
      print('⚠️  Error: $e');
      print('⚠️  You can still use the app, but some features may be limited');
      print(
        '⚠️  To fix: Visit https://console.firebase.google.com/project/ngrent-b6a74/firestore',
      );
      print('⚠️  And ensure Firestore Database is created');

      // Don't crash - allow user to continue
      // The app can still function with just Firebase Auth
    }
  }

  // Navigate based on permission status
  Future<void> _navigateBasedOnPermissions() async {
    print('🔵 Checking permissions...');
    final locationStatus = await Permission.location.status;
    final notificationStatus = await Permission.notification.status;
    print('🔵 Location: $locationStatus, Notification: $notificationStatus');

    if (locationStatus.isGranted && notificationStatus.isGranted) {
      // Both permissions granted, go to HomePage
      print('🔵 Both permissions granted, navigating to HomePage');
      Get.offAll(() => const HomePage());
    } else if (locationStatus.isGranted) {
      // Location granted but not notifications, go to notification page
      print(
        '🔵 Only location granted, navigating to NotificationPermissionRequestPage',
      );
      Get.offAll(() => const NotificationPermissionRequestPage());
    } else {
      // Location not granted, go to location page first
      print('🔵 No location permission, navigating to LocationPermissionPage');
      Get.offAll(() => const LocationPermissionPage());
    }
  }
}
