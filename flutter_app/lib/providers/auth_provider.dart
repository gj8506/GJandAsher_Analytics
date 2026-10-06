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

// Offline test fallback role provider (used if running without Firebase)
final mockRoleProvider = StateProvider<String>((ref) => 'staff');

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
    error: (_, __) => Stream.value('staff'),
  );
});

// Admin verification provider
final isAdminProvider = Provider<bool>((ref) {
  final roleAsync = ref.watch(userRoleProvider);
  final mockRole = ref.watch(mockRoleProvider);

  // If real Firebase role is available:
  final realRole = roleAsync.value ?? mockRole;
  return realRole.toLowerCase() == 'admin';
});
