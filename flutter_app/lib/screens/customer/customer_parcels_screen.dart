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
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'My Ordered Parcels',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.shipNavyPrimary,
                  ),
                ),
                Text(
                  'Live tracking across Shopee, Lazada & TikTok',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
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
            prefixIcon: const Icon(Icons.search, size: 20, color: Colors.grey),
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
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
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isChosen ? AppColors.shipNavyPrimary : Colors.white,
                    foregroundColor: isChosen ? Colors.white : Colors.black87,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: isChosen ? AppColors.shipNavyPrimary : Colors.grey.shade300),
                    ),
                  ),
                  onPressed: () => setState(() => statusFilter = tab),
                  child: Text(tab, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 14),

        // Parcels List
        if (filtered.isEmpty)
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Column(
              children: const [
                Icon(Icons.inventory_2_outlined, size: 40, color: Colors.grey),
                SizedBox(height: 8),
                Text('No ordered parcels found', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                SizedBox(height: 4),
                Text('Your shipments will appear here once processed by warehouse staff.', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.grey)),
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
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => widget.onSelectParcel(parcel),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: platformColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          parcel.platform,
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: platformColor),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        parcel.trackingNumber,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.shipNavyPrimary),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Color(int.parse(parcel.statusColorHex.replaceFirst('#', '0xFF'))).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      parcel.status,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(int.parse(parcel.statusColorHex.replaceFirst('#', '0xFF'))),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                parcel.items ?? 'E-Commerce Package',
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
              ),
              const SizedBox(height: 10),
              // Step timeline
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text('Dispatched', style: TextStyle(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.bold)),
                        Text('In Transit', style: TextStyle(fontSize: 10, color: Colors.blue, fontWeight: FontWeight.bold)),
                        Text('Delivered', style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 6),
                    LinearProgressIndicator(
                      value: parcel.status == 'Delivered' ? 1.0 : parcel.status == 'In Transit' ? 0.65 : 0.35,
                      backgroundColor: Colors.grey.shade200,
                      color: parcel.status == 'Delivered' ? Colors.green : AppColors.shipTealAccent,
                      minHeight: 5,
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${parcel.courier}', style: const TextStyle(fontSize: 10, color: Colors.black54)),
                        Text('${parcel.dispatchedAt}', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(parcel.amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.shipNavyPrimary)),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.shipTealContainer,
                      foregroundColor: AppColors.shipNavyPrimary,
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () => widget.onInquireInChat(parcel),
                    icon: const Icon(Icons.chat_bubble_outline, size: 14),
                    label: const Text('Ask Support', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
