import 'package:intl/intl.dart';
import '../../localization/t.dart';

/// One line of an order: product, variant, quantity and amounts.
class OrderItemDetailModel {
  const OrderItemDetailModel({
    required this.productName,
    this.variantName = '',
    this.imageUrl,
    this.quantity = 0,
    this.unitsPerCase = 1,
    this.unitPrice = 0,
    this.lineTotal = 0,
  });

  final String productName;
  final String variantName;
  final String? imageUrl;
  final double quantity;
  final double unitsPerCase;
  final double unitPrice;
  final double lineTotal;

  factory OrderItemDetailModel.fromJson(Map<String, dynamic> json) {
    final product = json['product'];
    final packQuantity = _number(json['pack_quantity']);
    final unitsPerCase = _number(json['units_per_case']);

    return OrderItemDetailModel(
      productName: product is Map ? (_text(product['name']) ?? 'Product') : 'Product removed',
      variantName: _text(json['variant_name']) ?? '',
      imageUrl: _text(json['product_image_url']),
      quantity: packQuantity > 0 ? packQuantity : _number(json['quantity']),
      unitsPerCase: unitsPerCase > 0 ? unitsPerCase : 1,
      unitPrice: _number(json['unit_price']),
      lineTotal: _number(json['line_total']),
    );
  }

  /// "2 cases × 50 units/case = 100 units" for case packs, otherwise "Qty 3".
  /// Spelling the case size out matters because [quantity] is a count of
  /// cases, not of units — without it the number reads as far too small.
  String get quantityLabel {
    final qty = _plain(quantity);

    if (unitsPerCase > 1) {
      return t('common.cases_units_total', {
        'qty': quantity == 1
            ? t('common.case_one', {'n': qty})
            : t('common.case_many', {'n': qty}),
        'units': _plain(unitsPerCase),
        'total': _plain(quantity * unitsPerCase),
      });
    }

    return t('common.qty', {'n': qty});
  }

  /// Rate for one whole case — how dealers buy, and what the cart shows.
  double get casePrice => unitPrice * (unitsPerCase <= 0 ? 1 : unitsPerCase);
}

/// Full order from the order detail endpoint.
class OrderDetailModel {
  const OrderDetailModel({
    required this.orderNo,
    this.status = '',
    this.paymentMethod = '',
    this.paymentStatus = '',
    this.subtotal = 0,
    this.gstTotal = 0,
    this.discountTotal = 0,
    this.grandTotal = 0,
    this.createdAt = '',
    this.contactName = '',
    this.contactMobile = '',
    this.address = '',
    this.notes = '',
    this.items = const [],
    this.invoiceNo = '',
    this.dispatchNo = '',
    this.availability = '',
    this.availableOn = '',
  });

  final String orderNo;
  final String status;
  final String paymentMethod;
  final String paymentStatus;
  final double subtotal;
  final double gstTotal;
  final double discountTotal;
  final double grandTotal;
  final String createdAt;
  final String contactName;
  final String contactMobile;
  final String address;
  final String notes;
  final List<OrderItemDetailModel> items;
  final String invoiceNo;
  final String dispatchNo;

  /// Salesman's stock answer while the order is still in their review:
  /// `not_available`, `available_on`, or empty. Not an order status.
  final String availability;

  /// Raw timestamp the stock is expected, set only with `available_on`.
  final String availableOn;

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final invoice = json['invoice'];
    final dispatches = json['dispatches'] is List ? (json['dispatches'] as List).whereType<Map>().toList() : const <Map>[];

    // Latest dispatch by creation time (ISO strings sort chronologically).
    final dispatch = dispatches.isEmpty
        ? null
        : dispatches.reduce((a, b) => (_text(b['created_at']) ?? '').compareTo(_text(a['created_at']) ?? '') > 0 ? b : a);

    return OrderDetailModel(
      orderNo: _text(json['order_no']) ?? '',
      status: _text(json['status']) ?? '',
      paymentMethod: _text(json['payment_method']) ?? '',
      paymentStatus: _text(json['payment_status']) ?? '',
      subtotal: _number(json['subtotal']),
      gstTotal: _number(json['gst_total']),
      discountTotal: _number(json['discount_total']),
      grandTotal: _number(json['grand_total']),
      createdAt: _text(json['created_at']) ?? '',
      contactName: _text(json['contact_name']) ?? '',
      contactMobile: _text(json['contact_mobile']) ?? '',
      address: [json['address_line1'], json['address_line2'], json['city'], json['state'], json['pincode']]
          .map(_text)
          .whereType<String>()
          .join(', '),
      notes: _text(json['notes']) ?? '',
      items: rawItems is List
          ? rawItems.whereType<Map>().map((item) => OrderItemDetailModel.fromJson(Map<String, dynamic>.from(item))).toList()
          : const [],
      invoiceNo: invoice is Map ? (_text(invoice['invoice_no']) ?? '') : '',
      dispatchNo: dispatch == null ? '' : (_text(dispatch['dispatch_no']) ?? ''),
      availability: _text(json['availability']) ?? '',
      availableOn: _text(json['available_on']) ?? '',
    );
  }

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

  /// e.g. "14 Sep 2026".
  String get displayDate {
    final parsed = DateTime.tryParse(createdAt);

    return parsed == null ? createdAt : DateFormat('dd MMM yyyy').format(parsed.toLocal());
  }

  String get paymentMethodLabel => switch (paymentMethod.toLowerCase()) {
        'cod' => t('checkout.cash_upi'),
        'credit' => t('checkout.pay_later'),
        'upi' => 'UPI',
        'bank_transfer' => t('common.bank_transfer'),
        '' => '—',
        final other => _pretty(other),
      };

  String get paymentStatusLabel => paymentStatus.isEmpty ? t('common.pending') : _pretty(paymentStatus);
}

double _number(dynamic value) => double.tryParse(value?.toString() ?? '') ?? 0;

String? _text(dynamic value) {
  final text = value?.toString().trim() ?? '';

  return text.isEmpty || text == 'null' ? null : text;
}

String _plain(double value) => value == value.roundToDouble() ? value.toInt().toString() : value.toString();

String _pretty(String value) => value
    .split('_')
    .where((word) => word.isNotEmpty)
    .map((word) => '${word[0].toUpperCase()}${word.substring(1)}')
    .join(' ');
