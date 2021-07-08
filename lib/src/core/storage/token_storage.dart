import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage._(final SharedPreferences _preferences) {
  static const _tokenKey = 'access_token';
  static const _emailKey = 'account_email';

  static Future<TokenStorage> create() async =>
      TokenStorage._(await SharedPreferences.getInstance());

  String? get token => _preferences.getString(_tokenKey);

  String? get email => _preferences.getString(_emailKey) ?? _emailFromToken;

  String? get _emailFromToken {
    final String? accessToken = token;
    if (accessToken == null) {
      return null;
    }
    try {
      final List<String> parts = accessToken.split('.');
      if (parts.length != 3) {
        return null;
      }
      final Object? payload = jsonDecode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      );
      if (payload is! Map<String, dynamic>) {
        return null;
      }
      const emailClaim =
          'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress';
      return payload['email'] as String? ?? payload[emailClaim] as String?;
    } on Object {
      return null;
    }
  }

  Future<void> saveCredentials({
    required String token,
    required String email,
  }) async {
    await _preferences.setString(_tokenKey, token);
    await _preferences.setString(_emailKey, email);
  }

  Future<void> saveEmail(String email) async {
    await _preferences.setString(_emailKey, email);
  }

  Future<void> clear() async {
    await _preferences.remove(_tokenKey);
    await _preferences.remove(_emailKey);
  }
}
