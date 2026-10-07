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

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final firebaseUser = authState.value;
    final userProfile = ref.watch(currentUserProfileProvider);
    final usersList = ref.watch(directoryUsersProvider);

    final isAdmin = widget.userRole.toLowerCase() == 'admin' ||
        (userProfile?.role.toLowerCase() == 'admin');

    // Filter users list based on search and role
    final filteredUsers = usersList.where((u) {
      final q = _userSearchQuery.trim().toLowerCase();
      final matchesQuery = q.isEmpty ||
          (u['name'] ?? '').toLowerCase().contains(q) ||
          (u['email'] ?? '').toLowerCase().contains(q) ||
          (u['tag'] ?? '').toLowerCase().contains(q);
      final matchesRole = _roleFilter == 'all' || u['role'] == _roleFilter;
      return matchesQuery && matchesRole;
    }).toList();

    final displayName = userProfile?.displayName ??
        firebaseUser?.displayName ??
        (isAdmin ? 'GJ & Asher Admin' : 'Staff Member');
    final displayEmail = userProfile?.email ??
        firebaseUser?.email ??
        (isAdmin ? 'gj8506@gmail.com' : 'staff@shiptracker.ph');
    final displayTag = userProfile?.tag ?? (isAdmin ? '#ADM-8506' : '#STF-1001');

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 120),
      children: [
        Center(
          child: Column(
            children: const [
              Icon(Icons.person, size: 36, color: AppColors.shipNavySecondary),
              SizedBox(height: 6),
              Text(
                'User Profile & Security',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: AppColors.shipNavyPrimary),
              ),
              SizedBox(height: 3),
              Text(
                'Google Sign-In, RA 10173 Data Privacy consent, and Firestore Role syncing.',
                style: TextStyle(fontSize: 11, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

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
                      radius: 24,
                      backgroundColor: AppColors.shipNavyPrimary,
                      child: Text(
                        isAdmin ? 'GJ' : 'ST',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            displayName,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.shipNavyPrimary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            displayEmail,
                            style: const TextStyle(fontSize: 11, color: Colors.grey, fontFamily: 'monospace'),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Icon(Icons.check_circle, size: 12, color: Colors.green),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  'Auth Verified • $displayTag',
                                  style: const TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(height: 1),
                const SizedBox(height: 12),

                // Read-only role display
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Active System Role', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                        Text('Synced from Cloud Firestore', style: TextStyle(fontSize: 9.5, color: Colors.grey)),
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
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: Colors.indigo.shade50,
                                  borderRadius: BorderRadius.circular(9),
                                ),
                                child: const Icon(Icons.manage_accounts, color: Colors.indigo, size: 18),
                              ),
                              const SizedBox(width: 9),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Text('Account & Role Manager', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                                        const SizedBox(width: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                          decoration: BoxDecoration(
                                            color: Colors.indigo.shade100,
                                            borderRadius: BorderRadius.circular(5),
                                          ),
                                          child: Text(
                                            '${usersList.length}',
                                            style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.bold, color: Colors.indigo.shade800),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 2),
                                    const Text(
                                      'Search tag or email to edit staff roles',
                                      style: TextStyle(fontSize: 9.5, color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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
                                style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: Colors.black87),
                              ),
                              const SizedBox(width: 4),
                              Icon(
                                _isAccountManagerExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                size: 15,
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
                            'Newly registered accounts default to Customer. Admin can promote them to Warehouse Staff.',
                            style: TextStyle(fontSize: 10.5, color: Colors.indigo, height: 1.3),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Search Bar by tag or email
                        TextField(
                          decoration: InputDecoration(
                            hintText: 'Search user tag, name, or email...',
                            hintStyle: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                            prefixIcon: const Icon(Icons.search, size: 16, color: Colors.grey),
                            suffixIcon: _userSearchQuery.isNotEmpty
                                ? IconButton(
                                    icon: const Icon(Icons.clear, size: 15),
                                    onPressed: () => setState(() => _userSearchQuery = ''),
                                  )
                                : null,
                            filled: true,
                            fillColor: Colors.grey.shade50,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
                            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: Colors.grey.shade300)),
                          ),
                          style: const TextStyle(fontSize: 11.5),
                          onChanged: (val) => setState(() => _userSearchQuery = val),
                        ),
                        const SizedBox(height: 8),

                        // Filter Chips
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              const Text('Filter: ', style: TextStyle(fontSize: 9.5, color: Colors.grey, fontWeight: FontWeight.bold)),
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
                        ),
                        const SizedBox(height: 10),

                        // Scrollable user list with constrained height (prevents screen overflow)
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 220),
                          child: filteredUsers.isEmpty
                              ? const Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    child: Text('No users matching search query.', style: TextStyle(fontSize: 11, color: Colors.grey)),
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
                                                        u['name'] ?? 'User',
                                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11.5),
                                                        overflow: TextOverflow.ellipsis,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5),
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
                                                        (u['role'] ?? 'customer').toUpperCase(),
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
                                                  u['email'] ?? '',
                                                  style: const TextStyle(fontSize: 9.5, color: Colors.grey, fontFamily: 'monospace'),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                Text(
                                                  'Tag: ${u['tag'] ?? ''}',
                                                  style: TextStyle(fontSize: 8.5, color: Colors.grey.shade500, fontFamily: 'monospace'),
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
                                              child: const Text('Admin', style: TextStyle(fontSize: 9.5, color: Colors.grey, fontWeight: FontWeight.bold)),
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
                                                final newRole = isStaff ? 'customer' : 'staff';
                                                final updatedList = usersList.map((entry) {
                                                  if (entry['uid'] == u['uid']) {
                                                    return {
                                                      ...entry,
                                                      'role': newRole,
                                                    };
                                                  }
                                                  return entry;
                                                }).toList();
                                                ref.read(directoryUsersProvider.notifier).state = updatedList;

                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text('Updated ${u['name']} role to "${newRole.toUpperCase()}"!'),
                                                    duration: const Duration(seconds: 2),
                                                  ),
                                                );
                                              },
                                              child: Text(
                                                isStaff ? 'Revoke' : 'Make Staff',
                                                style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.bold),
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
            ref.read(mockRoleProvider.notifier).state = null;
            ref.read(currentUserProfileProvider.notifier).state = null;
            await ref.read(authServiceProvider).signOut();
          },
          icon: const Icon(Icons.logout, size: 16),
          label: const Text('Sign Out of Account', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
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
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2.5),
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
        Text(label, style: const TextStyle(fontSize: 11.5, color: Colors.grey)),
        Flexible(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.shipNavyPrimary,
              fontFamily: isMono ? 'monospace' : null,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
