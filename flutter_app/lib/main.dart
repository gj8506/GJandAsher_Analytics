import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/parcel.dart';
import 'models/product.dart';
import 'providers/auth_provider.dart';
import 'screens/login_screen.dart';
import 'screens/parcels_screen.dart';
import 'screens/dispatch_screen.dart';
import 'screens/returns_screen.dart';
import 'screens/operations_screen.dart';
import 'screens/admin_chat_screen.dart';
import 'screens/analytics_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/customer/customer_portal_screen.dart';
import 'theme/app_theme.dart';

// Portal provider ('customer' or 'warehouse')
final portalProvider = StateProvider<String>((ref) => 'customer');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Firebase initialized in simulation mode: $e');
  }

  runApp(
    const ProviderScope(
      child: ShipTrackerFlutterApp(),
    ),
  );
}

class ShipTrackerFlutterApp extends StatelessWidget {
  const ShipTrackerFlutterApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GJandAsher ShipTracker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.shipSurfaceLight,
        primaryColor: AppColors.shipNavyPrimary,
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.shipNavyPrimary),
        useMaterial3: true,
      ),
      home: const AuthGateRouter(),
    );
  }
}

class AuthGateRouter extends ConsumerWidget {
  const AuthGateRouter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final mockRole = ref.watch(mockRoleProvider);
    final userProfile = ref.watch(currentUserProfileProvider);

    // If no authenticated user or profile, DIRECTLY open LoginScreen
    if (userProfile == null && (mockRole == null || mockRole == 'guest') && authState.value == null) {
      return const LoginScreen();
    }

    return const MainPortalRouter();
  }
}

class MainPortalRouter extends ConsumerStatefulWidget {
  const MainPortalRouter({Key? key}) : super(key: key);

  @override
  ConsumerState<MainPortalRouter> createState() => _MainPortalRouterState();
}

class _MainPortalRouterState extends ConsumerState<MainPortalRouter> {
  int _selectedIndex = 0;

  // Warehouse Hub Parcels (Admin/Staff)
  final List<Parcel> _warehouseParcels = [
    Parcel(
      id: 'p-1',
      trackingNumber: 'SPXPH0394829104',
      platform: 'Shopee',
      courier: 'SPX Express',
      customer: 'Customer Order #1',
      phone: '+63 917 *** 4821',
      destination: 'Quezon City, Metro Manila',
      amount: '₱1,250.00',
      rawAmount: 1250,
      status: 'Dispatched',
      statusColorHex: '#3B82F6',
      dispatchedAt: 'Today, 09:30 AM',
      dateISO: '2026-10-05T09:30:00',
      items: '2x Wireless Earbuds, 1x Silicone Case',
    ),
    Parcel(
      id: 'p-2',
      trackingNumber: 'LEX-PH-82049102',
      platform: 'Lazada',
      courier: 'Lazada Express',
      customer: 'Customer Order #2',
      phone: '+63 928 *** 9934',
      destination: 'Cebu City, Central Visayas',
      amount: '₱3,420.00',
      rawAmount: 3420,
      status: 'In Transit',
      statusColorHex: '#8B5CF6',
      dispatchedAt: 'Yesterday, 04:15 PM',
      dateISO: '2026-10-04T16:15:00',
      items: '1x Mechanical Keyboard (RGB Brown Switch)',
    ),
    Parcel(
      id: 'p-3',
      trackingNumber: 'JT6301948201',
      platform: 'TikTok Shop',
      courier: 'J&T Express',
      customer: 'Customer Order #3',
      phone: '+63 905 *** 1276',
      destination: 'Davao City, Davao del Sur',
      amount: '₱890.00',
      rawAmount: 890,
      status: 'Delivered',
      statusColorHex: '#10B981',
      dispatchedAt: '2 days ago, 11:20 AM',
      dateISO: '2026-10-03T11:20:00',
      items: '3x Premium Cotton Oversized Tees',
    ),
  ];

  // Customer Orders List: Starts EMPTY without any items like a preview as requested
  final List<Parcel> _customerParcels = [];

  // Customer Chat History: Starts EMPTY without any items like a preview as requested
  final List<ChatMessage> _customerChatMessages = [];

  final List<ReturnRecord> _returns = [
    ReturnRecord(
      id: 'ret-1',
      trackingNumber: 'LBC88301928',
      platform: 'Shopee',
      courier: 'Flash Express',
      customer: 'Returns Dept',
      reason: 'RTS: Delivery Failed / Customer Unreachable',
      condition: 'Intact (Resellable)',
      refundStatus: 'Pending Inspection',
      loggedAt: 'Oct 04, 2026 • 03:15 PM',
      refundAmount: '₱2,100.00',
      notes: 'Rider attempted 3x deliveries. Tamper seal intact.',
    ),
  ];

