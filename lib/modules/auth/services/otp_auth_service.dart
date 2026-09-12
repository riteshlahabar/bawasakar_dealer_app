import '../../../app/data/services/dealer_api_service.dart';
import 'auth_session_saver.dart';

/// Business logic for the mobile-OTP dealer login / registration flow.
class OtpAuthService {
  OtpAuthService(this._api, this._sessionSaver);

  final DealerApiService _api;
  final AuthSessionSaver _sessionSaver;

  /// Request dealer OTP.
  ///
  /// Laravel endpoint:
  /// POST /api/v1/auth/otp/request
  Future<void> requestOtp(String mobile) {
    return _api.requestOtp(mobile);
  }

  /// Verifies the OTP and logs in / registers the dealer.
  ///
  /// New dealer: Laravel may return user without token until admin
  /// approval. Approved dealer: Laravel returns a token so the app can
  /// open the dealer dashboard.
  Future<bool> verifyOtp({
    required String mobile,
    required String otp,
    required String name,
    required String firmName,
    required String gstNumber,
    required String fallbackName,
  }) async {
    final response = await _api.verifyOtp(
      mobile: mobile,
      otp: otp,
      name: name,
      firmName: firmName,
      gstNumber: gstNumber,
    );

    return _sessionSaver.saveFromResponse(
      response,
      fallbackMobile: mobile,
      fallbackName: fallbackName,
    );
  }
}
