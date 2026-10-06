import 'package:flutter/material.dart';
import '../models/parcel.dart';
import '../theme/app_theme.dart';

class ParcelsScreen extends StatefulWidget {
  final List<Parcel> parcels;
  final Function(Parcel) onSelectParcel;
  final String userRole;

  const ParcelsScreen({
    Key? key,
    required this.parcels,
    required this.onSelectParcel,
    required this.userRole,
  }) : super(key: key);

  @override
  State<ParcelsScreen> createState() => _ParcelsScreenState();
}

class _ParcelsScreenState extends State<ParcelsScreen> {
  String searchQuery = '';
  String selectedPlatform = 'All'; // All, Shopee, Lazada, TikTok Shop
  String selectedStatus = 'All'; // All, Dispatched, In Transit, Delivered, Return Logged
  String selectedCourier = 'All'; // All, SPX Express, J&T Express, etc.
  String selectedDateFilter = 'all'; // all, today, last_week, last_month, custom
  DateTime? customStartDate = DateTime(2026, 10, 1);
  DateTime? customEndDate = DateTime(2026, 10, 5);
  bool isFilterExpanded = true;

  bool isDateInRange(String dateISO) {
    if (selectedDateFilter == 'all') return true;
    final parcelDate = DateTime.tryParse(dateISO);
    if (parcelDate == null) return true;

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final tomorrowStart = todayStart.add(const Duration(days: 1));

    if (selectedDateFilter == 'today') {
      return parcelDate.isAfter(todayStart.subtract(const Duration(milliseconds: 1))) &&
          parcelDate.isBefore(tomorrowStart);
    }
    if (selectedDateFilter == 'last_week') {
      final sevenDaysAgo = todayStart.subtract(const Duration(days: 7));
      return parcelDate.isAfter(sevenDaysAgo) && parcelDate.isBefore(tomorrowStart);
    }
    if (selectedDateFilter == 'last_month') {
      final thirtyDaysAgo = todayStart.subtract(const Duration(days: 30));
      return parcelDate.isAfter(thirtyDaysAgo) && parcelDate.isBefore(tomorrowStart);
    }
    if (selectedDateFilter == 'custom') {
      if (customStartDate == null && customEndDate == null) return true;
      bool matchesStart = true;
      bool matchesEnd = true;
      if (customStartDate != null) {
        matchesStart = parcelDate.isAfter(customStartDate!.subtract(const Duration(seconds: 1)));
      }
      if (customEndDate != null) {
        final endOfDay = DateTime(customEndDate!.year, customEndDate!.month, customEndDate!.day, 23, 59, 59);
        matchesEnd = parcelDate.isBefore(endOfDay.add(const Duration(seconds: 1)));
      }
      return matchesStart && matchesEnd;
    }
    return true;
  }

