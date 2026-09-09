/// An invoice raised against one of the account's orders.
class InvoiceModel {
  const InvoiceModel({
    required this.id,
    required this.invoiceNo,
    required this.invoiceDate,
    required this.total,
    this.orderNo = '',
    this.orderStatus = '',
    this.hasPdf = false,
  });

  final int id;
  final String invoiceNo;
  final String invoiceDate;
  final double total;
  final String orderNo;
  final String orderStatus;
  final bool hasPdf;

  factory InvoiceModel.fromJson(Map<String, dynamic> json) {
    final order = json['order'];
    final orderMap = order is Map<String, dynamic> ? order : const <String, dynamic>{};

    return InvoiceModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      invoiceNo: json['invoice_no']?.toString() ?? '',
      invoiceDate: json['invoice_date']?.toString() ?? '',
      total: double.tryParse(json['grand_total']?.toString() ?? '') ?? 0,
      orderNo: orderMap['order_no']?.toString() ?? '',
      orderStatus: orderMap['status']?.toString() ?? '',
      hasPdf: (json['pdf_path']?.toString() ?? '').isNotEmpty,
    );
  }
}
