import '../../../app/data/services/auth_storage.dart';

/// Parses a Laravel login / OTP response and persists the session when a
/// token was returned.
///
/// Returns:
/// true  = valid token received and session saved.
/// false = request succeeded but no token was returned, usually because
///         dealer approval is pending.
class AuthSessionSaver {
  AuthSessionSaver(this._storage);

  final AuthStorage _storage;

  Future<bool> saveFromResponse(
    Map<String, dynamic> response, {
    String fallbackMobile = '',
    String fallbackEmail = '',
    String fallbackName = 'Dealer',
  }) async {
    final rawData = response['data'] ?? response;

    if (rawData is! Map) {
      throw const FormatException(
        'Invalid response received from server.',
      );
    }

    final data = Map<String, dynamic>.from(rawData);

    final rawUser = data['user'];

    final user = rawUser is Map
        ? Map<String, dynamic>.from(rawUser)
        : <String, dynamic>{};

    final token =
        (data['token'] ?? data['access_token'])?.toString().trim() ?? '';

    // No token is valid for a newly registered dealer waiting for admin
    // approval.
    if (token.isEmpty) {
      return false;
    }

    final serverName = user['name']?.toString().trim() ?? '';
    final serverMobile = user['mobile']?.toString().trim() ?? '';
    final serverEmail = user['email']?.toString().trim() ?? '';

    final name = serverName.isNotEmpty ? serverName : fallbackName;

    final savedMobile =
        serverMobile.isNotEmpty ? serverMobile : fallbackMobile.trim();

    final savedEmail =
        serverEmail.isNotEmpty ? serverEmail : fallbackEmail.trim();

    await _storage.saveSession(
      token: token,
      name: name,
      mobile: savedMobile,
      email: savedEmail,
    );

    return true;
  }
}
