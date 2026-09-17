import '../localization/app_locales.dart';

/// Reads display values out of the loosely-typed profile API payload.
class ProfileFields {
  ProfileFields._();

  /// Same six languages the app itself offers, so the saved preference and the
  /// app language can never disagree.
  static const languages = AppLocales.englishNames;

  static Map<String, dynamic> map(dynamic value) => value is Map ? Map<String, dynamic>.from(value) : const {};

  static String text(dynamic value) {
    final text = value?.toString().trim() ?? '';
    return text == 'null' ? '' : text;
  }

  /// Accounts created by mobile OTP carry a placeholder email; hide it.
  static String realEmail(String email) => email.toLowerCase().endsWith('.bawaskar.local') ? '' : email;

  static Map<String, dynamic> defaultAddress(dynamic addresses) {
    if (addresses is! List) return const {};
    final list = addresses.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
    if (list.isEmpty) return const {};

    return list.firstWhere((item) => item['is_default'] == true || item['is_default'] == 1, orElse: () => list.first);
  }

  static String addressLine(Map<String, dynamic> address) {
    return [
      text(address['address_line1']),
      text(address['address_line2']),
      text(address['city']),
      text(address['state']),
      text(address['pincode']),
    ].where((part) => part.isNotEmpty).join(', ');
  }
}
