import 'package:flutter/material.dart';

import '../../../orders/views/orders_view.dart';
import 'account_chip_bar.dart';

/// ☰ tab: Order History with the account chips pinned at the bottom.
class OrderHistoryTab extends StatelessWidget {
  const OrderHistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Expanded(child: OrdersView(history: true)),
        AccountChipBar(),
      ],
    );
  }
}
