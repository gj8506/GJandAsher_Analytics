import 'package:flutter/material.dart';
import '../models/parcel.dart';
import '../theme/app_theme.dart';
import 'dispatch_screen.dart';
import 'returns_screen.dart';

class OperationsScreen extends StatefulWidget {
  final Function(Parcel) onAddParcel;
  final VoidCallback onNavigateToParcels;
  final List<ReturnRecord> returns;
  final Function(ReturnRecord) onAddReturn;

  const OperationsScreen({
    Key? key,
    required this.onAddParcel,
    required this.onNavigateToParcels,
    required this.returns,
    required this.onAddReturn,
  }) : super(key: key);

  @override
  State<OperationsScreen> createState() => _OperationsScreenState();
}

class _OperationsScreenState extends State<OperationsScreen> {
  int _activeProcessIndex = 0; // 0 for Dispatch, 1 for Returns

  @override
  Widget build(BuildContext context) {
    final pendingCount = widget.returns
        .where((r) => r.refundStatus == 'Pending Inspection')
        .length;

    return Column(
      children: [
        // Top Switcher Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(
              bottom: BorderSide(color: Colors.grey.shade200),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: AppColors.shipNavyPrimary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.swap_horiz_rounded, color: Colors.white, size: 16),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Operations Hub',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.shipNavyPrimary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      _activeProcessIndex == 0 ? 'Outbound Dispatch' : 'Inbound RTS Returns',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Segmented Toggle
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                padding: const EdgeInsets.all(3),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _activeProcessIndex = 0),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: _activeProcessIndex == 0 ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: _activeProcessIndex == 0
                                ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.send_rounded,
                                size: 14,
                                color: _activeProcessIndex == 0 ? Colors.blue.shade700 : Colors.grey.shade600,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Dispatch Process',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: _activeProcessIndex == 0 ? FontWeight.bold : FontWeight.w500,
                                  color: _activeProcessIndex == 0 ? Colors.blue.shade900 : Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _activeProcessIndex = 1),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: _activeProcessIndex == 1 ? Colors.white : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: _activeProcessIndex == 1
                                ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)]
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.assignment_return_rounded,
                                size: 14,
                                color: _activeProcessIndex == 1 ? Colors.orange.shade800 : Colors.grey.shade600,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Returns Process',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: _activeProcessIndex == 1 ? FontWeight.bold : FontWeight.w500,
                                  color: _activeProcessIndex == 1 ? Colors.orange.shade900 : Colors.grey.shade600,
                                ),
                              ),
                              if (pendingCount > 0) ...[
                                const SizedBox(width: 4),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade600,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '$pendingCount',
                                    style: const TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // Active Content
        Expanded(
          child: _activeProcessIndex == 0
              ? DispatchScreen(
                  onAddParcel: widget.onAddParcel,
                  onNavigateToParcels: widget.onNavigateToParcels,
                )
              : ReturnsScreen(
                  returns: widget.returns,
                  onAddReturn: widget.onAddReturn,
                ),
        ),
      ],
    );
  }
}
