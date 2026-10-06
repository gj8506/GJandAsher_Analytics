import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
                    'This application processes outbound customer waybill data (tracking numbers, recipient names, addresses, and platform identifiers) strictly for fulfillment, returns assessment, and delivery dispute resolution.',
                    style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '2. Staff Confidentiality & Role Access',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'All signed-in personnel are assigned strict role-based permissions. Staff accounts can view and log manifests. Admin accounts are restricted to leadership (Mr. Nolan Caparros) for aggregate analytics.',
                    style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.4),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '3. Consent Timestamp',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Upon checking the consent box, your authenticated user ID and system timestamp are permanently logged in Cloud Firestore.',
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.shipSurfaceLight,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Logo
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.shipNavyPrimary,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shipNavyPrimary.withOpacity(0.2),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(Icons.local_shipping_rounded, color: Colors.white, size: 44),
                  ),
                ),
                const SizedBox(height: 20),

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
                const SizedBox(height: 6),
                const Text(
                  'Outbound Logistics, Analytics & Returns Manager\nShopee • Lazada • TikTok Shop',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 36),

                // RA 10173 Consent Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: _dpaConsent ? AppColors.shipTealAccent.withOpacity(0.5) : Colors.grey.shade200,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.02),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
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
                            onChanged: (val) {
                              setState(() => _dpaConsent = val ?? false);
                            },
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _dpaConsent = !_dpaConsent),
                              child: const Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text(
                                  'I acknowledge and agree to the Data Privacy Notice (RA 10173) for warehouse logistics processing.',
                                  style: TextStyle(fontSize: 12, color: Colors.black87, height: 1.3),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: _showPrivacyNoticeBottomSheet,
                          icon: const Icon(Icons.info_outline, size: 14, color: AppColors.shipTealAccent),
                          label: const Text(
                            'Read Privacy Notice',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: AppColors.shipTealAccent,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Error message banner
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.red, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Google Sign-In Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _dpaConsent ? Colors.white : Colors.grey.shade100,
                      foregroundColor: _dpaConsent ? AppColors.shipNavyPrimary : Colors.grey.shade400,
                      elevation: _dpaConsent ? 1 : 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                        side: BorderSide(
                          color: _dpaConsent ? Colors.grey.shade300 : Colors.grey.shade200,
                        ),
                      ),
                    ),
                    onPressed: (_dpaConsent && !_isLoading) ? _handleGoogleSignIn : null,
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.network(
                                'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
                                width: 20,
                                height: 20,
                                errorBuilder: (_, __, ___) => const Icon(Icons.g_mobiledata, size: 24),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Sign in with Google',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),

                if (!_dpaConsent) ...[
                  const SizedBox(height: 8),
                  const Text(
                    'Sign-in is blocked until privacy consent is acknowledged.',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
