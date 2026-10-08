import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/parcel.dart';
import '../../models/product.dart';
import '../../providers/auth_provider.dart';
import '../../theme/app_theme.dart';
import 'customer_parcels_screen.dart';
import 'customer_store_screen.dart';
import 'customer_chat_screen.dart';

class CustomerPortalScreen extends ConsumerStatefulWidget {
  final List<Parcel> parcels;
  final List<Product> products;
  final List<ChatMessage> chatMessages;
  final Function(String, String?, String?) onSendMessage;
  final Function(Parcel) onSelectParcel;
  final VoidCallback onSignOut;
  final bool isAdminTyping;

  const CustomerPortalScreen({
    Key? key,
    required this.parcels,
    required this.products,
    required this.chatMessages,
    required this.onSendMessage,
    required this.onSelectParcel,
    required this.onSignOut,
    this.isAdminTyping = false,
  }) : super(key: key);

  @override
  ConsumerState<CustomerPortalScreen> createState() => _CustomerPortalScreenState();
}

class _CustomerPortalScreenState extends ConsumerState<CustomerPortalScreen> {
  int _currentIndex = 0;
  String? _pendingInquiry;

  void _handleInquireParcel(Parcel parcel) {
    setState(() {
      _pendingInquiry = 'Checking delivery status for tracking #${parcel.trackingNumber}';
      _currentIndex = 2; // Jump to Chat
    });
  }

  void _handleInquireProduct(Product product) {
    setState(() {
      _pendingInquiry = 'Hello Admin! Inquiring about stock for ${product.name} (${product.price})';
      _currentIndex = 2; // Jump to Chat
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(currentUserProfileProvider);
    final displayName = userProfile?.displayName ?? 'New Customer';
    final displayEmail = userProfile?.email ?? 'customer@shiptracker.ph';

    final screens = [
      CustomerParcelsScreen(
        parcels: widget.parcels,
        customerName: displayName,
        onSelectParcel: widget.onSelectParcel,
        onInquireInChat: _handleInquireParcel,
      ),
      CustomerStoreScreen(
        products: widget.products,
        onInquireProduct: _handleInquireProduct,
      ),
      CustomerChatScreen(
        messages: widget.chatMessages,
        onSendMessage: widget.onSendMessage,
        initialInquiry: _pendingInquiry,
        isAdminTyping: widget.isAdminTyping,
      ),
      _buildCustomerAccountScreen(displayName, displayEmail, userProfile?.tag ?? '#CST-NEW'),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.person_pin, size: 20, color: AppColors.shipTealAccent),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                'Customer Portal • $displayName',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.shipNavyPrimary,
        actions: [
          IconButton(
            onPressed: widget.onSignOut,
            icon: const Icon(Icons.logout_rounded, color: Colors.white70, size: 20),
            tooltip: 'Sign Out of Customer Account',
          ),
        ],
      ),
      body: SafeArea(child: screens[_currentIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) {
          setState(() {
            _currentIndex = idx;
            if (idx != 2) _pendingInquiry = null;
          });
        },
        indicatorColor: AppColors.shipNavyPrimary,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.local_shipping_outlined),
            selectedIcon: Icon(Icons.local_shipping, color: Colors.white),
            label: 'My Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.storefront_outlined),
            selectedIcon: Icon(Icons.storefront, color: Colors.white),
            label: 'Store',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble, color: Colors.white),
            label: 'Admin Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: Colors.white),
            label: 'Account',
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerAccountScreen(String name, String email, String tag) {
    final initials = name.split(' ').map((n) => n.isNotEmpty ? n[0] : '').take(2).join('').toUpperCase();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        Card(
          color: Colors.white,
          elevation: 0.5,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.shipTealAccent,
                  child: Text(
                    initials.isNotEmpty ? initials : 'CU',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15), overflow: TextOverflow.ellipsis),
                      Text(email, style: const TextStyle(color: Colors.grey, fontSize: 11, fontFamily: 'monospace'), overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(6)),
                            child: const Text('Customer Account', style: TextStyle(color: Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 6),
                          Text(tag, style: const TextStyle(color: Colors.grey, fontSize: 10, fontFamily: 'monospace')),
                        ],
                      ),
                    ],
                  ),
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
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.shield_outlined, color: AppColors.shipTealAccent, size: 18),
                    SizedBox(width: 8),
                    Text('Data Privacy Protection (RA 10173)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  'Your account is secured under the Data Privacy Act of 2012. Order waybills, recipient names, addresses, and chat inquiries are strictly protected.',
                  style: TextStyle(fontSize: 11, color: Colors.grey, height: 1.4),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8)),
                  child: const Text('✓ DPA Consent Verified & Recorded', style: TextStyle(fontSize: 10.5, color: Colors.green, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: Colors.red.shade700,
            side: BorderSide(color: Colors.red.shade200),
            backgroundColor: Colors.red.shade50.withOpacity(0.5),
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          ),
          onPressed: widget.onSignOut,
          icon: const Icon(Icons.logout, size: 16),
          label: const Text('Sign Out of Customer Portal', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ),
      ],
    );
  }
}
