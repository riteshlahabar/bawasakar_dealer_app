import '../../../app/data/services/dealer_api_service.dart';
import 'auth_session_saver.dart';
import 'otp_verify_result.dart';
import '../../../app/localization/t.dart';

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

  /// Verifies the OTP.
  ///
  /// Registered dealer: logged in, or approval still pending.
  /// New number: the server returns a registration token instead, and the
  /// app continues to the firm-details form.
  Future<OtpVerifyResult> verifyOtp({
    required String mobile,
    required String otp,
  }) async {
    final response = await _api.verifyOtp(mobile: mobile, otp: otp);

    final data = response['data'];

    if (data is Map && data['registration_required'] == true) {
      final token = data['registration_token']?.toString().trim() ?? '';

      if (token.isEmpty) {
        throw FormatException(t('common.invalid_server_response'));
      }

      return OtpVerifyResult(
        OtpVerifyStatus.registrationRequired,
        registrationToken: token,
      );
    }

    final loggedIn = await _sessionSaver.saveFromResponse(
      response,
      fallbackMobile: mobile,
    );

    return OtpVerifyResult(
      loggedIn ? OtpVerifyStatus.loggedIn : OtpVerifyStatus.approvalPending,
    );
  }

  /// Registration step 3: attaches firm details to the verified mobile.
  ///
  /// Returns true when the dealer is already approved and logged in; false
  /// when the registration is waiting for admin approval.
  Future<bool> registerDealer({
    required String registrationToken,
    required String mobile,
    required String name,
    required String firmName,
    required String gstNumber,
    Map<String, dynamic> location = const {},
  }) async {
    final response = await _api.registerDealer(
      registrationToken: registrationToken,
      name: name,
      firmName: firmName,
      gstNumber: gstNumber,
      location: location,
    );

    return _sessionSaver.saveFromResponse(
      response,
      fallbackMobile: mobile,
      fallbackName: name,
    );
  }
}
