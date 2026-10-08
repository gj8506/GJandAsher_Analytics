import 'package:flutter/material.dart';
import '../models/parcel.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';

class AdminChatScreen extends StatefulWidget {
  final List<ChatMessage> messages;
  final Function(String, String?) onSendMessage;
  final List<Parcel> parcels;
  final String adminName;

  const AdminChatScreen({
    Key? key,
    required this.messages,
    required this.onSendMessage,
    required this.parcels,
    this.adminName = 'Admin (gj8506)',
  }) : super(key: key);

  @override
  State<AdminChatScreen> createState() => _AdminChatScreenState();
}

class _AdminChatScreenState extends State<AdminChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _selectedTrackingNumber;

  final quickReplies = [
    '📦 Your parcel has been dispatched and is currently in transit with the courier.',
    '✅ We have received your return package and the refund inspection is approved.',
    '🚚 Handed over to courier hub today. Airway bill tracking updates within 12 hours.',
    '⏳ We are checking this order with our warehouse fulfillment staff.',
  ];

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    widget.onSendMessage(text, _selectedTrackingNumber);
    _textController.clear();
    setState(() {
      _selectedTrackingNumber = null;
    });

    Future.delayed(const Duration(milliseconds: 150), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Top Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.shipNavyPrimary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.chat_bubble_outline, color: Colors.lightBlueAccent, size: 18),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Flexible(
                                child: Text(
                                  'Customer Support Hub',
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.shipNavyPrimary),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                                decoration: BoxDecoration(
                                  color: Colors.green.shade50,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: Colors.green.shade300, width: 0.5),
                                ),
                                child: Text(
                                  'Admin Mode',
                                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.green.shade800),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Direct live messages with customers',
                            style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue.shade200, width: 0.5),
                ),
                child: Text(
                  '${widget.messages.length} msgs',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.blue.shade800),
                ),
              ),
            ],
          ),
        ),

        // Info Banner
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          color: Colors.grey.shade100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(Icons.person_pin_outlined, size: 14, color: Colors.grey.shade700),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        'Active Channel: Registered Customers',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w500, color: Colors.grey.shade700),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'RA 10173 DPA Protected',
                style: TextStyle(fontSize: 9, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),

        // Messages List
        Expanded(
          child: widget.messages.isEmpty
              ? Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.forum_outlined, size: 26, color: Colors.blue.shade700),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No customer messages yet',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.shipNavyPrimary),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'When customers message support about their parcels, returns, or product inquiries, they will appear here.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                        ),
                        const SizedBox(height: 14),
                        ElevatedButton.icon(
                          onPressed: () {
                            widget.onSendMessage(
                              'Welcome to GJ & Asher Warehouse Support! We are online and ready to assist you.',
                              null,
                            );
                          },
                          icon: const Icon(Icons.send, size: 14),
                          label: const Text('Send Welcome Message', style: TextStyle(fontSize: 11)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.shipNavyPrimary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                  itemCount: widget.messages.length,
                  itemBuilder: (ctx, index) {
                    final msg = widget.messages[index];
                    final isAdmin = msg.sender.toLowerCase() == 'admin';

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Column(
                        crossAxisAlignment: isAdmin ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  isAdmin ? '${msg.senderName} (You)' : msg.senderName,
                                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '• ${msg.timestamp}',
                                  style: TextStyle(fontSize: 9, color: Colors.grey.shade500),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            decoration: BoxDecoration(
                              color: isAdmin ? AppColors.shipNavyPrimary : Colors.white,
                              borderRadius: BorderRadius.circular(16).copyWith(
                                topRight: isAdmin ? const Radius.circular(2) : const Radius.circular(16),
                                topLeft: !isAdmin ? const Radius.circular(2) : const Radius.circular(16),
                              ),
                              border: isAdmin ? null : Border.all(color: Colors.grey.shade300),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 3,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (msg.chatType != null || (msg.trackingNumber != null && msg.trackingNumber!.isNotEmpty)) ...[
                                  Wrap(
                                    spacing: 4,
                                    runSpacing: 4,
                                    children: [
                                      if (msg.chatType != null)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: isAdmin ? Colors.white12 : Colors.blue.shade50,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            msg.chatType == 'order'
                                                ? '📦 Order Inquiry'
                                                : msg.chatType == 'return'
                                                    ? '🔄 Return / RTS'
                                                    : msg.chatType == 'product'
                                                        ? '🛍️ Product Stock'
                                                        : '💬 General Help',
                                            style: TextStyle(
                                              fontSize: 9,
                                              fontWeight: FontWeight.bold,
                                              color: isAdmin ? Colors.lightBlue.shade200 : Colors.blue.shade900,
                                            ),
                                          ),
                                        ),
                                      if (msg.trackingNumber != null && msg.trackingNumber!.isNotEmpty)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: isAdmin ? Colors.white.withOpacity(0.12) : Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.local_shipping,
                                                size: 11,
                                                color: isAdmin ? Colors.lightBlueAccent : Colors.grey.shade700,
                                              ),
                                              const SizedBox(width: 3),
                                              Text(
                                                '#${msg.trackingNumber}',
                                                style: TextStyle(
                                                  fontSize: 9,
                                                  fontFamily: 'monospace',
                                                  fontWeight: FontWeight.bold,
                                                  color: isAdmin ? Colors.lightBlueAccent : Colors.grey.shade800,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                ],
                                Text(
                                  msg.text,
                                  style: TextStyle(
                                    fontSize: 12,
                                    height: 1.35,
                                    color: isAdmin ? Colors.white : Colors.grey.shade900,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),

        // Quick Responses Bar
        Container(
          height: 38,
          color: Colors.grey.shade100,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            scrollDirection: Axis.horizontal,
            itemCount: quickReplies.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (ctx, idx) {
              return ActionChip(
                label: Text(
                  quickReplies[idx],
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade800),
                ),
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                visualDensity: VisualDensity.compact,
                side: BorderSide(color: Colors.grey.shade300, width: 0.6),
                onPressed: () {
                  _textController.text = quickReplies[idx];
                },
              );
            },
          ),
        ),

        // Waybill attachment selector if parcels available
        if (widget.parcels.isNotEmpty)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            color: Colors.white,
            child: Row(
              children: [
                Icon(Icons.link, size: 14, color: Colors.grey.shade600),
                const SizedBox(width: 6),
                Text('Link Waybill:', style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isDense: true,
                      value: _selectedTrackingNumber,
                      hint: Text('None (General inquiry)', style: TextStyle(fontSize: 11, color: Colors.grey.shade500)),
                      items: [
                        const DropdownMenuItem<String>(
                          value: null,
                          child: Text('None (General inquiry)', style: TextStyle(fontSize: 11)),
                        ),
                        ...widget.parcels.map(
                          (p) => DropdownMenuItem<String>(
                            value: p.trackingNumber,
                            child: Text(
                              '${p.trackingNumber} (${p.platform})',
                              style: const TextStyle(fontSize: 11, fontFamily: 'monospace'),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                      onChanged: (val) {
                        setState(() {
                          _selectedTrackingNumber = val;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

        // Input Field
        Container(
          padding: const EdgeInsets.fromLTRB(12, 6, 12, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey.shade200)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  style: const TextStyle(fontSize: 12),
                  decoration: InputDecoration(
                    hintText: 'Reply to customer as Admin...',
                    hintStyle: TextStyle(fontSize: 12, color: Colors.grey.shade400),
                    filled: true,
                    fillColor: Colors.grey.shade100,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              CircleAvatar(
                radius: 19,
                backgroundColor: AppColors.shipNavyPrimary,
                child: IconButton(
                  icon: const Icon(Icons.send, size: 16, color: Colors.white),
                  onPressed: _sendMessage,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
