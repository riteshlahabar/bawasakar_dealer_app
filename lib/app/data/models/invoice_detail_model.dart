/// One billed line on an invoice.
class InvoiceItemModel {
  const InvoiceItemModel({
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
    this.variantName = '',
    this.unitsPerCase = 0,
    this.gstPercent = 0,
    this.gstAmount = 0,
  });

  final String name;
  final double quantity;
  final double unitPrice;
  final double lineTotal;
  final String variantName;
  final double unitsPerCase;
  final double gstPercent;
  final double gstAmount;

  /// Dealers buy in cases, so the case size is worth spelling out.
  String get subtitle {
    final parts = <String>[];
    if (variantName.isNotEmpty) parts.add(variantName);
    if (unitsPerCase > 0) parts.add('1 case = ${_trim(unitsPerCase)} x $variantName');
    if (gstPercent > 0) parts.add('GST ${gstPercent.toStringAsFixed(0)}%');
    return parts.join(' • ');
  }

  static String _trim(double value) {
    final text = value.toStringAsFixed(3);
    return text.replaceFirst(RegExp(r'\.?0+$'), '');
  }

  factory InvoiceItemModel.fromJson(Map<String, dynamic> json) {
    final product = json['product'];
    final productMap = product is Map<String, dynamic> ? product : const <String, dynamic>{};

    return InvoiceItemModel(
      name: productMap['name']?.toString() ?? 'Product',
      quantity: _number(json['pack_quantity'] ?? json['quantity']),
      unitPrice: _number(json['unit_price']),
      lineTotal: _number(json['line_total']),
      variantName: json['variant_name']?.toString() ?? '',
      unitsPerCase: _number(json['units_per_case']),
      gstPercent: _number(json['gst_percent']),
      gstAmount: _number(json['gst_amount']),
    );
  }

  static double _number(Object? value) =>
      double.tryParse(value?.toString() ?? '') ?? 0;
}

/// A full invoice: header, billed lines and the amount breakdown.
class InvoiceDetailModel {
  const InvoiceDetailModel({
    required this.id,
    required this.invoiceNo,
    required this.invoiceDate,
    required this.grandTotal,
    this.orderId = 0,
    this.orderNo = '',
    this.orderStatus = '',
    this.orderType = '',
    this.subtotal = 0,
    this.gstTotal = 0,
    this.discountTotal = 0,
    this.items = const <InvoiceItemModel>[],
  });

  final int id;
  final String invoiceNo;
  final String invoiceDate;
  final double grandTotal;
  final int orderId;
  final String orderNo;
  final String orderStatus;
  final String orderType;
  final double subtotal;
  final double gstTotal;
  final double discountTotal;
  final List<InvoiceItemModel> items;

  bool get hasItems => items.isNotEmpty;

  factory InvoiceDetailModel.fromJson(Map<String, dynamic> json) {
    final order = json['order'];
    final orderMap = order is Map<String, dynamic> ? order : const <String, dynamic>{};
    final rawItems = orderMap['items'];

    return InvoiceDetailModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      invoiceNo: json['invoice_no']?.toString() ?? '',
      invoiceDate: json['invoice_date']?.toString() ?? '',
      grandTotal: InvoiceItemModel._number(json['grand_total']),
      orderId: int.tryParse(orderMap['id']?.toString() ?? '') ?? 0,
      orderNo: orderMap['order_no']?.toString() ?? '',
      orderStatus: orderMap['status']?.toString() ?? '',
      orderType: orderMap['order_type']?.toString() ?? '',
      subtotal: InvoiceItemModel._number(orderMap['subtotal']),
      gstTotal: InvoiceItemModel._number(orderMap['gst_total']),
      discountTotal: InvoiceItemModel._number(orderMap['discount_total']),
      items: rawItems is List
          ? rawItems
              .whereType<Map<String, dynamic>>()
              .map(InvoiceItemModel.fromJson)
              .toList()
          : const <InvoiceItemModel>[],
    );
  }
}
