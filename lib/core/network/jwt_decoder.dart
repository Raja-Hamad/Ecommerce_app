import 'dart:convert';

class JwtDecoder {
  JwtDecoder._();

  /// Decodes a JWT's payload segment without verifying its signature.
  /// Sufficient for reading claims (userId, role, exp) already trusted
  /// because the token itself came from our backend over the login response.
  static Map<String, dynamic> payload(String token) {
    final parts = token.split('.');
    if (parts.length != 3) throw const FormatException('Invalid JWT format');
    final normalized = base64Url.normalize(parts[1]);
    final decoded = utf8.decode(base64Url.decode(normalized));
    return jsonDecode(decoded) as Map<String, dynamic>;
  }

  static bool isExpired(String token) {
    try {
      final exp = payload(token)['exp'] as int?;
      if (exp == null) return false;
      return DateTime.now().millisecondsSinceEpoch ~/ 1000 >= exp;
    } catch (_) {
      return true;
    }
  }
}
