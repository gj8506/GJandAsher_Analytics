import 'package:flutter/material.dart';
import '../models/parcel.dart';
import '../theme/app_theme.dart';

class ReturnsScreen extends StatelessWidget {
  final List<ReturnRecord> returns;
  final Function(ReturnRecord) onAddReturn;

  const ReturnsScreen({
    Key? key,
    required this.returns,
    required this.onAddReturn,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
      children: [
        Center(
          child: Column(
            children: const [
              Icon(Icons.assignment_return, size: 40, color: AppColors.statusReturned),
              SizedBox(height: 8),
              Text(
                'Returns & Refunds Logger',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.shipNavyPrimary),
              ),
              SizedBox(height: 4),
              Text(
                'Log returned parcels with condition assessment and refund tracking.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Logged Returns (${returns.length})',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.statusReturned,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                _showAddReturnDialog(context);
              },
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Log Return', style: TextStyle(fontSize: 12)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...returns.map((item) {
          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            color: Colors.white,
            elevation: 0.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
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
                      Text(item.trackingNumber, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          item.refundStatus,
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.red.shade700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text('${item.customer} • ${item.platform} (${item.courier})', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  Text('Reason: ${item.reason}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(item.condition, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                      ),
                      Text(item.loggedAt, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  void _showAddReturnDialog(BuildContext context) {
    final tracking = TextEditingController();
    final customer = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Log Returned Parcel', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: tracking, decoration: const InputDecoration(labelText: 'Tracking #')),
            TextField(controller: customer, decoration: const InputDecoration(labelText: 'Customer Name')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              if (tracking.text.isNotEmpty) {
                onAddReturn(
                  ReturnRecord(
                    id: 'ret-${DateTime.now().millisecondsSinceEpoch}',
                    trackingNumber: tracking.text.trim().toUpperCase(),
                    platform: 'Shopee',
                    courier: 'Flash Express',
                    customer: customer.text.isEmpty ? 'Customer' : customer.text,
                    reason: 'RTS: Delivery Failed',
                    condition: 'Intact (Resellable)',
                    refundStatus: 'Pending Inspection',
                    loggedAt: 'Just now',
                    refundAmount: '₱1,500.00',
                  ),
                );
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
