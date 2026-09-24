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
    this.availability = '',
    this.availableOn = '',
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

  /// The salesman's stock answer while they are still reviewing the order:
  /// `not_available`, `available_on`, or empty when they haven't answered.
  /// The order has not moved — this is a note about stock, not a status.
  final String availability;

  /// Raw timestamp the stock is expected, set only with `available_on`.
  final String availableOn;

  /// One line for the dealer, e.g. "Stock available on 25 Sep 2026, 10:00 AM"
  /// or "Stock not available right now". Empty when nothing was marked.
  String get availabilityLabel {
    if (availability == 'available_on') {
      final expected = DateTime.tryParse(availableOn)?.toLocal();

      return expected == null
          ? 'Stock available soon'
          : 'Stock available on ${DateFormat('dd MMM yyyy, hh:mm a').format(expected)}';
    }

    if (availability == 'not_available') {
      return 'Stock not available right now';
    }

    return '';
  }

  int get itemCount => items.length;

  /// One line per item: "Basmati Rice (1 KG) × 3" — pack size and quantity,
  /// not just the bare product name.
  List<String> get itemSummaries {
    return items
        .map((item) {
          final product = item['product'];
          final name = (product is Map ? product['name'] : item['product_name'])?.toString().trim() ?? '';
          if (name.isEmpty) return '';

          final variant = item['variant_name']?.toString().trim() ?? '';
          final packQuantity = double.tryParse(item['pack_quantity']?.toString() ?? '') ?? 0;
          final quantity = packQuantity > 0 ? packQuantity : (double.tryParse(item['quantity']?.toString() ?? '') ?? 0);
          final quantityLabel = quantity == quantity.roundToDouble() ? quantity.toInt().toString() : quantity.toString();

          final label = variant.isEmpty ? name : '$name ($variant)';
          return quantity > 0 ? '$label × $quantityLabel' : label;
        })
        .where((line) => line.isNotEmpty)
        .toList();
  }

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
      availability: json['availability']?.toString().trim() ?? '',
      availableOn: json['available_on']?.toString().trim() ?? '',
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

  /// Self-service cancel is only offered before the order is approved into
  /// production — once packing starts, only admin can cancel it.
  bool get canCancel => status == 'salesman_review' || status == 'admin_review';

  /// Search by order number, product name or status.
  bool matches(String term) {
    final query = term.toLowerCase();

    return orderNo.toLowerCase().contains(query) ||
        status.replaceAll('_', ' ').toLowerCase().contains(query) ||
        productNames.any((name) => name.toLowerCase().contains(query));
  }
}
