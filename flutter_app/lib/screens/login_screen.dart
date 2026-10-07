import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../main.dart';
import '../providers/auth_provider.dart';
import '../services/auth_service.dart';
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

  void _showPrivacyNoticeBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
              child: ListView(
                controller: scrollController,
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
                      Icon(Icons.shield_outlined, color: AppColors.shipTealAccent, size: 28),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Republic Act No. 10173\nData Privacy Notice',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.shipNavyPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'GJ & Asher Logistics Management operates in compliance with the National Privacy Commission (NPC) of the Philippines.',
                    style: TextStyle(fontSize: 13, color: Colors.black87, height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '1. Purpose of Data Processing',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Processes outbound customer waybill data (tracking numbers, recipient names, addresses, and platform identifiers) strictly for fulfillment, returns assessment, and delivery dispute resolution.',
                    style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '2. Customer Protection & Messaging',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Customer-Admin messages are logged strictly for customer service audit and delivery inquiry resolutions.',
                    style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.4),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.shipNavyPrimary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () {
                      setState(() => _dpaConsent = true);
                      Navigator.pop(context);
                    },
                    child: const Text('I Understand & Agree', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _handleGoogleSignIn() async {
    if (!_dpaConsent) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      ref.read(portalProvider.notifier).state = _selectedPortal;
      final authService = ref.read(authServiceProvider);
      await authService.signInWithGoogle(dpaConsent: _dpaConsent);
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _handleDemoSignIn() {
    if (!_dpaConsent) return;
    ref.read(portalProvider.notifier).state = _selectedPortal;
    ref.read(mockRoleProvider.notifier).state = _selectedPortal == 'customer' ? 'customer' : 'staff';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.shipSurfaceLight,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.shipNavyPrimary,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shipNavyPrimary.withOpacity(0.2),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.local_shipping_rounded, color: Colors.white, size: 40),
                  ),
                ),
                const SizedBox(height: 16),

                // Title & Subtitle
                const Text(
                  'GJandAsher ShipTracker',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                    color: AppColors.shipNavyPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Logistics Hub & Customer Order Tracking System',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 20),

                // Portal Selector Options
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedPortal = 'customer'),
                        child: Container(
                          padding: const EdgeInsets.all(12),
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
                              Icon(Icons.person_pin, size: 20, color: AppColors.shipTealAccent),
                              SizedBox(height: 4),
                              Text('Customer Portal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                              Text('Track, shop & chat', style: TextStyle(fontSize: 9, color: Colors.grey)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedPortal = 'warehouse'),
                        child: Container(
                          padding: const EdgeInsets.all(12),
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
                              Icon(Icons.warehouse, size: 20, color: _selectedPortal == 'warehouse' ? Colors.white : Colors.grey),
                              const SizedBox(height: 4),
                              Text(
                                'Warehouse Hub',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: _selectedPortal == 'warehouse' ? Colors.white : Colors.black87,
                                ),
                              ),
                              Text(
                                'Staff & Admin dispatches',
                                style: TextStyle(
                                  fontSize: 9,
                                  color: _selectedPortal == 'warehouse' ? Colors.white70 : Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Mode Tabs
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => setState(() => _mode = 'login'),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            decoration: BoxDecoration(
                              color: _mode == 'login' ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Center(
                              child: Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 12,
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
                            padding: const EdgeInsets.symmetric(vertical: 7),
                            decoration: BoxDecoration(
                              color: _mode == 'signup' ? Colors.white : Colors.transparent,
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: Center(
                              child: Text(
                                'Register (First Time)',
                                style: TextStyle(
                                  fontSize: 12,
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
                const SizedBox(height: 14),

                // RA 10173 Consent Card
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: _dpaConsent ? AppColors.shipTealAccent.withOpacity(0.5) : Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Checkbox(
                            value: _dpaConsent,
                            activeColor: AppColors.shipNavyPrimary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            onChanged: (val) => setState(() => _dpaConsent = val ?? false),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _dpaConsent = !_dpaConsent),
                              child: const Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Text(
                                  'I acknowledge and agree to the Data Privacy Notice (RA 10173) for parcel tracking & messaging.',
                                  style: TextStyle(fontSize: 11, color: Colors.black87, height: 1.3),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: _showPrivacyNoticeBottomSheet,
                          icon: const Icon(Icons.info_outline, size: 13, color: AppColors.shipTealAccent),
                          label: const Text('Read Privacy Notice', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.shipTealAccent)),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                if (_errorMessage != null) ...[
                  Text(_errorMessage!, style: const TextStyle(color: Colors.red, fontSize: 11)),
                  const SizedBox(height: 12),
                ],

                // Action Button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _dpaConsent ? (_selectedPortal == 'customer' ? AppColors.shipTealAccent : AppColors.shipNavyPrimary) : Colors.grey.shade200,
                      foregroundColor: _dpaConsent ? Colors.white : Colors.grey.shade400,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: (_dpaConsent && !_isLoading) ? _handleGoogleSignIn : null,
                    child: _isLoading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : Text(
                            _selectedPortal == 'customer' ? 'Enter Customer Portal with Google' : 'Sign In to Warehouse Hub',
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                  ),
                ),

                const SizedBox(height: 12),

                // Demo fallback
                if (_dpaConsent)
                  TextButton.icon(
                    onPressed: _handleDemoSignIn,
                    icon: const Icon(Icons.touch_app, size: 14, color: Colors.grey),
                    label: Text(
                      'Enter as ${_selectedPortal == 'customer' ? 'Customer (Maria Santos)' : 'Staff (Demo)'}',
                      style: const TextStyle(fontSize: 11, color: Colors.grey),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
