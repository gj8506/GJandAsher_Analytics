class Parcel {
  final String id;
  final String trackingNumber;
  final String platform; // Shopee, Lazada, TikTok Shop
  final String courier; // SPX Express, J&T Express, etc.
  final String customer;
  final String? phone;
  final String? destination;
  final String amount;
  final double rawAmount;
  final String status; // Dispatched, In Transit, Delivered, Return Logged
  final String statusColorHex;
  final String dispatchedAt;
  final String dateISO;
  final String? items;

  Parcel({
    required this.id,
    required this.trackingNumber,
    required this.platform,
    required this.courier,
    required this.customer,
    this.phone,
    this.destination,
    required this.amount,
    required this.rawAmount,
    required this.status,
    required this.statusColorHex,
    required this.dispatchedAt,
    required this.dateISO,
    this.items,
  });
}

class ReturnRecord {
  final String id;
  final String trackingNumber;
  final String platform;
  final String courier;
  final String customer;
  final String reason;
  final String condition;
  final String refundStatus;
  final String loggedAt;
  final String refundAmount;
  final String? notes;

  ReturnRecord({
    required this.id,
    required this.trackingNumber,
    required this.platform,
    required this.courier,
    required this.customer,
    required this.reason,
    required this.condition,
    required this.refundStatus,
    required this.loggedAt,
    required this.refundAmount,
    this.notes,
  });
}
