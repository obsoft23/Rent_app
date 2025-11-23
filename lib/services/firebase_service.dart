import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:rentapp/firebase_options.dart';

class FirebaseService {
  static FirebaseService? _instance;
  static FirebaseService get instance => _instance ??= FirebaseService._();

  FirebaseService._();

  FirebaseApp? _app;
  FirebaseAuth? _auth;
  FirebaseFirestore? _firestore;
  FirebaseStorage? _storage;

  bool _isInitialized = false;

  /// Initialize Firebase with optimized settings
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Production initialization
      _app = await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Configure Firestore settings for better performance
      _firestore = FirebaseFirestore.instance;
      _firestore!.settings = const Settings(
        persistenceEnabled: true,
        cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
      );

      // Initialize other services
      _auth = FirebaseAuth.instance;
      _storage = FirebaseStorage.instance;

      _isInitialized = true;
      print('🔥 Firebase initialized successfully');
    } catch (e) {
      print('❌ Firebase initialization failed: $e');
      rethrow;
    }
  }

  /// Initialize with Firebase Emulators (for development)
  /// To enable emulators, call this method instead of initialize()
  Future<void> initializeWithEmulators() async {
    if (_isInitialized) return;

    try {
      _app = await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      // Connect to emulators for faster development
      const String emulatorHost = 'localhost';
      FirebaseFirestore.instance.useFirestoreEmulator(emulatorHost, 8080);
      await FirebaseAuth.instance.useAuthEmulator('$emulatorHost', 9099);
      await FirebaseStorage.instance.useStorageEmulator(emulatorHost, 9199);

      // Configure Firestore for emulators
      _firestore = FirebaseFirestore.instance;
      _auth = FirebaseAuth.instance;
      _storage = FirebaseStorage.instance;

      _isInitialized = true;
      print('🔥 Firebase emulators connected');
    } catch (e) {
      print('❌ Firebase emulator initialization failed: $e');
      rethrow;
    }
  }

  /// Get Firebase Auth instance (lazy loaded)
  FirebaseAuth get auth {
    if (!_isInitialized) throw Exception('Firebase not initialized');
    return _auth!;
  }

  /// Get Firestore instance (lazy loaded)
  FirebaseFirestore get firestore {
    if (!_isInitialized) throw Exception('Firebase not initialized');
    return _firestore!;
  }

  /// Get Storage instance (lazy loaded)
  FirebaseStorage get storage {
    if (!_isInitialized) throw Exception('Firebase not initialized');
    return _storage!;
  }

  /// Check if Firebase is ready
  bool get isInitialized => _isInitialized;

  /// Get current user (convenience method)
  User? get currentUser => _auth?.currentUser;
}
