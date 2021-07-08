import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book_flutter/src/core/storage/token_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('saves and clears credentials', () async {
    SharedPreferences.setMockInitialValues({});
    final TokenStorage storage = await TokenStorage.create();

    await storage.saveCredentials(
      token: 'access-token',
      email: 'chef@example.com',
    );
    expect(storage.token, 'access-token');
    expect(storage.email, 'chef@example.com');

    await storage.saveEmail('updated@example.com');
    expect(storage.token, 'access-token');
    expect(storage.email, 'updated@example.com');

    await storage.clear();
    expect(storage.token, isNull);
    expect(storage.email, isNull);
  });

  test('reads standard and Microsoft email claims from JWT payload', () async {
    final String standardToken = _token({'email': 'standard@example.com'});
    SharedPreferences.setMockInitialValues({'access_token': standardToken});
    expect((await TokenStorage.create()).email, 'standard@example.com');

    const claim =
        'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress';
    final String microsoftToken = _token({claim: 'claim@example.com'});
    SharedPreferences.setMockInitialValues({'access_token': microsoftToken});
    expect((await TokenStorage.create()).email, 'claim@example.com');
  });

  test('returns null for malformed JWT payloads', () async {
    for (final String token in [
      'invalid',
      'a.invalid.c',
      _token(const ['not-map']),
    ]) {
      SharedPreferences.setMockInitialValues({'access_token': token});
      expect((await TokenStorage.create()).email, isNull);
    }
  });
}

String _token(Object payload) {
  final String encoded = base64UrlEncode(utf8.encode(jsonEncode(payload)));
  return 'header.$encoded.signature';
}
