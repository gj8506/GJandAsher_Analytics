import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../theme/app_theme.dart';

class CustomerChatScreen extends StatefulWidget {
  final List<ChatMessage> messages;
  final Function(String, String?) onSendMessage;
  final String? initialInquiry;

  const CustomerChatScreen({
    Key? key,
    required this.messages,
    required this.onSendMessage,
    this.initialInquiry,
  }) : super(key: key);

  @override
  State<CustomerChatScreen> createState() => _CustomerChatScreenState();
}

class _CustomerChatScreenState extends State<CustomerChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final quickPrompts = [
    'Where is my dispatched order?',
    'How do I process a damaged return?',
    'Is the mechanical keyboard in stock?',
    'Can I change my delivery address?',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.initialInquiry != null) {
      _textController.text = widget.initialInquiry!;
    }
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    widget.onSendMessage(text, null);
    _textController.clear();

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
        // Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          color: Colors.white,
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.shipNavyPrimary,
                    radius: 20,
                    child: const Text('NC', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(color: Colors.green, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Admin Support (Nolan Caparros)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.shipNavyPrimary)),
                  Text('GJ & Asher Logistics Management • Online', style: TextStyle(fontSize: 10, color: Colors.grey)),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // Message List
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.all(16),
            itemCount: widget.messages.length,
            itemBuilder: (ctx, idx) {
              final msg = widget.messages[idx];
              final isCustomer = msg.sender == 'customer';

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: isCustomer ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${msg.senderName} • ${msg.timestamp}',
                      style: const TextStyle(fontSize: 9, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isCustomer ? AppColors.shipNavyPrimary : Colors.white,
                        borderRadius: BorderRadius.circular(16).copyWith(
                          topRight: isCustomer ? Radius.zero : const Radius.circular(16),
                          topLeft: !isCustomer ? Radius.zero : const Radius.circular(16),
                        ),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4)],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (msg.trackingNumber != null) ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                              margin: const EdgeInsets.only(bottom: 6),
                              decoration: BoxDecoration(
                                color: isCustomer ? Colors.white12 : Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(Icons.inventory_2, size: 12, color: isCustomer ? Colors.lightBlue.shade200 : Colors.blue),
                                  const SizedBox(width: 4),
                                  Text(
                                    '#${msg.trackingNumber}',
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isCustomer ? Colors.lightBlue.shade200 : Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          Text(
                            msg.text,
                            style: TextStyle(fontSize: 12, color: isCustomer ? Colors.white : Colors.black87, height: 1.3),
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

        // Quick prompts
        Container(
          height: 38,
          color: Colors.grey.shade100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            itemCount: quickPrompts.length,
            itemBuilder: (ctx, i) {
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ActionChip(
                  label: Text(quickPrompts[i], style: const TextStyle(fontSize: 10)),
                  backgroundColor: Colors.white,
                  onPressed: () => _textController.text = quickPrompts[i],
                ),
              );
            },
          ),
        ),

        // Input bar
        Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 16),
          color: Colors.white,
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _textController,
                  decoration: const InputDecoration(
                    hintText: 'Type your message to Admin...',
                    contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                style: IconButton.styleFrom(backgroundColor: AppColors.shipNavyPrimary, foregroundColor: Colors.white),
                icon: const Icon(Icons.send, size: 18),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
