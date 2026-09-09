/// The dealer's credit position, as returned by `/dealer/outstanding`.
class CreditModel {
  const CreditModel({
    required this.creditLimit,
    required this.outstandingBalance,
    required this.availableCredit,
    required this.isOverLimit,
    this.unpaidOrders = 0,
    this.lastPayment,
  });

  final double creditLimit;
  final double outstandingBalance;
  final double availableCredit;
  final bool isOverLimit;
  final int unpaidOrders;
  final PaymentModel? lastPayment;

  /// Fraction of the limit already consumed, clamped to 0..1 so the gauge can
  /// use it directly even when the dealer is over limit.
  double get utilisation {
    if (creditLimit <= 0) return outstandingBalance > 0 ? 1 : 0;
    return (outstandingBalance / creditLimit).clamp(0.0, 1.0);
  }

  factory CreditModel.fromJson(Map<String, dynamic> json) {
    final payment = json['last_payment'];

    return CreditModel(
      creditLimit: double.tryParse(json['credit_limit']?.toString() ?? '') ?? 0,
      outstandingBalance:
          double.tryParse(json['outstanding_balance']?.toString() ?? '') ?? 0,
      availableCredit:
          double.tryParse(json['available_credit']?.toString() ?? '') ?? 0,
      isOverLimit: json['is_over_limit'] == true,
      unpaidOrders: int.tryParse(json['unpaid_orders']?.toString() ?? '') ?? 0,
      lastPayment:
          payment is Map<String, dynamic> ? PaymentModel.fromJson(payment) : null,
    );
  }
}

/// A payment the dealer has made.
class PaymentModel {
  const PaymentModel({
    required this.id,
    required this.paymentNo,
    required this.amount,
    required this.mode,
    this.status = '',
    this.paidAt,
    this.orderNo = '',
  });

  final int id;
  final String paymentNo;
  final double amount;
  final String mode;
  final String status;
  final String? paidAt;
  final String orderNo;

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    final order = json['order'];
    final orderMap = order is Map<String, dynamic> ? order : const <String, dynamic>{};

    return PaymentModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      paymentNo: json['payment_no']?.toString() ?? '',
      amount: double.tryParse(json['amount']?.toString() ?? '') ?? 0,
      mode: json['payment_mode']?.toString() ?? '',
      status: json['status']?.toString() ?? '',
      paidAt: json['paid_at']?.toString(),
      orderNo: orderMap['order_no']?.toString() ?? '',
    );
  }
}

/// One line of the dealer ledger (`/dealer/ledger`).
class LedgerEntryModel {
  const LedgerEntryModel({
    required this.id,
    required this.entryType,
    required this.debit,
    required this.credit,
    required this.balance,
    this.remarks = '',
    this.createdAt = '',
  });

  final int id;
  final String entryType;
  final double debit;
  final double credit;
  final double balance;
  final String remarks;
  final String createdAt;

  bool get isDebit => debit > 0;

  factory LedgerEntryModel.fromJson(Map<String, dynamic> json) {
    return LedgerEntryModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      entryType: json['entry_type']?.toString() ?? '',
      debit: double.tryParse(json['debit']?.toString() ?? '') ?? 0,
      credit: double.tryParse(json['credit']?.toString() ?? '') ?? 0,
      balance: double.tryParse(json['balance']?.toString() ?? '') ?? 0,
      remarks: json['remarks']?.toString() ?? '',
      createdAt: json['created_at']?.toString() ?? '',
    );
  }
}
