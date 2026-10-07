import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../main.dart';
import '../providers/auth_provider.dart';
import '../theme/app_theme.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _dpaConsent = false;
  bool _isLoading = false;
  String? _errorMessage;
  String _mode = 'login'; // 'login' or 'signup'
  String _selectedPortal = 'customer'; // 'customer' or 'warehouse'

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  void _showPrivacyNoticeBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: const [
                      Icon(Icons.shield_outlined, color: AppColors.shipTealAccent, size: 26),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Republic Act No. 10173\nData Privacy Notice',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.shipNavyPrimary,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'GJ & Asher Logistics Management operates in compliance with the National Privacy Commission (NPC) of the Philippines.',
                    style: TextStyle(fontSize: 12, color: Colors.black87, height: 1.4),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '1. Purpose of Data Processing',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Outbound customer waybill information (tracking IDs, recipient names, addresses, and platform identifiers) is processed strictly for delivery fulfillment, returns assessment, and resolution tracking.',
                    style: TextStyle(fontSize: 11, color: Colors.grey, height: 1.4),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '2. Customer Protection & Direct Messaging',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Customer-Admin messages are logged strictly for support audit and delivery inquiry resolutions.',
                    style: TextStyle(fontSize: 11, color: Colors.grey, height: 1.4),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.shipNavyPrimary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        setState(() => _dpaConsent = true);
                        Navigator.pop(context);
                      },
                      child: const Text('I Understand & Agree', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _performSignIn({String? overrideEmail, String? overrideName, String? overrideRole}) {
    if (!_dpaConsent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please acknowledge the Data Privacy Act (RA 10173) agreement first.'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final inputEmail = (overrideEmail ?? _emailController.text).trim().toLowerCase();
      final isAdmin = inputEmail == 'gj8506@gmail.com' || (overrideRole == 'admin');
      
      String determinedRole = 'customer';
      if (isAdmin) {
        determinedRole = 'admin';
      } else if (overrideRole != null) {
        determinedRole = overrideRole;
      } else if (_selectedPortal == 'warehouse') {
        determinedRole = 'staff';
      }

      final String finalEmail = inputEmail.isNotEmpty
          ? inputEmail
          : (isAdmin ? 'gj8506@gmail.com' : 'new.customer@gmail.com');

      final String finalName = (overrideName ?? _nameController.text).trim().isNotEmpty
          ? (overrideName ?? _nameController.text).trim()
          : (isAdmin ? 'GJ & Asher Admin' : 'New Customer');

      final String finalTag = isAdmin
          ? '#ADM-8506'
          : '#CST-${(DateTime.now().millisecondsSinceEpoch % 9000 + 1000)}';

      final userProfile = UserProfile(
        uid: 'usr-${DateTime.now().millisecondsSinceEpoch}',
        email: finalEmail,
        displayName: finalName,
        role: determinedRole,
        tag: finalTag,
      );

      // Save to global providers
      ref.read(currentUserProfileProvider.notifier).state = userProfile;
      ref.read(mockRoleProvider.notifier).state = determinedRole;
      ref.read(portalProvider.notifier).state = determinedRole == 'customer' ? 'customer' : 'warehouse';

      // Keep directory users in sync: add newly registered user
      final dirUsers = ref.read(directoryUsersProvider);
      if (!dirUsers.any((u) => u['email']?.toLowerCase() == userProfile.email.toLowerCase())) {
        ref.read(directoryUsersProvider.notifier).state = [
          ...dirUsers,
          {
            'uid': userProfile.uid,
            'name': userProfile.displayName,
            'email': userProfile.email,
            'role': userProfile.role,
            'tag': userProfile.tag,
          }
        ];
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.shipSurfaceLight,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight - 32),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // App Logo
                    Container(
                      width: 68,
                      height: 68,
                      decoration: BoxDecoration(
                        color: AppColors.shipNavyPrimary,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shipNavyPrimary.withOpacity(0.2),
                            blurRadius: 14,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: const Center(
                        child: Icon(Icons.local_shipping_rounded, color: Colors.white, size: 36),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Title & Subtitle
                    const Text(
                      'GJandAsher ShipTracker',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                        color: AppColors.shipNavyPrimary,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'Logistics Hub & Customer Order Tracking System',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),

                    // Portal Selector Cards
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedPortal = 'customer'),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                color: _selectedPortal == 'customer' ? Colors.blue.shade50 : Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: _selectedPortal == 'customer' ? AppColors.shipTealAccent : Colors.grey.shade200,
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Icon(Icons.person_pin, size: 18, color: AppColors.shipTealAccent),
                                  SizedBox(height: 4),
                                  Text(
                                    'Customer Portal',
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.shipNavyPrimary),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Track, shop & chat',
                                    style: TextStyle(fontSize: 9, color: Colors.grey),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _selectedPortal = 'warehouse'),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                              decoration: BoxDecoration(
                                color: _selectedPortal == 'warehouse' ? AppColors.shipNavyPrimary : Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: _selectedPortal == 'warehouse' ? AppColors.shipNavyPrimary : Colors.grey.shade200,
                                  width: 1.5,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.warehouse, size: 18, color: _selectedPortal == 'warehouse' ? Colors.white : Colors.grey),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Warehouse Hub',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                      color: _selectedPortal == 'warehouse' ? Colors.white : AppColors.shipNavyPrimary,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    'Staff & Admin dispatch',
                                    style: TextStyle(
                                      fontSize: 9,
                                      color: _selectedPortal == 'warehouse' ? Colors.white70 : Colors.grey,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Mode Selector: Sign In vs Register
                    Container(
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _mode = 'login'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                  color: _mode == 'login' ? Colors.white : Colors.transparent,
                                  borderRadius: BorderRadius.circular(9),
                                  boxShadow: _mode == 'login'
                                      ? [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)]
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    'Sign In',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: _mode == 'login' ? AppColors.shipNavyPrimary : Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _mode = 'signup'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                  color: _mode == 'signup' ? Colors.white : Colors.transparent,
                                  borderRadius: BorderRadius.circular(9),
                                  boxShadow: _mode == 'signup'
                                      ? [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 4)]
                                      : null,
                                ),
                                child: Center(
                                  child: Text(
                                    'Register (First Time)',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                      color: _mode == 'signup' ? AppColors.shipNavyPrimary : Colors.grey.shade700,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Input Form Card
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (_mode == 'signup') ...[
                            const Text('Full Name', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            TextField(
                              controller: _nameController,
                              style: const TextStyle(fontSize: 12),
                              decoration: InputDecoration(
                                hintText: 'Enter your name (e.g. Nolan Cortez)',
                                hintStyle: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                          const Text('Google / Email Account', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          TextField(
                            controller: _emailController,
                            style: const TextStyle(fontSize: 12),
                            decoration: InputDecoration(
                              hintText: _mode == 'signup' ? 'your.email@gmail.com' : 'Enter email (or use quick buttons)',
                              hintStyle: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _mode == 'signup'
                                ? 'Newly registered users default to Customer. Admin can promote to Staff.'
                                : 'Type "gj8506@gmail.com" for Admin access or sign in as a New Customer.',
                            style: const TextStyle(fontSize: 9.5, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // RA 10173 Consent Card
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: _dpaConsent ? AppColors.shipTealAccent.withOpacity(0.5) : Colors.grey.shade200,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 22,
                                height: 22,
                                child: Checkbox(
                                  value: _dpaConsent,
                                  activeColor: AppColors.shipNavyPrimary,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                  onChanged: (val) => setState(() => _dpaConsent = val ?? false),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _dpaConsent = !_dpaConsent),
                                  child: const Text(
                                    'I acknowledge and agree to the Data Privacy Notice (RA 10173) for order tracking & messaging.',
                                    style: TextStyle(fontSize: 11, color: Colors.black87, height: 1.3),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: _showPrivacyNoticeBottomSheet,
                              icon: const Icon(Icons.info_outline, size: 12, color: AppColors.shipTealAccent),
                              label: const Text(
                                'Read Privacy Notice',
                                style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: AppColors.shipTealAccent),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    if (_errorMessage != null) ...[
                      Text(_errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 11)),
                      const SizedBox(height: 8),
                    ],

                    // Main Action Button (Sign In / Register)
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _dpaConsent
                              ? (_selectedPortal == 'customer' ? AppColors.shipTealAccent : AppColors.shipNavyPrimary)
                              : Colors.grey.shade200,
                          foregroundColor: _dpaConsent ? Colors.white : Colors.grey.shade400,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: (_dpaConsent && !_isLoading) ? () => _performSignIn() : null,
                        child: _isLoading
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : Text(
                                _mode == 'signup'
                                    ? 'Register New Customer Account'
                                    : (_selectedPortal == 'customer' ? 'Sign In as New Customer' : 'Enter Warehouse Hub'),
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5),
                              ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Quick access shortcuts
                    if (_dpaConsent) ...[
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 8,
                        runSpacing: 4,
                        children: [
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () => _performSignIn(
                              overrideEmail: 'new.customer@gmail.com',
                              overrideName: 'New Customer',
                              overrideRole: 'customer',
                            ),
                            icon: const Icon(Icons.person_add_alt, size: 13, color: Colors.grey),
                            label: const Text(
                              'Continue as New Customer',
                              style: TextStyle(fontSize: 10.5, color: Colors.grey, fontWeight: FontWeight.w600),
                            ),
                          ),
                          TextButton.icon(
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: () => _performSignIn(
                              overrideEmail: 'gj8506@gmail.com',
                              overrideName: 'GJ & Asher Admin',
                              overrideRole: 'admin',
                            ),
                            icon: const Icon(Icons.shield, size: 13, color: Colors.green),
                            label: const Text(
                              'Sign In as Admin (gj8506)',
                              style: TextStyle(fontSize: 10.5, color: Colors.green, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