  final List<Product> _products = [
    Product(
      id: 'prod-1',
      name: 'Pro Wireless ANC Earbuds (BT 5.4)',
      category: 'Electronics',
      price: '₱1,250.00',
      rawPrice: 1250,
      stock: 48,
      description: 'Active Noise Cancelling earbuds with deep bass and 36hr battery.',
      platforms: ['Shopee', 'Lazada', 'TikTok Shop'],
      image: 'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?w=500&auto=format&fit=crop&q=60',
      rating: 4.9,
      reviewsCount: 312,
    ),
    Product(
      id: 'prod-2',
      name: 'RGB Hot-Swappable Mechanical Keyboard',
      category: 'Electronics',
      price: '₱3,420.00',
      rawPrice: 3420,
      stock: 19,
      description: '75% Layout wireless tri-mode mechanical keyboard with pre-lubed switches.',
      platforms: ['Lazada', 'Shopee'],
      image: 'https://images.unsplash.com/photo-1595225476474-87563907a212?w=500&auto=format&fit=crop&q=60',
      rating: 4.8,
      reviewsCount: 184,
    ),
    Product(
      id: 'prod-3',
      name: 'Heavy Duty Gas Spring Monitor Mount',
      category: 'Accessories',
      price: '₱4,650.00',
      rawPrice: 4650,
      stock: 14,
      description: 'Single monitor arm with integrated cable management.',
      platforms: ['Lazada'],
      image: 'https://images.unsplash.com/photo-1527864550417-7fd91fc51a46?w=500&auto=format&fit=crop&q=60',
      rating: 4.9,
      reviewsCount: 96,
    ),
    Product(
      id: 'prod-4',
      name: 'Ergonomic LED Desk Lamp Qi Charger',
      category: 'Home & Living',
      price: '₱2,100.00',
      rawPrice: 2100,
      stock: 32,
      description: 'Multi-angle dimmable eye-caring task light with 5 color temperatures.',
      platforms: ['Shopee', 'TikTok Shop'],
      image: 'https://images.unsplash.com/photo-1534349762230-e0cadf78f5da?w=500&auto=format&fit=crop&q=60',
      rating: 4.7,
      reviewsCount: 142,
    ),
  ];

  bool _isAdminTyping = false;

