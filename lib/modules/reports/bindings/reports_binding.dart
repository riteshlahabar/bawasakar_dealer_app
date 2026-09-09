import 'package:get/get.dart';

import '../../../app/data/services/api_client.dart';
import '../../../app/data/services/dealer_report_api_service.dart';
import '../controllers/reports_controller.dart';

class ReportsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DealerReportApiService>(() => DealerReportApiService(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<ReportsController>(() => ReportsController(Get.find<DealerReportApiService>()));
  }
}
