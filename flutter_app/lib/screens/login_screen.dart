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
  bool _showAccountOptions = false;
  String? _errorMessage;

  final TextEditingController _googleEmailController = TextEditingController();

  @override
  void dispose() {
    _googleEmailController.dispose();
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
                    'Customer waybills and support chats are processed strictly for delivery fulfillment and resolution tracking.',
                    style: TextStyle(fontSize: 11, color: Colors.grey, height: 1.4),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '2. Account Role Policy',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Google Sign-in accounts automatically default into Customer role. Staff and Admin clearances are managed by the administrator via Firebase.',
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

  void _handleGoogleSignIn({String? specificEmail}) {
    if (!_dpaConsent) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the Data Privacy Notice (RA 10173) before signing in with Google.'),
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
      final inputEmail = (specificEmail ?? _googleEmailController.text).trim().toLowerCase();
      // Admin account is gj8506@gmail.com; all other Google accounts automatically default into customer
      final bool isAdmin = inputEmail == 'gj8506@gmail.com';
      final String determinedRole = isAdmin ? 'admin' : 'customer';

      final String finalEmail = inputEmail.isNotEmpty
          ? inputEmail
          : (isAdmin ? 'gj8506@gmail.com' : 'new.customer@gmail.com');

      final String finalName = isAdmin
          ? 'GJ & Asher Admin'
          : (finalEmail.contains('@')
              ? finalEmail.split('@')[0].replaceAll(RegExp(r'[._]'), ' ').toUpperCase()
              : 'Google Customer');

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

      // Keep directory users in sync
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
                    const Text(
                      'GJandAsher ShipTracker',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.shipNavyPrimary,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Logistics Hub & Customer Order Tracking System',
                      style: TextStyle(fontSize: 11, color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 22),

                    // Main Google Sign-In Card
                    Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Text(
                              'Sign in to your account',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: AppColors.shipNavyPrimary,
                              ),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Center(
                            child: Text(
                              'Sign in with Google to view orders and chat with support',
                              style: TextStyle(fontSize: 11, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 14),

                          // Notice: Automatic customer default
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.lightBlue.shade50.withOpacity(0.6),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.lightBlue.shade100),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.info_outline, size: 16, color: Colors.lightBlue.shade800),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Google sign-in automatically defaults into a Customer account. Only Admin/Developer can configure staff roles in Firebase.',
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      color: Colors.lightBlue.shade900,
                                      height: 1.35,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // RA 10173 Consent Checkbox
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(12),
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
                                          'I agree to the Data Privacy Notice (RA 10173) for order tracking & messaging.',
                                          style: TextStyle(fontSize: 11, color: Colors.black87, height: 1.3),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: GestureDetector(
                                    onTap: _showPrivacyNoticeBottomSheet,
                                    child: const Padding(
                                      padding: EdgeInsets.only(top: 4),
                                      child: Text(
                                        'Read Privacy Notice',
                                        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold, color: AppColors.shipTealAccent),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Prominent "Sign in with Google" Button
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                backgroundColor: _dpaConsent ? Colors.white : Colors.grey.shade100,
                                foregroundColor: Colors.black87,
                                side: BorderSide(
                                  color: _dpaConsent ? Colors.grey.shade300 : Colors.grey.shade200,
                                  width: 1.2,
                                ),
                                elevation: _dpaConsent ? 0.5 : 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                              ),
                              onPressed: (_dpaConsent && !_isLoading) ? () => _handleGoogleSignIn() : null,
                              child: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(color: AppColors.shipNavyPrimary, strokeWidth: 2),
                                    )
                                  : Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        // Google Logo G representation
                                        Container(
                                          width: 22,
                                          height: 22,
                                          decoration: const BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white,
                                          ),
                                          child: Center(
                                            child: Text(
                                              'G',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blue.shade600,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        const Text(
                                          'Sign in with Google',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                            ),
                          ),

                          if (_errorMessage != null) ...[
                            const SizedBox(height: 10),
                            Text(_errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 11)),
                          ],

                          const SizedBox(height: 14),

                          // Expandable options for Google account selection / Admin gj8506
                          InkWell(
                            onTap: () => setState(() => _showAccountOptions = !_showAccountOptions),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text(
                                    'Choose specific Google account',
                                    style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500),
                                  ),
                                  Icon(
                                    _showAccountOptions ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                                    size: 16,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                            ),
                          ),

                          if (_showAccountOptions) ...[
                            const SizedBox(height: 8),
                            // Quick choice 1: Standard Customer Account
                            InkWell(
                              onTap: _dpaConsent
                                  ? () => _handleGoogleSignIn(specificEmail: 'new.customer@gmail.com')
                                  : null,
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.grey.shade200),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: const [
                                        Icon(Icons.person_outline, size: 16, color: Colors.blue),
                                        SizedBox(width: 8),
                                        Text('new.customer@gmail.com', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(4)),
                                      child: const Text('Customer', style: TextStyle(fontSize: 9, color: Colors.blue, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            // Quick choice 2: Admin gj8506@gmail.com
                            InkWell(
                              onTap: _dpaConsent
                                  ? () => _handleGoogleSignIn(specificEmail: 'gj8506@gmail.com')
                                  : null,
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: Colors.green.shade200),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: const [
                                        Icon(Icons.shield, size: 16, color: Colors.green),
                                        SizedBox(width: 8),
                                        Text('gj8506@gmail.com', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(4)),
                                      child: const Text('Admin', style: TextStyle(fontSize: 9, color: Colors.green, fontWeight: FontWeight.bold)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            // Custom email input
                            TextField(
                              controller: _googleEmailController,
                              style: const TextStyle(fontSize: 11.5),
                              decoration: InputDecoration(
                                hintText: 'Or enter custom @gmail.com...',
                                hintStyle: TextStyle(fontSize: 11, color: Colors.grey.shade400),
                                contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.arrow_forward, size: 16),
                                  onPressed: _dpaConsent ? () => _handleGoogleSignIn() : null,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    if (!_dpaConsent) ...[
                      const SizedBox(height: 12),
                      const Text(
                        'Please accept the privacy consent above to activate Google Sign-In.',
                        style: TextStyle(fontSize: 10.5, color: Colors.grey),
                        textAlign: TextAlign.center,
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
