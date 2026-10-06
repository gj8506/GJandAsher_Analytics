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
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
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
                'Log returned parcels with condition assessment, photo evidence, and refund resolution tracking.',
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                _showAddReturnBottomSheet(context);
              },
              icon: const Icon(Icons.add, size: 16),
              label: const Text('Log Return', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...returns.map((item) {
          Color conditionColor = Colors.green.shade700;
          Color conditionBg = Colors.green.shade50;
          if (item.condition.contains('Damaged Packaging')) {
            conditionColor = Colors.amber.shade800;
            conditionBg = Colors.amber.shade50;
          } else if (item.condition.contains('Item Damaged') || item.condition.contains('Total Loss')) {
            conditionColor = Colors.red.shade700;
            conditionBg = Colors.red.shade50;
          }

          return Card(
            margin: const EdgeInsets.only(bottom: 10),
            color: Colors.white,
            elevation: 0.5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(item.trackingNumber, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.shipNavyPrimary)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red.shade100),
                        ),
                        child: Text(
                          item.refundStatus,
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.red.shade700),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('${item.customer} • ${item.platform} (${item.courier})', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text('Reason: ${item.reason}', style: const TextStyle(fontSize: 11, color: Colors.black87)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: conditionBg,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: conditionColor.withOpacity(0.3)),
                        ),
                        child: Text(
                          item.condition,
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: conditionColor),
                        ),
                      ),
                      Text(item.loggedAt, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                  if (item.notes != null && item.notes!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '"${item.notes}"',
                        style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Colors.black87),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        }).toList(),
      ],
    );
  }

  void _showAddReturnBottomSheet(BuildContext context) {
    String tracking = '';
    String platform = 'Shopee';
    String courier = 'Flash Express';
    String customer = '';
    String reason = 'RTS: Customer Unreachable / Refused';
    String condition = 'Intact (Resellable)';
    String refundStatus = 'Pending Inspection';
    String refundAmount = '₱1,200.00';
    String notes = '';

    final conditions = [
      'Intact (Resellable)',
      'Damaged Packaging',
      'Item Damaged',
      'Total Loss / Liquid',
    ];

    final refundStatuses = [
      'Pending Inspection',
      'Approved for Refund',
      'Disputed with Platform',
      'Refund Completed',
    ];

    final couriers = [
      'Flash Express',
      'SPX Express',
      'Lazada Express',
      'J&T Express',
      'Ninja Van',
    ];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                top: 20,
                left: 20,
                right: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Log Returned Parcel',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.shipNavyPrimary),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 20),
                          onPressed: () => Navigator.pop(ctx),
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 8),

                    // Tracking Number
                    const Text('Airway Bill / Tracking #', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'e.g. LBC88301928',
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) => tracking = val,
                    ),
                    const SizedBox(height: 10),

                    // Platform & Courier
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Platform', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              DropdownButtonFormField<String>(
                                value: platform,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  border: OutlineInputBorder(),
                                ),
                                items: ['Shopee', 'Lazada', 'TikTok Shop']
                                    .map((p) => DropdownMenuItem(value: p, child: Text(p, style: const TextStyle(fontSize: 12))))
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) setState(() => platform = val);
                                },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Courier', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              DropdownButtonFormField<String>(
                                value: courier,
                                decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                                  border: OutlineInputBorder(),
                                ),
                                items: couriers
                                    .map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 12))))
                                    .toList(),
                                onChanged: (val) {
                                  if (val != null) setState(() => courier = val);
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Customer Name
                    const Text('Customer / Buyer Name', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    TextField(
                      decoration: const InputDecoration(
                        hintText: 'e.g. Roberto Tan',
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) => customer = val,
                    ),
                    const SizedBox(height: 10),

                    // Condition Assessment (matching web options)
                    const Text('Return Assessment Condition', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    DropdownButtonFormField<String>(
                      value: condition,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(),
                      ),
                      items: conditions
                        .map((c) => DropdownMenuItem(value: c, child: Text(c, style: const TextStyle(fontSize: 12))))
                        .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => condition = val);
                      },
                    ),
                    const SizedBox(height: 10),

                    // Refund Resolution Status (matching web options)
                    const Text('Refund Resolution Status', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    DropdownButtonFormField<String>(
                      value: refundStatus,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(),
                      ),
                      items: refundStatuses
                        .map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 12))))
                        .toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => refundStatus = val);
                      },
                    ),
                    const SizedBox(height: 10),

                    // Photo Evidence Simulation Box (matching web)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300, style: BorderStyle.solid),
                      ),
                      child: Row(
                        children: const [
                          Icon(Icons.camera_alt_outlined, size: 20, color: Colors.grey),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Tamper seal & barcode captured',
                              style: TextStyle(fontSize: 11, color: Colors.black87),
                            ),
                          ),
                          Text(
                            'Attached ✓',
                            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.green),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Inspection Notes
                    const Text('Inspection Notes', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    TextField(
                      maxLines: 2,
                      decoration: const InputDecoration(
                        hintText: 'Notes regarding parcel condition...',
                        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (val) => notes = val,
                    ),
                    const SizedBox(height: 16),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.statusReturned,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          if (tracking.trim().isNotEmpty) {
                            onAddReturn(
                              ReturnRecord(
                                id: 'ret-${DateTime.now().millisecondsSinceEpoch}',
                                trackingNumber: tracking.trim().toUpperCase(),
                                platform: platform,
                                courier: courier,
                                customer: customer.trim().isEmpty ? 'Customer' : customer.trim(),
                                reason: 'RTS: Delivery Failed / Customer Unreachable',
                                condition: condition,
                                refundStatus: refundStatus,
                                loggedAt: 'Just now',
                                refundAmount: refundAmount,
                                notes: notes.trim().isEmpty ? 'Logged via Mobile Returns Module.' : notes.trim(),
                              ),
                            );
                            Navigator.pop(ctx);
                          }
                        },
                        child: const Text('Save Return Record', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
