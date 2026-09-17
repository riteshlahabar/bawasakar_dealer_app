import 'package:intl/intl.dart';

class OrderModel {
  const OrderModel({
    required this.id,
    required this.orderNo,
    required this.status,
    required this.total,
    required this.createdAt,
    this.paymentStatus = '',
    this.productNames = const [],
    this.imageUrls = const [],
    this.items = const [],
    this.deliveredAt = '',
    this.hasInvoice = false,
    this.invoiceId = 0,
  });

  /// Returns are accepted this many days after delivery (the server checks too).
  static const returnWindowDays = 7;

  final int id;
  final String orderNo;
  final String status;
  final double total;
  final String createdAt;
  final String paymentStatus;
  final List<String> productNames;

  /// Up to three product images, for the stacked thumbnails.
  final List<String> imageUrls;

  /// Raw order items, used to rebuild products for "Buy again".
  final List<Map<String, dynamic>> items;

  final String deliveredAt;
  final bool hasInvoice;

  /// Id of the invoice raised for this order, 0 when it has none yet.
  final int invoiceId;

  int get itemCount => items.length;

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final items = json['items'] is List
        ? (json['items'] as List).whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList()
        : const <Map<String, dynamic>>[];
    final dispatches = json['dispatches'] is List ? (json['dispatches'] as List).whereType<Map>() : const <Map>[];
    final deliveredDates = dispatches.map((dispatch) => dispatch['delivered_at']?.toString() ?? '').where((date) => date.isNotEmpty && date != 'null').toList()
      ..sort();

    return OrderModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      orderNo: json['order_no']?.toString() ?? json['order_number']?.toString() ?? 'ORD-${json['id'] ?? ''}',
      status: json['status']?.toString() ?? 'pending',
      total: double.tryParse(json['grand_total']?.toString() ?? json['total']?.toString() ?? '') ?? 0,
      createdAt: json['created_at']?.toString() ?? '',
      paymentStatus: json['payment_status']?.toString() ?? '',
      items: items,
      deliveredAt: deliveredDates.isEmpty ? '' : deliveredDates.last,
      hasInvoice: json['invoice'] is Map,
      invoiceId: json['invoice'] is Map
          ? int.tryParse((json['invoice'] as Map)['id']?.toString() ?? '') ?? 0
          : 0,
      imageUrls: items
          .map((item) => item['product_image_url']?.toString().trim() ?? '')
          .where((url) => url.isNotEmpty && url != 'null')
          .toSet()
          .take(3)
          .toList(),
      productNames: items
          .map((item) {
            final product = item['product'];
            final name = product is Map ? product['name'] : item['product_name'];
            return name?.toString().trim() ?? '';
          })
          .where((name) => name.isNotEmpty)
          .toSet()
          .toList(),
    );
  }

  DateTime? get placedAt => DateTime.tryParse(createdAt)?.toLocal();

  DateTime? get deliveredTime => DateTime.tryParse(deliveredAt)?.toLocal();

  /// e.g. "14 Sep 2026, 10:22 AM"; the raw value when it is not a date.
  String get displayDate => placedAt == null ? createdAt : DateFormat('dd MMM yyyy, hh:mm a').format(placedAt!);

  /// e.g. "12 Sep", or empty when not delivered.
  String get deliveredLabel => deliveredTime == null ? '' : DateFormat('dd MMM').format(deliveredTime!);

  bool get canReturn {
    if (status != 'delivered') return false;
    final delivered = deliveredTime;
    return delivered == null || DateTime.now().difference(delivered).inDays <= returnWindowDays;
  }

  /// Search by order number, product name or status.
  bool matches(String term) {
    final query = term.toLowerCase();

    return orderNo.toLowerCase().contains(query) ||
        status.replaceAll('_', ' ').toLowerCase().contains(query) ||
        productNames.any((name) => name.toLowerCase().contains(query));
  }
}
