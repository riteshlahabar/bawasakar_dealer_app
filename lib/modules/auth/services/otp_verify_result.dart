/// Outcome of verifying a dealer OTP.
enum OtpVerifyStatus { loggedIn, approvalPending, registrationRequired }

class OtpVerifyResult {
  const OtpVerifyResult(this.status, {this.registrationToken = ''});

  final OtpVerifyStatus status;

  /// Short-lived server token proving the mobile was verified; sent with the
  /// registration form. Only set for [OtpVerifyStatus.registrationRequired].
  final String registrationToken;
}
