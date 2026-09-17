import 'package:get/get.dart';

import '../../../app/data/services/api_client.dart';
import '../../../app/data/services/dealer_api_service.dart';
import '../../location/controllers/location_form_controller.dart';
import '../../location/services/location_api_service.dart';
import '../controllers/edit_profile_controller.dart';
import '../controllers/profile_controller.dart';

/// DealerApiService and ProfileController come from MainShellBinding (fenix).
class EditProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocationApiService>(() => LocationApiService(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<LocationFormController>(() => LocationFormController(Get.find<LocationApiService>()));
    Get.lazyPut<EditProfileController>(
      () => EditProfileController(Get.find<DealerApiService>(), Get.find<ProfileController>(), Get.find<LocationFormController>()),
    );
  }
}
