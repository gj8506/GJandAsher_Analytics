class Product {
  final String id;
  final String name;
  final String category;
  final String price;
  final double rawPrice;
  final int stock;
  final String description;
  final List<String> platforms;
  final String image;
  final double rating;
  final int reviewsCount;

  Product({
    required this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.rawPrice,
    required this.stock,
    required this.description,
    required this.platforms,
    required this.image,
    required this.rating,
    required this.reviewsCount,
  });
}

class ChatMessage {
  final String id;
  final String sender; // 'customer' or 'admin'
  final String senderName;
  final String text;
  final String timestamp;
  final String? trackingNumber;
  final String? productId;

  ChatMessage({
    required this.id,
    required this.sender,
    required this.senderName,
    required this.text,
    required this.timestamp,
    this.trackingNumber,
    this.productId,
  });
}
