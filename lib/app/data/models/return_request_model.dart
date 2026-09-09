/// A return raised against a delivered order.
class ReturnRequestModel {
  const ReturnRequestModel({
    required this.id,
    required this.returnNo,
    required this.status,
    required this.reason,
    required this.refundAmount,
    this.orderNo = '',
    this.createdAt = '',
  });

  final int id;
  final String returnNo;
  final String status;
  final String reason;
  final double refundAmount;
  final String orderNo;
  final String createdAt;

  factory ReturnRequestModel.fromJson(Map<String, dynamic> json) {
    final order = json['order'];
    final orderMap = order is Map<String, dynamic> ? order : const <String, dynamic>{};

    return ReturnRequestModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      returnNo: json['return_no']?.toString() ?? '',
      status: json['status']?.toString() ?? 'requested',
      reason: json['reason']?.toString() ?? '',
      refundAmount: double.tryParse(json['refund_amount']?.toString() ?? '') ?? 0,
      orderNo: orderMap['order_no']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}
