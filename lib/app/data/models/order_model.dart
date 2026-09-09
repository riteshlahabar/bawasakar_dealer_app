class OrderModel {
  const OrderModel({
    required this.id,
    required this.orderNo,
    required this.status,
    required this.total,
    required this.createdAt,
  });

  final int id;
  final String orderNo;
  final String status;
  final double total;
  final String createdAt;

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      orderNo: json['order_no']?.toString() ?? json['order_number']?.toString() ?? 'ORD-${json['id'] ?? ''}',
      status: json['status']?.toString() ?? 'pending',
      total: double.tryParse(json['grand_total']?.toString() ?? json['total']?.toString() ?? '') ?? 0,
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}
