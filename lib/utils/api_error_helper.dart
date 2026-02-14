/// Converts API/network exceptions into short, kid-safe messages for the UI.
/// Never exposes server details, status codes, or raw exception text.
class ApiErrorHelper {
  ApiErrorHelper._();

  /// Returns a user-friendly message. Use this whenever an API call fails
  /// and you need to show an error to the user (e.g. kids app).
  static String userMessage(dynamic e) {
    if (e == null) return 'Something went wrong. Please try again.';
    final message = e.toString().toLowerCase();

    // Network / connection / timeout / server unreachable
    if (message.contains('timeout') ||
        message.contains('connection') ||
        message.contains('socket') ||
        message.contains('network') ||
        message.contains('dioexception') ||
        message.contains('connection refused') ||
        message.contains('connection reset') ||
        message.contains('failed host lookup') ||
        message.contains('no internet') ||
        message.contains('handshake') ||
        message.contains('certificate') ||
        message.contains('statuscode') ||
        message.contains(' 500') ||
        message.contains(' 502') ||
        message.contains(' 503') ||
        message.contains(' 504') ||
        message.contains('failed to load')) {
      return 'Network error';
    }

    return 'Something went wrong. Please try again.';
  }
}
