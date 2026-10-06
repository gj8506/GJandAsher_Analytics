import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  FirebaseAuth get _auth => FirebaseAuth.instance;
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Check if Firebase is initialized in runtime
  bool get isFirebaseInitialized => Firebase.apps.isNotEmpty;

  // Stream of auth state changes
  Stream<User?> get authStateChanges {
    if (isFirebaseInitialized) {
      return _auth.authStateChanges();
    }
    return Stream.value(null);
  }

  User? get currentUser {
    if (isFirebaseInitialized) {
      return _auth.currentUser;
    }
    return null;
  }

  // Stream of user role from Firestore users/{uid} in REAL TIME
  Stream<String> userRoleStream(String uid) {
    if (!isFirebaseInitialized) return Stream.value('staff');

    return _firestore.collection('users').doc(uid).snapshots().map((doc) {
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        return data['role'] as String? ?? 'staff';
      }
      return 'staff';
    });
  }

  // Google Sign-In with RA 10173 DPA Consent recording
  Future<UserCredential?> signInWithGoogle({required bool dpaConsent}) async {
    if (!dpaConsent) {
      throw Exception('Data Privacy Act (RA 10173) consent must be accepted to sign in.');
    }

    if (!isFirebaseInitialized) {
      throw Exception('Firebase is not initialized. Please ensure google-services.json is added.');
    }

    // Trigger the Google authentication flow
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      // User cancelled sign-in
      return null;
    }

    // Obtain auth details from request
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // Create a credential
    final OAuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in to Firebase with Google credentials
    final UserCredential userCredential = await _auth.signInWithCredential(credential);
    final User? user = userCredential.user;

    if (user != null) {
      final userDocRef = _firestore.collection('users').doc(user.uid);
      final userSnapshot = await userDocRef.get();

      if (!userSnapshot.exists) {
        // Module 2 Rule: On first login, create users/{uid} with role "staff"
        await userDocRef.set({
          'uid': user.uid,
          'email': user.email ?? '',
          'displayName': user.displayName ?? '',
          'photoUrl': user.photoURL ?? '',
          'role': 'staff', // strict default role
          'dpaConsent': true,
          'dpaConsentTimestamp': FieldValue.serverTimestamp(),
          'createdAt': FieldValue.serverTimestamp(),
          'lastLogin': FieldValue.serverTimestamp(),
        });
      } else {
        // Update last login
        await userDocRef.update({
          'lastLogin': FieldValue.serverTimestamp(),
          'photoUrl': user.photoURL ?? '',
          'displayName': user.displayName ?? '',
        });
      }
    }

    return userCredential;
  }

  // Sign out
  Future<void> signOut() async {
    if (isFirebaseInitialized) {
      await _googleSignIn.signOut();
      await _auth.signOut();
    }
  }
}
