import 'package:flutter/foundation.dart';

/// Backend endpoint catalogue for the dealer (B2B) app.
///
/// The host is supplied at build time (`--dart-define=API_BASE_URL=...`) so a
/// staging build never ships pointing at production, and vice versa.
class ApiConfig {
  ApiConfig._();

  // Android emulator: http://10.0.2.2:8000/api/v1
  // Physical device: your PC/server IP, or the live domain below.
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://drbawasakar.turnkeyinfotech.live/api/v1',
  );

  static const int timeoutSeconds = 30;

  /// Refuses to start a release build that would send bearer tokens over
  /// plaintext HTTP. Debug builds may still target a local `http://` server.
  static void assertSecureBaseUrl() {
    if (kReleaseMode && !baseUrl.startsWith('https://')) {
      throw StateError(
        'Insecure API_BASE_URL "$baseUrl": release builds require HTTPS.',
      );
    }
  }

  // --- Auth -----------------------------------------------------------------
  static const String requestOtp = '/auth/otp/request';
  static const String verifyDealerOtp = '/auth/dealer/otp/verify';
  static const String registerDealer = '/auth/dealer/register';
  static const String emailLogin = '/auth/dealer/login';
  static const String logout = '/auth/logout';

  // --- Public catalogue -----------------------------------------------------
  static const String categories = '/catalog/categories';
  static const String products = '/catalog/products';
  static const String homepage = '/catalog/homepage';
  static const String appTranslations = '/app-translations';
  static const String appTranslationsRegister = '/app-translations/register';

  // --- Account --------------------------------------------------------------
  static const String dealerDashboard = '/dealer/dashboard';
  static const String dealerProfile = '/dealer/profile';
  static const String profilePhoto = '/dealer/profile/photo';
  static const String dealerStatements = '/dealer/statements';
  static const String dealerAddresses = '/dealer/addresses';
  static const String dealerSupport = '/dealer/support';
  static const String dealerOrders = '/dealer/orders';
  static const String changePassword = '/dealer/change-password';

  static String dealerOrder(int id) => '/dealer/orders/$id';
  static String dealerOrderCancel(int id) => '/dealer/orders/$id/cancel';
  static String dealerAddress(int id) => '/dealer/addresses/$id';

  // --- Outstanding & credit -------------------------------------------------
  static const String outstanding = '/dealer/outstanding';
  static const String creditLimit = '/dealer/credit-limit';
  static const String ledger = '/dealer/ledger';
  static const String payments = '/dealer/payments';

  // --- Order tracking, invoices, returns ------------------------------------
  static String orderTracking(int orderId) => '/dealer/orders/$orderId/tracking';
  static const String invoices = '/dealer/invoices';
  static String invoice(int id) => '/dealer/invoices/$id';
  static String invoicePdf(int id) => '/dealer/invoices/$id/pdf';
  static const String returns = '/dealer/returns';
  static String returnRequest(int id) => '/dealer/returns/$id';

  // --- Notifications --------------------------------------------------------
  static const String notifications = '/dealer/notifications';
  static const String notificationsRead = '/dealer/notifications/read';

  // --- Reports --------------------------------------------------------------
  static const String salesReport = '/dealer/reports/sales';
  static const String orderReport = '/dealer/reports/orders';

  // --- Support --------------------------------------------------------------
  static const String supportTickets = '/dealer/support/tickets';
  static String supportTicket(int id) => '/dealer/support/tickets/$id';
}
