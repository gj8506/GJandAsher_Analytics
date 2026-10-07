import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

// Stream of Firebase Auth user
final authStateProvider = StreamProvider<User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});

// Default to null so user is DIRECTLY placed on Login / Registration screen upon first open
final mockRoleProvider = StateProvider<String?>((ref) => null);

// Model for user profile
class UserProfile {
  final String uid;
  final String email;
  final String displayName;
  final String role; // 'admin' | 'staff' | 'customer'
  final String tag;
  final bool dpaConsent;

  UserProfile({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.role,
    required this.tag,
    this.dpaConsent = true,
  });
}

// Current logged in user profile (null when logged out)
final currentUserProfileProvider = StateProvider<UserProfile?>((ref) => null);

// Shared list of directory accounts in phone
// Contains ONLY gj8506@gmail.com as admin by default, other accounts removed as requested
final directoryUsersProvider = StateProvider<List<Map<String, String>>>((ref) => [
  {
    'uid': 'usr-admin-gj8506',
    'name': 'GJ & Asher Admin',
    'email': 'gj8506@gmail.com',
    'role': 'admin',
    'tag': '#ADM-8506',
  },
]);

// Stream of real-time role from Firestore: users/{uid}
final userRoleProvider = StreamProvider<String>((ref) {
  final authState = ref.watch(authStateProvider);
  final authService = ref.watch(authServiceProvider);

  return authState.when(
    data: (user) {
      if (user == null) {
        return Stream.value('guest');
      }
      return authService.userRoleStream(user.uid);
    },
    loading: () => Stream.value('loading'),
    error: (_, __) => Stream.value('customer'),
  );
});

// Admin verification provider
final isAdminProvider = Provider<bool>((ref) {
  final roleAsync = ref.watch(userRoleProvider);
  final mockRole = ref.watch(mockRoleProvider);
  final profile = ref.watch(currentUserProfileProvider);

  if (profile != null) {
    return profile.role.toLowerCase() == 'admin';
  }

  // If real Firebase role is available:
  final realRole = roleAsync.value ?? mockRole ?? 'guest';
  return realRole.toLowerCase() == 'admin';
});
