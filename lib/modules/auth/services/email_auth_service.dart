import '../../../app/data/services/dealer_api_service.dart';
import 'auth_session_saver.dart';

/// Business logic for the dealer email/password login flow.
///
/// Laravel endpoint:
/// POST /api/v1/auth/dealer/login
class EmailAuthService {
  EmailAuthService(this._api, this._sessionSaver);

  final DealerApiService _api;
  final AuthSessionSaver _sessionSaver;

  Future<bool> login({
    required String email,
    required String password,
    required String fallbackName,
  }) async {
    final response = await _api.emailLogin(
      email: email,
      password: password,
    );

    return _sessionSaver.saveFromResponse(
      response,
      fallbackEmail: email,
      fallbackName: fallbackName,
    );
  }
}
