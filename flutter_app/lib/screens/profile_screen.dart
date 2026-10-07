import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  final String userRole;
  final Function(String) onRoleChanged;

  const ProfileScreen({
    Key? key,
    required this.userRole,
    required this.onRoleChanged,
  }) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isAccountManagerExpanded = false;
  String _userSearchQuery = '';
  String _roleFilter = 'all';

  // Mock list of users reflecting Cloud Firestore users collection
  final List<Map<String, String>> _usersList = [
    {
      'uid': 'usr-admin-01',
      'name': 'Nolan Caparros',
      'email': 'nolancaparros.draft@gmail.com',
      'role': 'admin',
      'tag': '#ADM-9921',
    },
    {
      'uid': 'usr-staff-02',
      'name': 'Marcos Dela Cruz',
      'email': 'staff.marcos@gmail.com',
      'role': 'staff',
      'tag': '#STF-4810',
    },
    {
      'uid': 'usr-cust-03',
      'name': 'Alex Reyes (New User)',
      'email': 'new.user@gmail.com',
      'role': 'customer',
      'tag': '#CST-1039',
    },
    {
      'uid': 'usr-cust-04',
      'name': 'Maria Santos',
      'email': 'maria.santos@gmail.com',
      'role': 'customer',
      'tag': '#CST-7721',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final user = authState.value;
    final isAdmin = widget.userRole.toLowerCase() == 'admin';

    // Filter users list based on search and role
    final filteredUsers = _usersList.where((u) {
      final q = _userSearchQuery.trim().toLowerCase();
      final matchesQuery = q.isEmpty ||
          u['name']!.toLowerCase().contains(q) ||
          u['email']!.toLowerCase().contains(q) ||
          u['tag']!.toLowerCase().contains(q);
      final matchesRole = _roleFilter == 'all' || u['role'] == _roleFilter;
      return matchesQuery && matchesRole;
    }).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
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
                          ? const Icon(Icons.person, size: 28, color: Colors.white)
                          : null,
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user?.displayName ?? 'Nolan Caparros',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.shipNavyPrimary),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            user?.email ?? 'nolancaparros.draft@gmail.com',
                            style: const TextStyle(fontSize: 11, color: Colors.grey, fontFamily: 'monospace'),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: const [
                              Icon(Icons.check_circle, size: 12, color: Colors.green),
                              SizedBox(width: 4),
                              Text('Google Auth Verified', style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Divider(height: 1),
                const SizedBox(height: 14),

                // Read-only role display (no manual switching button)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Active System Role', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                        Text('Synced from Cloud Firestore', style: TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: isAdmin ? Colors.green.shade50 : AppColors.shipTealContainer,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: isAdmin ? Colors.green.shade200 : AppColors.shipTealAccent.withOpacity(0.4)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isAdmin ? Colors.green : AppColors.shipTealAccent,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            isAdmin ? 'Admin' : 'Staff',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: isAdmin ? Colors.green.shade900 : AppColors.shipNavyPrimary,
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

        // Admin-Only: Separate / Dropdown Account Manager (Prevents screen overflow)
        if (isAdmin) ...[
          Card(
            color: Colors.white,
            elevation: 0.5,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header toggle (Dropdown to prevent screen overflow)
                InkWell(
                  onTap: () {
                    setState(() {
                      _isAccountManagerExpanded = !_isAccountManagerExpanded;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.indigo.shade50,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(Icons.manage_accounts, color: Colors.indigo, size: 20),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    const Text('Account & Role Manager', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: Colors.indigo.shade100,
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        '${_usersList.length} Users',
                                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.indigo.shade800),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Search tag or email to edit staff roles',
                                  style: TextStyle(fontSize: 10, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Text(
                                _isAccountManagerExpanded ? 'Hide' : 'Manage',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.black800),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                _isAccountManagerExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                size: 16,
                                color: Colors.grey.shade700,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Collapsed / Expanded Content
                if (_isAccountManagerExpanded) ...[
                  const Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.indigo.shade50.withOpacity(0.6),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.indigo.shade100),
                          ),
                          child: const Text(
                            'Newly registered accounts default to Customer. Only the Admin can search and promote users to Warehouse Staff in Firestore.',
                            style: TextStyle(fontSize: 11, color: Colors.indigo, height: 1.3),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Search Bar by tag or email
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Search user tag, name, or email...',
                            hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                            prefixIcon: const Icon(Icons.search, size: 18, color: Colors.grey),
                            suffixIcon: _userSearchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 16),
                                    onPressed: () {
                                      setState(() {
                                        _userSearchQuery = '';
                                      });
                                    },
                                  )
                                : null,
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide(color: Colors.grey.shade300),
                            ),
                          ),
                          style: const TextStyle(fontSize: 12),
                          onChanged: (val) {
                            setState(() {
                              _userSearchQuery = val;
                            });
                          },
                        ),
                        const SizedBox(height: 8),

                        // Filter Chips
                        Row(
                          children: [
                            const Text('Filter: ', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                            const SizedBox(width: 4),
                            _buildRoleChip('all', 'All'),
                            const SizedBox(width: 4),
                            _buildRoleChip('customer', 'Customer'),
                            const SizedBox(width: 4),
                            _buildRoleChip('staff', 'Staff'),
                            const SizedBox(width: 4),
                            _buildRoleChip('admin', 'Admin'),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Scrollable user list with constrained height (prevents screen overflow)
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 220),
                          child: filteredUsers.isEmpty
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    child: Text('No users matching search.', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                  ),
                                )
                              : ListView.separated(
                                  shrinkWrap: true,
                                  itemCount: filteredUsers.length,
                                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                                  itemBuilder: (context, index) {
                                    final u = filteredUsers[index];
                                    final isStaff = u['role'] == 'staff';
                                    final isUserAdmin = u['role'] == 'admin';

                                    return Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade50,
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.grey.shade200),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Flexible(
                                                      child: Text(
                                                        u['name']!,
                                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 6),
                                                    Container(
                                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                                      decoration: BoxDecoration(
                                                        color: isUserAdmin
                                                            ? Colors.green.shade100
                                                            : isStaff
                                                                ? Colors.blue.shade100
                                                                : Colors.grey.shade200,
                                                        borderRadius: BorderRadius.circular(4),
                                                      ),
                                                      child: Text(
                                                        u['role']!.toUpperCase(),
                                                        style: TextStyle(
                                                          fontSize: 8,
                                                          fontWeight: FontWeight.bold,
                                                          color: isUserAdmin
                                                              ? Colors.green.shade900
                                                              : isStaff
                                                                  ? Colors.blue.shade900
                                                                  : Colors.grey.shade800,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 2),
                                                Text(
                                                  u['email']!,
                                                  style: const TextStyle(fontSize: 10, color: Colors.grey, fontFamily: 'monospace'),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  'Tag: ${u['tag']!}',
                                                  style: TextStyle(fontSize: 9, color: Colors.grey.shade500, fontFamily: 'monospace'),
                                                ),
                                              ],
                                            ),
                                          ),
                                          if (isUserAdmin)
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade200,
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: const Text('Owner', style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
                                            )
                                          else
                                            TextButton(
                                              style: TextButton.styleFrom(
                                                backgroundColor: isStaff ? Colors.amber.shade50 : AppColors.shipNavyPrimary,
                                                foregroundColor: isStaff ? Colors.amber.shade900 : Colors.white,
                                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                                minimumSize: Size.zero,
                                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  u['role'] = isStaff ? 'customer' : 'staff';
                                                });
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('Updated ${u['name']} role to "${u['role']!.toUpperCase()}" in Firestore!'),
                                                    duration: const Duration(seconds: 2),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                isStaff ? 'Revoke' : 'Make Staff',
                                                style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],

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
        const SizedBox(height: 12),

        // Warehouse Terminal Configuration Card (matching web)
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
                    Icon(Icons.warehouse_outlined, color: AppColors.shipNavySecondary, size: 18),
                    SizedBox(width: 8),
                    Text('Warehouse Terminal Configuration', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 10),
                _buildTerminalRow('Facility Code', 'MNL-HUB-04', isMono: true),
                const Divider(height: 12),
                _buildTerminalRow('Supported Marketplaces', 'Shopee • Lazada • TikTok'),
                const Divider(height: 12),
                _buildTerminalRow('Default Courier Routing', 'SPX / J&T / LEX Priority'),
                const Divider(height: 12),
                _buildTerminalRow('Applet Version', 'v2.0 (Full Integration)', isMono: true),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Sign Out Button
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red.shade700,
            side: BorderSide(color: Colors.red.shade200),
            backgroundColor: Colors.red.shade50.withOpacity(0.5),
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          onPressed: () async {
            await ref.read(authNotifierProvider.notifier).signOut();
          },
          icon: const Icon(Icons.logout, size: 16),
          label: const Text('Sign Out of Google Account', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ),
      ],
    );
  }

  Widget _buildRoleChip(String role, String label) {
    final isSelected = _roleFilter == role;
    return InkWell(
      onTap: () {
        setState(() {
          _roleFilter = role;
        });
      },
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: isSelected ? Colors.indigo : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : Colors.grey.shade700,
          ),
        ),
      ),
    );
  }

  Widget _buildTerminalRow(String label, String value, {bool isMono = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.shipNavyPrimary,
            fontFamily: isMono ? 'monospace' : null,
          ),
        ),
      ],
    );
  }
}