  void resetAllFilters() {
    setState(() {
      selectedPlatform = 'All';
      selectedStatus = 'All';
      selectedCourier = 'All';
      selectedDateFilter = 'all';
      searchQuery = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredParcels = widget.parcels.where((p) {
      final matchesSearch = p.trackingNumber.toLowerCase().contains(searchQuery.toLowerCase()) ||
          p.customer.toLowerCase().contains(searchQuery.toLowerCase()) ||
          p.courier.toLowerCase().contains(searchQuery.toLowerCase());
      final matchesPlatform = selectedPlatform == 'All' || p.platform == selectedPlatform;
      final matchesStatus = selectedStatus == 'All' || p.status == selectedStatus;
      final matchesCourier = selectedCourier == 'All' || p.courier == selectedCourier;
      final matchesDate = isDateInRange(p.dateISO);
      return matchesSearch && matchesPlatform && matchesStatus && matchesCourier && matchesDate;
    }).toList();

    final shopeeCount = widget.parcels.where((p) => p.platform == 'Shopee').length;
    final lazadaCount = widget.parcels.where((p) => p.platform == 'Lazada').length;
    final tikTokCount = widget.parcels.where((p) => p.platform == 'TikTok Shop').length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
      children: [
        // Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'GJandAsher ShipTracker',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.shipNavyPrimary,
                  ),
                ),
                Text(
                  'Outbound Logistics & Returns Hub',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.shipTealContainer,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.lightBlue.shade200),
              ),
              child: Text(
                widget.userRole,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.shipNavyPrimary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Platform Summary Chips
        Row(
          children: [
            Expanded(
              child: _buildPlatformChip(
                'Shopee',
                '$shopeeCount pkgs',
                AppColors.shopeeOrange,
                AppColors.shopeeOrangeContainer,
                selectedPlatform == 'Shopee',
                () => setState(() => selectedPlatform = selectedPlatform == 'Shopee' ? 'All' : 'Shopee'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildPlatformChip(
                'Lazada',
                '$lazadaCount pkgs',
                AppColors.lazadaBlue,
                AppColors.lazadaBlueContainer,
                selectedPlatform == 'Lazada',
                () => setState(() => selectedPlatform = selectedPlatform == 'Lazada' ? 'All' : 'Lazada'),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildPlatformChip(
                'TikTok',
                '$tikTokCount pkgs',
                AppColors.tikTokBlack,
                AppColors.tikTokContainer,
                selectedPlatform == 'TikTok Shop',
                () => setState(() => selectedPlatform = selectedPlatform == 'TikTok Shop' ? 'All' : 'TikTok Shop'),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Search Input
        TextField(
          onChanged: (val) => setState(() => searchQuery = val),
          decoration: InputDecoration(
            hintText: 'Search tracking #, customer, courier...',
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
        const SizedBox(height: 12),

        // Filter Frame
        Card(
          elevation: 0.5,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: Colors.grey.shade200),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.filter_list, size: 16, color: AppColors.shipTealAccent),
                        SizedBox(width: 6),
                        Text(
                          'Filter Outbound Logs',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: resetAllFilters,
                          child: const Text('Reset', style: TextStyle(color: Colors.red, fontSize: 11)),
                        ),
                        IconButton(
                          icon: Icon(isFilterExpanded ? Icons.expand_less : Icons.expand_more, size: 20),
                          onPressed: () => setState(() => isFilterExpanded = !isFilterExpanded),
                        ),
                      ],
                    ),
                  ],
                ),
                if (isFilterExpanded) ...[
                  const Divider(height: 1),
                  const SizedBox(height: 8),

                  // 1. Status Filter
                  _buildFilterRow(
                    title: 'STATUS',
                    options: ['All', 'Dispatched', 'In Transit', 'Delivered', 'Return Logged'],
                    selected: selectedStatus,
                    onSelect: (val) => setState(() => selectedStatus = val),
                  ),
                  const SizedBox(height: 8),

                  // 2. Platform Filter
                  _buildFilterRow(
                    title: 'PLATFORM',
                    options: ['All', 'Shopee', 'Lazada', 'TikTok Shop'],
                    selected: selectedPlatform,
                    onSelect: (val) => setState(() => selectedPlatform = val),
                  ),
                  const SizedBox(height: 8),

                  // 3. Courier Filter (SPX, J&T, etc.)
                  _buildFilterRow(
                    title: 'COURIER',
                    options: ['All', 'SPX Express', 'J&T Express', 'Flash Express', 'Lazada Express'],
                    selected: selectedCourier,
                    onSelect: (val) => setState(() => selectedCourier = val),
                  ),
                  const SizedBox(height: 8),

                  // 4. Date Filter
                  _buildFilterRow(
                    title: 'DISPATCH DATE',
                    options: ['All Time', 'Today', 'Last Week', 'Last Month', 'Custom Range'],
                    selected: selectedDateFilter == 'all'
                        ? 'All Time'
                        : selectedDateFilter == 'today'
                            ? 'Today'
                            : selectedDateFilter == 'last_week'
                                ? 'Last Week'
                                : selectedDateFilter == 'last_month'
                                    ? 'Last Month'
                                    : 'Custom Range',
                    onSelect: (val) {
                      setState(() {
                        if (val == 'All Time') selectedDateFilter = 'all';
                        if (val == 'Today') selectedDateFilter = 'today';
                        if (val == 'Last Week') selectedDateFilter = 'last_week';
                        if (val == 'Last Month') selectedDateFilter = 'last_month';
                        if (val == 'Custom Range') selectedDateFilter = 'custom';
                      });
                    },
                  ),

                  // Custom date picker range selector
                  if (selectedDateFilter == 'custom') ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () async {
                                final d = await showDatePicker(
                                  context: context,
                                  initialDate: customStartDate ?? DateTime.now(),
                                  firstDate: DateTime(2025),
                                  lastDate: DateTime(2030),
                                );
                                if (d != null) setState(() => customStartDate = d);
                              },
                              child: Text(
                                customStartDate != null
                                    ? '${customStartDate!.year}-${customStartDate!.month.toString().padLeft(2, '0')}-${customStartDate!.day.toString().padLeft(2, '0')}'
                                    : 'Start Date',
                                style: const TextStyle(fontSize: 11),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 6),
                            child: Text('to', style: TextStyle(fontSize: 11)),
                          ),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () async {
                                final d = await showDatePicker(
                                  context: context,
                                  initialDate: customEndDate ?? DateTime.now(),
                                  firstDate: DateTime(2025),
                                  lastDate: DateTime(2030),
                                );
                                if (d != null) setState(() => customEndDate = d);
                              },
                              child: Text(
                                customEndDate != null
                                    ? '${customEndDate!.year}-${customEndDate!.month.toString().padLeft(2, '0')}-${customEndDate!.day.toString().padLeft(2, '0')}'
                                    : 'End Date',
                                style: const TextStyle(fontSize: 11),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),

        // Results summary
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Dispatches',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.shipNavyPrimary),
            ),
            Text(
              'Showing ${filteredParcels.length} parcels',
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Parcels List
        ...filteredParcels.map((parcel) => _buildParcelCard(parcel)).toList(),
      ],
    );
  }

  Widget _buildPlatformChip(String name, String count, Color color, Color containerColor, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: containerColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: isSelected ? color : Colors.transparent, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: color)),
            const SizedBox(height: 4),
            Text(count, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.shipNavyPrimary)),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterRow({
    required String title,
    required List<String> options,
    required String selected,
    required Function(String) onSelect,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 4),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: options.map((opt) {
              final isChosen = selected == opt;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ChoiceChip(
                  label: Text(opt, style: TextStyle(fontSize: 11, fontWeight: isChosen ? FontWeight.bold : FontWeight.normal)),
                  selected: isChosen,
                  selectedColor: AppColors.shipNavyPrimary,
                  labelStyle: TextStyle(color: isChosen ? Colors.white : Colors.black87),
                  onSelected: (_) => onSelect(opt),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildParcelCard(Parcel parcel) {
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 0.5,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16), side: BorderSide(color: Colors.grey.shade200)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => widget.onSelectParcel(parcel),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(parcel.trackingNumber, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.shipNavyPrimary)),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Color(int.parse(parcel.statusColorHex.replaceFirst('#', '0xFF'))).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      parcel.status,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(int.parse(parcel.statusColorHex.replaceFirst('#', '0xFF'))),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(parcel.customer, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      Text('${parcel.platform} • ${parcel.courier}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    ],
                  ),
                  Text(parcel.amount, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.shipNavyPrimary)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
