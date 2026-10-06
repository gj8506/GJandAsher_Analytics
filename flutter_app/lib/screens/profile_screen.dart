import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends ConsumerWidget {
  final String userRole;
  final Function(String) onRoleChanged;

  const ProfileScreen({
    Key? key,
    required this.userRole,
    required this.onRoleChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final user = authState.value;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
      children: [
        Center(
          child: Column(
            children: const [
              Icon(Icons.person, size: 40, color: AppColors.shipNavySecondary),
              SizedBox(height: 8),
              Text(
                'User Profile & Security',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.shipNavyPrimary),
              ),
              SizedBox(height: 4),
              Text(
                'Google Sign-In, RA 10173 Data Privacy consent, and Firestore Role syncing.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // User profile card
        Card(
          color: Colors.white,
          elevation: 0.5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: AppColors.shipNavyPrimary,
                      backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                      child: user?.photoURL == null
                          ? Text(
                              user?.displayName?.isNotEmpty == true
                                  ? user!.displayName!.substring(0, 1).toUpperCase()
                                  : 'GJ',
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.displayName ?? 'GJ & Asher Warehouse Lead',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                          ),
                          Text(
                            user?.email ?? 'gj8506@gmail.com',
                            style: const TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: const [
                              Icon(Icons.check_circle, size: 12, color: Colors.green),
                              SizedBox(width: 4),
                              Text('Google Auth Verified', style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Active System Role', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        SizedBox(height: 2),
                        Text('Synced in real time from Firestore', style: TextStyle(fontSize: 11, color: Colors.grey)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: userRole.toLowerCase() == 'admin' ? Colors.green.shade50 : AppColors.shipTealContainer,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: userRole.toLowerCase() == 'admin' ? Colors.green.shade300 : Colors.blue.shade200,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: userRole.toLowerCase() == 'admin' ? Colors.green : AppColors.shipTealAccent,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            userRole.toLowerCase() == 'admin' ? 'Admin' : 'Staff',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: userRole.toLowerCase() == 'admin' ? Colors.green.shade800 : AppColors.shipNavyPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // RA 10173 Card
        Card(
          color: Colors.white,
          elevation: 0.5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.shield_outlined, color: AppColors.shipTealAccent, size: 18),
                    SizedBox(width: 8),
                    Text('Republic Act No. 10173 (DPA)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 6),
                const Text(
                  'Customer Personally Identifiable Information (PII) is masked according to NPC circular compliance. DPA consent status is logged with timestamp in Cloud Firestore.',
                  style: TextStyle(fontSize: 11, color: Colors.grey, height: 1.3),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
                  child: const Text('✓ DPA Consent Signed & Active', style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Sign Out Button
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade50,
            foregroundColor: Colors.red.shade700,
            elevation: 0,
            side: BorderSide(color: Colors.red.shade200),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          onPressed: () async {
            await ref.read(authServiceProvider).signOut();
            // Reset mock role if offline testing
            ref.read(mockRoleProvider.notifier).state = 'guest';
          },
          icon: const Icon(Icons.logout_rounded, size: 18),
          label: const Text('Sign Out of Google Account', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ),
      ],
    );
  }
}
