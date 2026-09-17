import '../../../app/localization/t.dart';

/// Tabs on the Current Orders screen and the Order History screen.
enum OrderFilter {
  // Current Orders
  current('orders.all'),
  review('orders.in_review'),
  packing('orders.packing'),
  onTheWay('orders.on_the_way'),

  // Order History
  past('orders.all'),
  delivered('orders.delivered'),
  cancelled('orders.cancelled'),

  /// Shows products from past orders instead of orders.
  buyAgain('orders.buy_again');

  const OrderFilter(this.label);

  /// Translation key, not display text.
  final String label;

  String get title => t(label);

  static const currentTabs = [current, review, packing, onTheWay];
  static const historyTabs = [past, delivered, cancelled, buyAgain];

  /// Delivered or cancelled orders belong to Order History.
  static bool isFinished(String status) {
    final value = status.toLowerCase();

    return value == 'delivered' || value == 'cancelled' || value == 'rejected';
  }

  bool matches(String status) {
    final value = status.toLowerCase();

    return switch (this) {
      OrderFilter.current => !isFinished(value),
      OrderFilter.review => const ['salesman_review', 'admin_review', 'pending'].contains(value),
      OrderFilter.packing => const ['approved', 'packing', 'packed'].contains(value),
      OrderFilter.onTheWay => const ['dispatched', 'shipped', 'out_for_delivery'].contains(value),
      OrderFilter.past || OrderFilter.buyAgain => isFinished(value),
      OrderFilter.delivered => value == 'delivered',
      OrderFilter.cancelled => value == 'cancelled' || value == 'rejected',
    };
  }
}

/// Time filter on the Order History screen.
enum OrderPeriod {
  all('orders.all_time'),
  last30Days('orders.last_30_days'),
  last3Months('orders.last_3_months'),
  thisYear('orders.this_year');

  const OrderPeriod(this.label);

  /// Translation key, not display text.
  final String label;

  String get title => t(label);

  bool includes(DateTime? placedAt) {
    if (this == OrderPeriod.all) return true;
    if (placedAt == null) return false;

    final now = DateTime.now();

    return switch (this) {
      OrderPeriod.last30Days => now.difference(placedAt).inDays <= 30,
      OrderPeriod.last3Months => now.difference(placedAt).inDays <= 92,
      OrderPeriod.thisYear => placedAt.year == now.year,
      OrderPeriod.all => true,
    };
  }
}
