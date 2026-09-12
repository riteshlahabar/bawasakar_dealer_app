import 'package:get/get.dart';

import '../../../app/data/services/api_client.dart';
import '../../../app/data/services/auth_storage.dart';
import '../../../app/data/services/dealer_api_service.dart';
import '../controllers/auth_controller.dart';
import '../services/auth_session_saver.dart';
import '../services/email_auth_service.dart';
import '../services/otp_auth_service.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ApiClient>(() => ApiClient(Get.find<AuthStorage>()), fenix: true);
    Get.lazyPut<DealerApiService>(() => DealerApiService(Get.find<ApiClient>()), fenix: true);
    Get.lazyPut<AuthSessionSaver>(() => AuthSessionSaver(Get.find<AuthStorage>()), fenix: true);
    Get.lazyPut<OtpAuthService>(() => OtpAuthService(Get.find<DealerApiService>(), Get.find<AuthSessionSaver>()), fenix: true);
    Get.lazyPut<EmailAuthService>(() => EmailAuthService(Get.find<DealerApiService>(), Get.find<AuthSessionSaver>()), fenix: true);
    Get.lazyPut<AuthController>(() => AuthController(Get.find<OtpAuthService>(), Get.find<EmailAuthService>()), fenix: true);
  }
}
