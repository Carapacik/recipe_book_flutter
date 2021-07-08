import 'package:recipe_book_flutter/src/core/network/api_client.dart';
import 'package:recipe_book_flutter/src/core/storage/token_storage.dart';

abstract interface class AuthDataSource() {
  bool get hasToken;

  Future<void> login({required String email, required String password});

  Future<void> register({
    required String name,
    required String email,
    required String password,
  });

  Future<void> validate();

  Future<void> logout();
}

class const AuthRepository(
  final ApiGateway _apiClient,
  final TokenStorage _tokenStorage,
) implements AuthDataSource {
  @override
  bool get hasToken => _tokenStorage.token != null;

  @override
  Future<void> login({required String email, required String password}) async {
    final Map<String, dynamic> data = await _apiClient
        .post<Map<String, dynamic>>(
          'auth/login',
          data: {'email': email, 'password': password},
        );
    await _saveAccessToken(data, email: email);
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final Map<String, dynamic> data = await _apiClient
        .post<Map<String, dynamic>>(
          'auth/register',
          data: {'name': name, 'email': email, 'password': password},
        );
    await _saveAccessToken(data, email: email);
  }

  @override
  Future<void> validate() => _apiClient.get<dynamic>('auth/validate');

  @override
  Future<void> logout() => _tokenStorage.clear();

  Future<void> _saveAccessToken(
    Map<String, dynamic> data, {
    required String email,
  }) async {
    final token = data['accessToken'] as String?;
    if (token == null || token.isEmpty) {
      throw const FormatException('The server did not return an access token.');
    }
    await _tokenStorage.saveCredentials(token: token, email: email);
  }
}
