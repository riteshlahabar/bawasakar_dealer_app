/// One bucket in an order report — a status, or a month.
class ReportBucketModel {
  const ReportBucketModel({
    required this.label,
    required this.count,
    required this.value,
  });

  final String label;
  final int count;
  final double value;

  factory ReportBucketModel.fromEntry(String label, Map<String, dynamic> json) {
    return ReportBucketModel(
      label: label,
      count: int.tryParse(json['count']?.toString() ?? '') ?? 0,
      value: double.tryParse(json['value']?.toString() ?? '') ?? 0,
    );
  }
}

/// Response of `/dealer/reports/orders`.
class OrderReportModel {
  const OrderReportModel({
    required this.from,
    required this.orderCount,
    required this.orderValue,
    required this.byStatus,
    required this.byMonth,
  });

  final String from;
  final int orderCount;
  final double orderValue;
  final List<ReportBucketModel> byStatus;
  final List<ReportBucketModel> byMonth;

  factory OrderReportModel.fromJson(Map<String, dynamic> json) {
    final totals = json['totals'];
    final totalsMap = totals is Map<String, dynamic> ? totals : const <String, dynamic>{};

    return OrderReportModel(
      from: json['from']?.toString() ?? '',
      orderCount: int.tryParse(totalsMap['orders']?.toString() ?? '') ?? 0,
      orderValue: double.tryParse(totalsMap['value']?.toString() ?? '') ?? 0,
      byStatus: _buckets(json['by_status']),
      byMonth: _buckets(json['by_month']),
    );
  }

  /// The API returns these as label-keyed objects rather than arrays, because
  /// the labels are what identify the bucket.
  static List<ReportBucketModel> _buckets(Object? raw) {
    if (raw is! Map) return const <ReportBucketModel>[];

    return raw.entries
        .where((entry) => entry.value is Map<String, dynamic>)
        .map((entry) => ReportBucketModel.fromEntry(
              entry.key.toString(),
              entry.value as Map<String, dynamic>,
            ))
        .toList();
  }
}

/// One product row in `/dealer/reports/sales`.
class ProductSalesModel {
  const ProductSalesModel({
    required this.product,
    required this.sku,
    required this.quantity,
    required this.value,
  });

  final String product;
  final String sku;
  final double quantity;
  final double value;

  factory ProductSalesModel.fromJson(Map<String, dynamic> json) {
    return ProductSalesModel(
      product: json['product']?.toString() ?? '',
      sku: json['sku']?.toString() ?? '',
      quantity: double.tryParse(json['quantity']?.toString() ?? '') ?? 0,
      value: double.tryParse(json['value']?.toString() ?? '') ?? 0,
    );
  }
}
