import 'package:flutter/material.dart';
import '../../models/parcel.dart';
import '../../theme/app_theme.dart';

class CustomerParcelsScreen extends StatefulWidget {
  final List<Parcel> parcels;
  final String customerName;
  final Function(Parcel) onSelectParcel;
  final Function(Parcel) onInquireInChat;

  const CustomerParcelsScreen({
    Key? key,
    required this.parcels,
    required this.customerName,
    required this.onSelectParcel,
    required this.onInquireInChat,
  }) : super(key: key);

  @override
  State<CustomerParcelsScreen> createState() => _CustomerParcelsScreenState();
}

class _CustomerParcelsScreenState extends State<CustomerParcelsScreen> {
  String searchQuery = '';
  String statusFilter = 'All'; // All, Active, Delivered
  final TextEditingController _trackingInput = TextEditingController();

  @override
  void dispose() {
    _trackingInput.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = widget.parcels.where((p) {
      final matchesSearch = p.trackingNumber.toLowerCase().contains(searchQuery.toLowerCase()) ||
          (p.items?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false) ||
          p.courier.toLowerCase().contains(searchQuery.toLowerCase());

      final matchesStatus = statusFilter == 'All'
          ? true
          : statusFilter == 'Active'
              ? (p.status == 'Dispatched' || p.status == 'In Transit')
              : (p.status == 'Delivered' || p.status == 'Return Logged');

      return matchesSearch && matchesStatus;
    }).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'My Ordered Parcels',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: AppColors.shipNavyPrimary,
                    ),
                  ),
                  Text(
                    'Live tracking across Shopee, Lazada & TikTok',
                    style: TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.shipTealContainer,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.lightBlue.shade200),
              ),
              child: Text(
                widget.customerName,
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.shipNavyPrimary),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Search Field
        TextField(
          onChanged: (val) => setState(() => searchQuery = val),
          decoration: InputDecoration(
            hintText: 'Search by tracking #, item, courier...',
            hintStyle: TextStyle(fontSize: 11, color: Colors.grey.shade400),
            prefixIcon: const Icon(Icons.search, size: 18, color: Colors.grey),
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 14),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Filter chips (All, Active, Delivered)
        Row(
          children: ['All', 'Active', 'Delivered'].map((tab) {
            final isChosen = statusFilter == tab;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: SizedBox(
                  height: 34,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isChosen ? AppColors.shipNavyPrimary : Colors.white,
                      foregroundColor: isChosen ? Colors.white : Colors.black87,
                      elevation: 0,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: isChosen ? AppColors.shipNavyPrimary : Colors.grey.shade300),
                      ),
                    ),
                    onPressed: () => setState(() => statusFilter = tab),
                    child: Text(tab, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 14),

        // Parcels List: Clean empty state if empty
        if (filtered.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 36),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.inventory_2_outlined, size: 30, color: AppColors.shipTealAccent),
                ),
                const SizedBox(height: 12),
                const Text(
                  'No Ordered Parcels Yet',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.shipNavyPrimary),
                ),
                const SizedBox(height: 6),
                const Text(
                  'You currently have no active or historical parcels logged under your account. When warehouse staff dispatches an order for you, it will appear here in real time.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: Colors.grey, height: 1.4),
                ),
              ],
            ),
          )
        else
          ...filtered.map((parcel) => _buildCustomerParcelCard(parcel)).toList(),
      ],
    );
  }

  Widget _buildCustomerParcelCard(Parcel parcel) {
    Color platformColor = parcel.platform == 'Shopee'
        ? AppColors.shopeeOrange
        : parcel.platform == 'Lazada'
            ? AppColors.lazadaBlue
            : AppColors.tikTokBlack;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      elevation: 0.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: platformColor.withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                  child: Text(parcel.platform, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: platformColor)),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: Color(int.parse(parcel.statusColorHex.replaceAll('#', '0xFF'))).withOpacity(0.12), borderRadius: BorderRadius.circular(8)),
                  child: Text(
                    parcel.status,
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(int.parse(parcel.statusColorHex.replaceAll('#', '0xFF')))),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(parcel.trackingNumber, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.shipNavyPrimary)),
            if (parcel.items != null) ...[
              const SizedBox(height: 3),
              Text(parcel.items!, style: const TextStyle(fontSize: 11, color: Colors.black87), maxLines: 1, overflow: TextOverflow.ellipsis),
            ],
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(parcel.amount, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.shipNavyPrimary)),
                Row(
                  children: [
                    TextButton.icon(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () => widget.onInquireInChat(parcel),
                      icon: const Icon(Icons.chat_bubble_outline, size: 12, color: Colors.green),
                      label: const Text('Ask Admin', style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 6),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.shipNavyPrimary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      onPressed: () => widget.onSelectParcel(parcel),
                      child: const Text('View', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
