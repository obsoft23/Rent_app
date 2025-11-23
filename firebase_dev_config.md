# Firebase Development Configuration
# To enable Firebase emulators for faster development builds:
#
# 1. Install Firebase CLI: npm install -g firebase-tools
# 2. Start emulators: firebase emulators:start
# 3. In FirebaseService, change initialize() to initializeWithEmulators()
#
# This will speed up development significantly by using local emulators
# instead of connecting to production Firebase services.

# Emulator ports (default):
# - Firestore: localhost:8080
# - Auth: localhost:9099
# - Storage: localhost:9199

# To use emulators in development:
# 1. Start emulators: firebase emulators:start
# 2. In FirebaseService.initializeWithEmulators(), comment out the line:
#    await FirebaseService.instance.initialize();
# 3. Uncomment the line:
#    await FirebaseService.instance.initializeWithEmulators();