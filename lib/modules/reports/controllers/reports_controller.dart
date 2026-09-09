import 'package:get/get.dart';

import '../../../app/data/models/report_model.dart';
import '../../../app/data/services/dealer_report_api_service.dart';

/// Order and product-wise purchase reporting over a selectable window.
class ReportsController extends GetxController {
  ReportsController(this._api);

  final DealerReportApiService _api;

  /// Windows the report screen offers, in months.
  static const windows = <int>[3, 6, 12, 24];

  final report = Rxn<OrderReportModel>();
  final products = <ProductSalesModel>[].obs;
  final months = 6.obs;
  final isLoading = false.obs;
  final error = ''.obs;

  @override
  void onInit() {
    load();
    super.onInit();
  }

  Future<void> changeWindow(int value) async {
    if (months.value == value) return;
    months.value = value;
    await load();
  }

  Future<void> load() async {
    isLoading.value = true;
    error.value = '';
    try {
      final window = months.value;
      final results = await Future.wait([
        _api.orderReport(months: window),
        _api.salesReport(months: window),
      ]);

      report.value = results[0] as OrderReportModel;
      products.assignAll(results[1] as List<ProductSalesModel>);
    } catch (failure) {
      error.value = failure.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
