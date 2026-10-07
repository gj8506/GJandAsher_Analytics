import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../theme/app_theme.dart';

class CustomerStoreScreen extends StatefulWidget {
  final List<Product> products;
  final Function(Product) onInquireProduct;

  const CustomerStoreScreen({
    Key? key,
    required this.products,
    required this.onInquireProduct,
  }) : super(key: key);

  @override
  State<CustomerStoreScreen> createState() => _CustomerStoreScreenState();
}

class _CustomerStoreScreenState extends State<CustomerStoreScreen> {
  String searchQuery = '';
  String selectedCategory = 'All';

  final categories = ['All', 'Electronics', 'Accessories', 'Home & Living', 'Apparel'];

  @override
  Widget build(BuildContext context) {
    final filtered = widget.products.where((p) {
      final matchesCat = selectedCategory == 'All' || p.category == selectedCategory;
      final matchesSearch = p.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
          p.description.toLowerCase().contains(searchQuery.toLowerCase());
      return matchesCat && matchesSearch;
    }).toList();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Available Products',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.shipNavyPrimary),
                ),
                Text(
                  'In-stock items ready for immediate dispatch',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.shopping_bag_outlined, color: Colors.green, size: 22),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Search Field
        TextField(
          onChanged: (val) => setState(() => searchQuery = val),
          decoration: InputDecoration(
            hintText: 'Search products, keyboards, earbuds...',
            prefixIcon: const Icon(Icons.search, size: 20, color: Colors.grey),
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade300)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: BorderSide(color: Colors.grey.shade300)),
          ),
        ),
        const SizedBox(height: 10),

        // Category Pills
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: categories.map((cat) {
              final isChosen = selectedCategory == cat;
              return Padding(
                padding: const EdgeInsets.only(right: 6),
                child: ChoiceChip(
                  label: Text(cat, style: TextStyle(fontSize: 11, fontWeight: isChosen ? FontWeight.bold : FontWeight.normal)),
                  selected: isChosen,
                  selectedColor: AppColors.shipNavyPrimary,
                  labelStyle: TextStyle(color: isChosen ? Colors.white : Colors.black87),
                  onSelected: (_) => setState(() => selectedCategory = cat),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 14),

        // Grid of products
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.72,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: filtered.length,
          itemBuilder: (ctx, idx) {
            final prod = filtered[idx];
            return Card(
              color: Colors.white,
              elevation: 0.5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: BorderSide(color: Colors.grey.shade200)),
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => _showProductDetails(context, prod),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.network(prod.image, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade200, child: const Icon(Icons.image))),
                          Positioned(
                            top: 6,
                            right: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                children: [
                                  const Icon(Icons.star, color: Colors.amber, size: 11),
                                  const SizedBox(width: 2),
                                  Text('${prod.rating}', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 6,
                            left: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(6)),
                              child: Text('${prod.stock} in stock', style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(prod.category.toUpperCase(), style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.grey)),
                                const SizedBox(height: 2),
                                Text(prod.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11, height: 1.2)),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(prod.price, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: AppColors.shipNavyPrimary)),
                                IconButton(
                                  constraints: const BoxConstraints(),
                                  padding: EdgeInsets.zero,
                                  icon: const Icon(Icons.chat_bubble_outline, size: 16, color: Colors.green),
                                  onPressed: () => widget.onInquireProduct(prod),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  void _showProductDetails(BuildContext context, Product prod) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(prod.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
                  IconButton(onPressed: () => Navigator.pop(ctx), icon: const Icon(Icons.close)),
                ],
              ),
              const SizedBox(height: 4),
              Text(prod.price, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18, color: AppColors.shipNavyPrimary)),
              const SizedBox(height: 8),
              Text(prod.description, style: const TextStyle(fontSize: 12, color: Colors.black87, height: 1.4)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Warehouse Stock (MNL-HUB-04)', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    Text('${prod.stock} units available', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.green)),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.shipNavyPrimary, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
                  onPressed: () {
                    Navigator.pop(ctx);
                    widget.onInquireProduct(prod);
                  },
                  icon: const Icon(Icons.chat),
                  label: const Text('Inquire with Admin in Chat', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
