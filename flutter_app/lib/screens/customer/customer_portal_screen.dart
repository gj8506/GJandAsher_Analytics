import 'package:flutter/material.dart';
import '../../models/parcel.dart';
import '../../models/product.dart';
import '../../theme/app_theme.dart';
import 'customer_parcels_screen.dart';
import 'customer_store_screen.dart';
import 'customer_chat_screen.dart';

class CustomerPortalScreen extends StatefulWidget {
  final List<Parcel> parcels;
  final List<Product> products;
  final List<ChatMessage> chatMessages;
  final Function(String, String?) onSendMessage;
  final Function(Parcel) onSelectParcel;
  final VoidCallback onSignOut;

  const CustomerPortalScreen({
    Key? key,
    required this.parcels,
    required this.products,
    required this.chatMessages,
    required this.onSendMessage,
    required this.onSelectParcel,
    required this.onSignOut,
  }) : super(key: key);

  @override
  State<CustomerPortalScreen> createState() => _CustomerPortalScreenState();
}

class _CustomerPortalScreenState extends State<CustomerPortalScreen> {
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
    final screens = [
      CustomerParcelsScreen(
        parcels: widget.parcels,
        customerName: 'Maria Santos',
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
      ),
      _buildCustomerAccountScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: const [
            Icon(Icons.person_pin, size: 20, color: AppColors.shipTealAccent),
            SizedBox(width: 8),
            Text('Customer Portal', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
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

  Widget _buildCustomerAccountScreen() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      children: [
        Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.shipTealAccent,
                  child: const Text('MS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Maria Santos', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text('maria.santos@gmail.com', style: TextStyle(color: Colors.grey, fontSize: 12)),
                    SizedBox(height: 4),
                    Text('Verified Buyer Account', style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Republic Act No. 10173 Active', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                SizedBox(height: 4),
                Text('Your address and contact numbers are masked in outbound manifests for your privacy.', style: TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 12)),
          onPressed: widget.onSwitchToWarehouse,
          icon: const Icon(Icons.swap_horiz),
          label: const Text('Switch to Warehouse Hub (Staff/Admin)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 8),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade50, foregroundColor: Colors.red.shade700, padding: const EdgeInsets.symmetric(vertical: 12)),
          onPressed: widget.onSignOut,
          icon: const Icon(Icons.logout),
          label: const Text('Sign Out of Customer Account', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}
