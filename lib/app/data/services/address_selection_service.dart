import 'package:get/get.dart';

import '../models/address_model.dart';
import 'dealer_api_service.dart';

/// Saved delivery addresses and the one chosen for this order, shared by the
/// cart's "Deliver to" strip and checkout.
class AddressSelectionService extends GetxService {
  AddressSelectionService(this._api);

  final DealerApiService _api;

  final addresses = <AddressModel>[].obs;
  final selected = Rxn<AddressModel>();

  Future<void> load() async {
    try {
      final list = await _api.addresses();
      final currentId = selected.value?.id;

      addresses.assignAll(list);
      selected.value = list.firstWhereOrNull((address) => address.id == currentId) ??
          list.firstWhereOrNull((address) => address.isDefault) ??
          (list.isEmpty ? null : list.first);
    } catch (_) {
      // Keep whatever is already shown.
    }
  }

  void select(AddressModel address) => selected.value = address;
}