  void _handleCustomerSendMessage(String text, String? trackingNumber, [String? chatType]) {
    final userProfile = ref.read(currentUserProfileProvider);
    final senderName = userProfile?.displayName ?? 'New Customer';
    final determinedType = chatType ?? 'order';

    setState(() {
      _customerChatMessages.add(
        ChatMessage(
          id: 'msg-${DateTime.now().millisecondsSinceEpoch}',
          sender: 'customer',
          senderName: senderName,
          text: text,
          timestamp: 'Just now',
          trackingNumber: trackingNumber,
          chatType: determinedType,
        ),
      );
      _isAdminTyping = true;
    });

    // Auto-reply simulation from Admin gj8506 with realistic typing indicator
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        String replyText = 'Thanks for messaging GJ & Asher Hub! Our fulfillment team is reviewing your inquiry.';
        final lower = text.toLowerCase();

        if (determinedType == 'return' || lower.contains('return') || lower.contains('damage') || lower.contains('refund')) {
          replyText = 'Return inquiry logged. Keep package seal intact. We will inspect the RTS parcel upon warehouse arrival.';
        } else if (determinedType == 'order' || lower.contains('where') || lower.contains('dispatched') || lower.contains('tracking')) {
          replyText = 'Hi! We checked your order status. The courier has scanned the waybill and it is currently in transit to your city hub on schedule!';
        } else if (determinedType == 'product' || lower.contains('stock') || lower.contains('available') || lower.contains('keyboard')) {
          replyText = 'Great news! That item is in stock at our warehouse (MNL-HUB-04) with same-day dispatch available.';
        } else if (lower.contains('address') || lower.contains('change')) {
          replyText = 'We can update destination routing as long as the parcel has not yet been loaded into the courier last-mile van.';
        } else {
          replyText = 'Hello! Warehouse Admin gj8506 here. We received your inquiry and our logistics desk will assist you shortly.';
        }

        setState(() {
          _isAdminTyping = false;
          _customerChatMessages.add(
            ChatMessage(
              id: 'msg-admin-${DateTime.now().millisecondsSinceEpoch}',
              sender: 'admin',
              senderName: 'Admin (gj8506)',
              text: replyText,
              timestamp: 'Just now',
              chatType: determinedType,
            ),
          );
        });
      }
    });
  }

  void _handleAdminSendMessage(String text, String? trackingNumber) {
    setState(() {
      _customerChatMessages.add(
        ChatMessage(
          id: 'msg-admin-${DateTime.now().millisecondsSinceEpoch}',
          sender: 'admin',
          senderName: 'Admin (gj8506)',
          text: text,
          timestamp: 'Just now',
          trackingNumber: trackingNumber,
          chatType: 'general',
        ),
      );
    });
  }

  void _showParcelDetailModal(Parcel parcel) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      parcel.trackingNumber,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close)),
                ],
              ),
              const SizedBox(height: 8),
              Text('${parcel.platform} • ${parcel.courier}', style: const TextStyle(fontWeight: FontWeight.w600)),
              Text('Customer: ${parcel.customer}', style: const TextStyle(fontSize: 13)),
              Text('Amount: ${parcel.amount}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 8),
              if (parcel.items != null) Text('Contents: ${parcel.items}', style: const TextStyle(color: Colors.grey)),
            ],
          ),
        );
      },
    );
  }

  void _handleSignOut() {
    ref.read(mockRoleProvider.notifier).state = null;
    ref.read(currentUserProfileProvider.notifier).state = null;
    ref.read(authServiceProvider).signOut();
  }

  @override
  Widget build(BuildContext context) {
    final activePortal = ref.watch(portalProvider);

    // If Customer Portal is active: pass empty parcels & empty chat messages
    if (activePortal == 'customer') {
      return CustomerPortalScreen(
        parcels: _customerParcels,
        products: _products,
        chatMessages: _customerChatMessages,
        onSendMessage: _handleCustomerSendMessage,
        onSelectParcel: _showParcelDetailModal,
        onSignOut: _handleSignOut,
        isAdminTyping: _isAdminTyping,
      );
    }

    // Warehouse Logistics Hub (Admin gj8506 & Staff)
    final roleAsync = ref.watch(userRoleProvider);
    final mockRole = ref.watch(mockRoleProvider);
    final userProfile = ref.watch(currentUserProfileProvider);
    final activeRole = userProfile?.role ?? roleAsync.value ?? mockRole ?? 'staff';
    final isAdmin = activeRole.toLowerCase() == 'admin';

    final screens = [
      ParcelsScreen(
        parcels: _warehouseParcels,
        onSelectParcel: _showParcelDetailModal,
        userRole: '${activeRole.toUpperCase()} MODE',
      ),
      OperationsScreen(
        onAddParcel: (p) => setState(() => _warehouseParcels.insert(0, p)),
        onNavigateToParcels: () => setState(() => _selectedIndex = 0),
        returns: _returns,
        onAddReturn: (r) => setState(() => _returns.insert(0, r)),
      ),
      AdminChatScreen(
        messages: _customerChatMessages,
        onSendMessage: _handleAdminSendMessage,
        parcels: _warehouseParcels,
        adminName: 'Admin (gj8506)',
      ),
      AnalyticsScreen(
        isAdmin: isAdmin,
      ),
      ProfileScreen(
        userRole: activeRole,
        onRoleChanged: (role) {
          ref.read(mockRoleProvider.notifier).state = role;
        },
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Flexible(
              child: Text(
                'Warehouse Hub',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isAdmin ? Colors.green.withOpacity(0.25) : Colors.lightBlue.withOpacity(0.25),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: isAdmin ? Colors.greenAccent : Colors.lightBlueAccent, width: 0.8),
              ),
              child: Text(
                isAdmin ? 'Admin' : 'Staff',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: isAdmin ? Colors.greenAccent : Colors.lightBlueAccent,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.shipNavyPrimary,
        actions: [
          IconButton(
            onPressed: _handleSignOut,
            icon: const Icon(Icons.logout_rounded, color: Colors.white70, size: 20),
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: SafeArea(child: screens[_selectedIndex]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (idx) => setState(() => _selectedIndex = idx),
        indicatorColor: AppColors.shipNavyPrimary,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.local_shipping_outlined),
            selectedIcon: Icon(Icons.local_shipping, color: Colors.white),
            label: 'Parcels',
          ),
          NavigationDestination(
            icon: Icon(Icons.swap_horiz_rounded),
            selectedIcon: Icon(Icons.swap_horiz, color: Colors.white),
            label: 'Operations',
          ),
          NavigationDestination(
            icon: Icon(Icons.chat_bubble_outline),
            selectedIcon: Icon(Icons.chat_bubble, color: Colors.white),
            label: 'Chat',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart, color: Colors.white),
            label: 'Analytics',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person, color: Colors.white),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
