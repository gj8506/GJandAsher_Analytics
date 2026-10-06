import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends StatelessWidget {
  final String userRole;
  final Function(String) onRoleChanged;

  const ProfileScreen({
    Key? key,
    required this.userRole,
    required this.onRoleChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                      radius: 24,
                      backgroundColor: AppColors.shipNavyPrimary,
                      child: const Text('GJ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('GJ & Asher Logistics Hub', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text('gj8506@gmail.com', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Divider(),
                const Text('Active Role (Firestore Synced)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                const SizedBox(height: 8),
                Row(
                  children: ['Staff Mode', 'Admin Mode'].map((r) {
                    final isChosen = userRole == r;
                    return Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            backgroundColor: isChosen ? AppColors.shipNavyPrimary : Colors.white,
                            foregroundColor: isChosen ? Colors.white : Colors.black87,
                            side: BorderSide(color: isChosen ? AppColors.shipNavyPrimary : Colors.grey.shade300),
                          ),
                          onPressed: () => onRoleChanged(r),
                          child: Text(r, style: const TextStyle(fontSize: 12)),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          color: Colors.white,
          elevation: 0.5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Republic Act No. 10173', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                SizedBox(height: 4),
                Text(
                  'Customer Personally Identifiable Information (PII) is masked in transit logs according to NPC circular compliance.',
                  style: TextStyle(fontSize: 11, color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
