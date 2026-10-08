import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../theme/app_theme.dart';

class CustomerChatScreen extends StatefulWidget {
  final List<ChatMessage> messages;
  final Function(String, String?, String?) onSendMessage; // text, trackingNumber, chatType
  final String? initialInquiry;
  final bool isAdminTyping;

  const CustomerChatScreen({
    Key? key,
    required this.messages,
    required this.onSendMessage,
    this.initialInquiry,
    this.isAdminTyping = false,
  }) : super(key: key);

  @override
  State<CustomerChatScreen> createState() => _CustomerChatScreenState();
}

class _CustomerChatScreenState extends State<CustomerChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String _selectedChatType = 'order'; // 'order', 'return', 'product', 'general'
  bool _hasInputText = false;

  final Map<String, List<String>> _promptsByType = {
    'order': [
      'Where is my dispatched order?',
      'When will courier tracking update?',
      'Can I change my delivery address?',
      'Expected arrival date in Manila?',
    ],
    'return': [
      'How do I process a damaged return?',
      'What is the status of my refund inspection?',
      'My package arrived with broken seal',
      'Return drop-off hub location?',
    ],
    'product': [
      'Is the mechanical keyboard in stock?',
      'Do you offer wholesale bulk pricing?',
      'When will new electronics arrive?',
      'Are prices inclusive of shipping?',
    ],
    'general': [
      'What are your warehouse operating hours?',
      'Where is the main distribution center?',
      'How do I contact customer support?',
      'Request official sales invoice (BIR)',
    ],
  };

  final Map<String, String> _placeholdersByType = {
    'order': 'Ask Admin about parcel tracking or courier status...',
    'return': 'Ask Admin about returns, damages, or refund inspection...',
    'product': 'Ask Admin about product specs, stock, and availability...',
    'general': 'Type your message or inquiry to warehouse admin...',
  };

  @override
  void initState() {
    super.initState();
    if (widget.initialInquiry != null) {
      _textController.text = widget.initialInquiry!;
      _hasInputText = true;
      if (widget.initialInquiry!.toLowerCase().contains('return') ||
          widget.initialInquiry!.toLowerCase().contains('damage')) {
        _selectedChatType = 'return';
      } else if (widget.initialInquiry!.toLowerCase().contains('stock') ||
          widget.initialInquiry!.toLowerCase().contains('product')) {
        _selectedChatType = 'product';
      }
    }

    _textController.addListener(() {
      final hasText = _textController.text.trim().isNotEmpty;
      if (hasText != _hasInputText) {
        setState(() {
          _hasInputText = hasText;
        });
      }
    });
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _textController.text.trim();
    if (text.isEmpty) return;

    widget.onSendMessage(text, null, _selectedChatType);
    _textController.clear();

    Future.delayed(const Duration(milliseconds: 150), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Widget _buildTypeBadge(String? type, bool isCustomer) {
    if (type == null) return const SizedBox.shrink();

    String label;
    IconData icon;
    Color bg;
    Color text;

    switch (type) {
      case 'order':
        label = 'Order Inquiry';
        icon = Icons.local_shipping_outlined;
        bg = isCustomer ? Colors.white12 : Colors.blue.shade50;
        text = isCustomer ? Colors.lightBlue.shade200 : Colors.blue.shade800;
        break;
      case 'return':
        label = 'Return / RTS';
        icon = Icons.assignment_return_outlined;
        bg = isCustomer ? Colors.white12 : Colors.orange.shade50;
        text = isCustomer ? Colors.amber.shade200 : Colors.orange.shade900;
        break;
      case 'product':
        label = 'Product Inquiry';
        icon = Icons.shopping_bag_outlined;
        bg = isCustomer ? Colors.white12 : Colors.green.shade50;
        text = isCustomer ? Colors.lightGreen.shade200 : Colors.green.shade800;
        break;
      case 'general':
      default:
        label = 'General Help';
        icon = Icons.help_outline_rounded;
        bg = isCustomer ? Colors.white12 : Colors.grey.shade100;
        text = isCustomer ? Colors.white70 : Colors.grey.shade800;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: text),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: text),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activePrompts = _promptsByType[_selectedChatType] ?? _promptsByType['order']!;
    final placeholder = _placeholdersByType[_selectedChatType] ?? 'Type your message to Admin...';

    return Column(
      children: [
        // Top Header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          color: Colors.white,
          child: Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.shipNavyPrimary,
                    radius: 18,
                    child: const Text('GJ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Admin Support (gj8506)',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.shipNavyPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      'GJ & Asher Logistics Hub • Live Help',
                      style: TextStyle(fontSize: 10, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.green.shade200, width: 0.5),
                ),
                child: Text(
                  'Live Help',
                  style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.green.shade800),
                ),
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // Inquiry Type Selector Bar
        Container(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'SELECT INQUIRY TYPE:',
                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 0.5),
                  ),
                  Text(
                    _selectedChatType == 'order'
                        ? 'Order Tracking'
                        : _selectedChatType == 'return'
                            ? 'Returns & RTS'
                            : _selectedChatType == 'product'
                                ? 'Product Stock'
                                : 'General Help',
                    style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.shipTealAccent),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  _buildTypeTab('order', 'Orders', Icons.local_shipping_outlined),
                  const SizedBox(width: 6),
                  _buildTypeTab('return', 'Returns', Icons.assignment_return_outlined),
                  const SizedBox(width: 6),
                  _buildTypeTab('product', 'Stock', Icons.shopping_bag_outlined),
                  const SizedBox(width: 6),
                  _buildTypeTab('general', 'Help', Icons.help_outline_rounded),
                ],
              ),
            ],
          ),
        ),
        const Divider(height: 1),

        // Message List Feed or Empty State
        Expanded(
          child: widget.messages.isEmpty
              ? Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.blue.shade100),
                          ),
                          child: const Icon(Icons.chat_bubble_outline, size: 26, color: AppColors.shipTealAccent),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No Messages Yet',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.shipNavyPrimary),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Select an inquiry type above or type a message to ask the warehouse administration desk about orders, dispatches, returns, or product availability.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 11, color: Colors.grey, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  itemCount: widget.messages.length + (widget.isAdminTyping ? 1 : 0),
                  itemBuilder: (ctx, idx) {
                    // Check if this is the animated typing indicator
                    if (idx == widget.messages.length && widget.isAdminTyping) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Admin (gj8506) • typing...',
                              style: TextStyle(fontSize: 9, color: Colors.grey),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14).copyWith(topLeft: Radius.zero),
                                border: Border.all(color: Colors.grey.shade200),
                                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 4)],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle),
                                  ),
                                  const SizedBox(width: 4),
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(color: Colors.blue.shade300, shape: BoxShape.circle),
                                  ),
                                  const SizedBox(width: 4),
                                  Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(color: Colors.blue.shade200, shape: BoxShape.circle),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Admin is replying...',
                                    style: TextStyle(fontSize: 10, color: Colors.grey, fontStyle: FontStyle.italic),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

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
                            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.82),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isCustomer ? AppColors.shipNavyPrimary : Colors.white,
                              borderRadius: BorderRadius.circular(16).copyWith(
                                topRight: isCustomer ? Radius.zero : const Radius.circular(16),
                                topLeft: !isCustomer ? Radius.zero : const Radius.circular(16),
                              ),
                              border: !isCustomer ? Border.all(color: Colors.grey.shade200) : null,
                              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 4)],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Category / Tracking chips row
                                if (msg.chatType != null || msg.trackingNumber != null) ...[
                                  Wrap(
                                    spacing: 4,
                                    runSpacing: 4,
                                    children: [
                                      if (msg.chatType != null) _buildTypeBadge(msg.chatType, isCustomer),
                                      if (msg.trackingNumber != null)
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: isCustomer ? Colors.white12 : Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(Icons.inventory_2_outlined, size: 10, color: isCustomer ? Colors.lightBlue.shade200 : Colors.blue),
                                              const SizedBox(width: 3),
                                              Text(
                                                '#${msg.trackingNumber}',
                                                style: TextStyle(
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold,
                                                  color: isCustomer ? Colors.lightBlue.shade200 : Colors.blue,
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
                                  style: TextStyle(fontSize: 12, color: isCustomer ? Colors.white : Colors.black87, height: 1.35),
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

        // Quick prompt chips based on selected type
        Container(
          height: 38,
          color: Colors.grey.shade100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            itemCount: activePrompts.length,
            itemBuilder: (ctx, i) {
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ActionChip(
                  label: Text(activePrompts[i], style: const TextStyle(fontSize: 10)),
                  backgroundColor: Colors.white,
                  side: BorderSide(color: Colors.grey.shade300, width: 0.5),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  onPressed: () {
                    _textController.text = activePrompts[i];
                  },
                ),
              );
            },
          ),
        ),

        // Polished Input bar with clear button & send button
        Container(
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 12),
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
                    hintText: placeholder,
                    hintStyle: const TextStyle(fontSize: 11, color: Colors.grey),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: const BorderSide(color: AppColors.shipTealAccent, width: 1.5),
                    ),
                    suffixIcon: _hasInputText
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 16, color: Colors.grey),
                            onPressed: () {
                              _textController.clear();
                            },
                          )
                        : null,
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                style: IconButton.styleFrom(
                  backgroundColor: _hasInputText ? AppColors.shipNavyPrimary : Colors.grey.shade200,
                  foregroundColor: _hasInputText ? Colors.white : Colors.grey.shade400,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.send_rounded, size: 18),
                onPressed: _hasInputText ? _sendMessage : null,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTypeTab(String type, String label, IconData icon) {
    final isSelected = _selectedChatType == type;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedChatType = type;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.shipNavyPrimary : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? AppColors.shipNavyPrimary : Colors.grey.shade300,
              width: 0.5,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 14,
                color: isSelected ? Colors.white : Colors.grey.shade700,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? Colors.white : Colors.grey.shade700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
