import 'package:get/get.dart';

import '../../../app/data/models/credit_model.dart';
import '../../../app/data/services/dealer_credit_api_service.dart';

/// Owns the credit position and the ledger behind it.
class OutstandingController extends GetxController {
  OutstandingController(this._api);

  final DealerCreditApiService _api;

  final credit = Rxn<CreditModel>();
  final ledger = <LedgerEntryModel>[].obs;
  final isLoading = false.obs;
  final error = ''.obs;

  @override
  void onInit() {
    load();
    super.onInit();
  }

  Future<void> load() async {
    isLoading.value = true;
    error.value = '';
    try {
      // Both halves of the screen come from one refresh, so a pull-to-refresh
      // cannot leave the gauge and the ledger disagreeing.
      final results = await Future.wait([
        _api.outstanding(),
        _api.ledger(),
      ]);

      credit.value = results[0] as CreditModel;
      ledger.assignAll(results[1] as List<LedgerEntryModel>);
    } catch (failure) {
      error.value = failure.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
