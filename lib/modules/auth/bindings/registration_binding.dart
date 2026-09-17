import 'package:get/get.dart';

import '../../../app/data/services/api_client.dart';
import '../../location/controllers/location_form_controller.dart';
import '../../location/services/location_api_service.dart';
import '../controllers/registration_controller.dart';
import '../services/otp_auth_service.dart';
import 'auth_binding.dart';

class RegistrationBinding extends AuthBinding {
  @override
  void dependencies() {
    super.dependencies();
    Get.lazyPut<LocationApiService>(() => LocationApiService(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<LocationFormController>(() => LocationFormController(Get.find<LocationApiService>()));
    Get.lazyPut<RegistrationController>(() => RegistrationController(Get.find<OtpAuthService>(), Get.find<LocationFormController>()));
  }
}
