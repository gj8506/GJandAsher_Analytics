import 'package:flutter/material.dart';
import 'models/parcel.dart';
import 'screens/parcels_screen.dart';
import 'screens/dispatch_screen.dart';
import 'screens/returns_screen.dart';
import 'screens/analytics_screen.dart';
import 'screens/profile_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const ShipTrackerFlutterApp());
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
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({Key? key}) : super(key: key);

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;
  String _userRole = 'Staff Mode';

  final List<Parcel> _parcels = [
    Parcel(
      id: 'p-1',
      trackingNumber: 'SPXPH0394829104',
      platform: 'Shopee',
      courier: 'SPX Express',
      customer: 'Maria Santos',
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
      customer: 'Juan Dela Cruz',
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
      customer: 'Elena Garcia',
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
    Parcel(
      id: 'p-4',
      trackingNumber: 'LBC88301928',
      platform: 'Shopee',
      courier: 'Flash Express',
      customer: 'Roberto Tan',
      phone: '+63 918 *** 6712',
      destination: 'Pasig City, Metro Manila',
      amount: '₱2,100.00',
      rawAmount: 2100,
      status: 'Return Logged',
      statusColorHex: '#EF4444',
      dispatchedAt: '3 days ago, 02:40 PM',
      dateISO: '2026-10-02T14:40:00',
      items: '1x Ergonomic Desk Lamp',
    ),
    Parcel(
      id: 'p-5',
      trackingNumber: 'SPXPH994820194',
      platform: 'Shopee',
      courier: 'SPX Express',
      customer: 'Chloe Mendoza',
      phone: '+63 922 *** 8810',
      destination: 'Taguig City, BGC',
      amount: '₱1,780.00',
      rawAmount: 1780,
      status: 'Dispatched',
      statusColorHex: '#3B82F6',
      dispatchedAt: 'Today, 11:05 AM',
      dateISO: '2026-10-05T11:05:00',
      items: '1x Portable Bluetooth Speaker',
    ),
  ];

  final List<ReturnRecord> _returns = [
    ReturnRecord(
      id: 'ret-1',
      trackingNumber: 'LBC88301928',
      platform: 'Shopee',
      courier: 'Flash Express',
      customer: 'Roberto Tan',
      reason: 'RTS: Delivery Failed / Customer Unreachable',
      condition: 'Intact (Resellable)',
      refundStatus: 'Pending Inspection',
      loggedAt: 'Oct 04, 2026 • 03:15 PM',
      refundAmount: '₱2,100.00',
      notes: 'Rider attempted 3x deliveries. Tamper seal intact.',
    ),
  ];

  void _showParcelDetailModal(Parcel parcel) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(parcel.trackingNumber, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
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

  @override
  Widget build(BuildContext context) {
    final screens = [
      ParcelsScreen(
        parcels: _parcels,
        onSelectParcel: _showParcelDetailModal,
        userRole: _userRole,
      ),
      DispatchScreen(
        onAddParcel: (p) => setState(() => _parcels.insert(0, p)),
        onNavigateToParcels: () => setState(() => _selectedIndex = 0),
      ),
      ReturnsScreen(
        returns: _returns,
        onAddReturn: (r) => setState(() => _returns.insert(0, r)),
      ),
      const AnalyticsScreen(),
      ProfileScreen(
        userRole: _userRole,
        onRoleChanged: (role) => setState(() => _userRole = role),
      ),
    ];

    return Scaffold(
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
            icon: Icon(Icons.send_outlined),
            selectedIcon: Icon(Icons.send, color: Colors.white),
            label: 'Dispatch',
          ),
          NavigationDestination(
            icon: Icon(Icons.assignment_return_outlined),
            selectedIcon: Icon(Icons.assignment_return, color: Colors.white),
            label: 'Returns',
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
