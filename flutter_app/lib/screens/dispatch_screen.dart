import 'package:flutter/material.dart';
import '../models/parcel.dart';
import '../theme/app_theme.dart';

class DispatchScreen extends StatefulWidget {
  final Function(Parcel) onAddParcel;
  final VoidCallback onNavigateToParcels;

  const DispatchScreen({
    Key? key,
    required this.onAddParcel,
    required this.onNavigateToParcels,
  }) : super(key: key);

  @override
  State<DispatchScreen> createState() => _DispatchScreenState();
}

class _DispatchScreenState extends State<DispatchScreen> {
  String platform = 'Shopee';
  String courier = 'SPX Express';
  final trackingController = TextEditingController();
  final customerController = TextEditingController();
  final amountController = TextEditingController();
  final destinationController = TextEditingController();
  final itemsController = TextEditingController();
  bool isSuccess = false;

  final Map<String, List<String>> couriersMap = {
    'Shopee': ['SPX Express', 'Flash Express', 'J&T Express', 'Ninja Van'],
    'Lazada': ['Lazada Express', 'Flash Express', 'Ninja Van'],
    'TikTok Shop': ['J&T Express', 'Flash Express', 'Ninja Van'],
  };

  void autoGenerateWaybill() {
    final rand = (100000000 + (DateTime.now().millisecondsSinceEpoch % 900000000)).toString();
    if (platform == 'Shopee') {
      trackingController.text = 'SPXPH0$rand';
    } else if (platform == 'Lazada') {
      trackingController.text = 'LEX-PH-${rand.substring(0, 8)}';
    } else {
      trackingController.text = 'JT$rand';
    }
    customerController.text = 'Angela Cortez';
    amountController.text = '1450';
    destinationController.text = 'Quezon City, Metro Manila';
    itemsController.text = '2x Wireless Earbuds + Case';
  }

  void submitDispatch() {
    if (trackingController.text.isEmpty || customerController.text.isEmpty) return;

    final parsedAmount = double.tryParse(amountController.text.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
    final newParcel = Parcel(
      id: 'p-${DateTime.now().millisecondsSinceEpoch}',
      trackingNumber: trackingController.text.trim().toUpperCase(),
      platform: platform,
      courier: courier,
      customer: customerController.text.trim(),
      amount: '₱${parsedAmount.toStringAsFixed(2)}',
      rawAmount: parsedAmount,
      status: 'Dispatched',
      statusColorHex: '#3B82F6',
      dispatchedAt: 'Just now',
      dateISO: DateTime.now().toIso8601String(),
      destination: destinationController.text.isEmpty ? 'Metro Manila' : destinationController.text,
      items: itemsController.text.isEmpty ? 'General Merchandise' : itemsController.text,
    );

    widget.onAddParcel(newParcel);
    setState(() => isSuccess = true);
    Future.delayed(const Duration(milliseconds: 1200), () {
      if (mounted) {
        setState(() => isSuccess = false);
        widget.onNavigateToParcels();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
      children: [
        Center(
          child: Column(
            children: const [
              Icon(Icons.send, size: 40, color: AppColors.shipNavyPrimary),
              SizedBox(height: 8),
              Text(
                'Manual Dispatch Form',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.shipNavyPrimary),
              ),
              SizedBox(height: 4),
              Text(
                'Fast courier entry, platform selector, and customer QR routing.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        if (isSuccess)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Column(
              children: const [
                Icon(Icons.check_circle, color: Colors.green, size: 48),
                SizedBox(height: 8),
                Text('Parcel Successfully Dispatched!', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
          )
        else ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Marketplace Platform', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              TextButton.icon(
                onPressed: autoGenerateWaybill,
                icon: const Icon(Icons.auto_awesome, size: 14),
                label: const Text('Auto-Fill Demo', style: TextStyle(fontSize: 11)),
              ),
            ],
          ),
          Row(
            children: ['Shopee', 'Lazada', 'TikTok Shop'].map((p) {
              final isChosen = platform == p;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: SizedBox(
                    height: 38,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isChosen ? AppColors.shipNavyPrimary : Colors.white,
                        foregroundColor: isChosen ? Colors.white : Colors.black87,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: isChosen ? AppColors.shipNavyPrimary : Colors.grey.shade300),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          platform = p;
                          courier = couriersMap[p]!.first;
                        });
                      },
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(p, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: courier,
            decoration: const InputDecoration(labelText: 'Courier Partner', border: OutlineInputBorder()),
            items: couriersMap[platform]!
                .map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 13))))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => courier = val);
            },
          ),
          const SizedBox(height: 12),
          TextField(
            controller: trackingController,
            decoration: const InputDecoration(labelText: 'Tracking / AWB #', border: OutlineInputBorder(), prefixIcon: Icon(Icons.qr_code)),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: customerController,
            decoration: const InputDecoration(labelText: 'Customer Recipient Name', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: amountController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Amount (PHP)', prefixText: '₱ ', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: destinationController,
            decoration: const InputDecoration(labelText: 'Destination City', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.shipNavyPrimary,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: submitDispatch,
            child: const Text('Confirm & Dispatch Parcel', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ],
    );
  }
}
