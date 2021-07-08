import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book_flutter/src/core/network/api_client.dart';
import 'package:recipe_book_flutter/src/core/network/api_exception.dart';
import 'package:recipe_book_flutter/src/core/storage/token_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('sends token, query, and data for every request method', () async {
    SharedPreferences.setMockInitialValues({});
    final TokenStorage storage = await TokenStorage.create();
    await storage.saveCredentials(
      token: 'jwt-token',
      email: 'chef@example.com',
    );
    final client = ApiClient(storage);
    final adapter = _HttpAdapter();
    client.testingDio.httpClientAdapter = adapter;

    expect(
      await client.get<Map<String, dynamic>>(
        'recipes',
        queryParameters: {'skip': 2},
      ),
      {'ok': true},
    );
    expect(adapter.options?.method, 'GET');
    expect(adapter.options?.queryParameters, {'skip': 2});
    expect(adapter.options?.headers['Authorization'], 'Bearer jwt-token');

    await client.post<Map<String, dynamic>>('recipes', data: {'title': 'Soup'});
    expect(adapter.options?.method, 'POST');
    expect(adapter.options?.data, {'title': 'Soup'});
    await client.put<Map<String, dynamic>>(
      'recipes/1',
      data: {'title': 'Stew'},
    );
    expect(adapter.options?.method, 'PUT');
    await client.delete<Map<String, dynamic>>('recipes/1');
    expect(adapter.options?.method, 'DELETE');
  });

  test('accepts empty 204 responses for void mutations', () async {
    SharedPreferences.setMockInitialValues({});
    final client = ApiClient(await TokenStorage.create());
    final adapter = _HttpAdapter()..statusCode = 204;
    client.testingDio.httpClientAdapter = adapter;

    await client.putVoid('recipes/1/like');
    expect(adapter.options?.method, 'PUT');
    await client.deleteVoid('recipes/1/favorite');
    expect(adapter.options?.method, 'DELETE');
  });

  test('converts Dio failures to ApiException', () async {
    SharedPreferences.setMockInitialValues({});
    final client = ApiClient(await TokenStorage.create());
    final adapter = _HttpAdapter()
      ..statusCode = 400
      ..body = {'detail': 'Invalid recipe'};
    client.testingDio.httpClientAdapter = adapter;

    expect(
      () => client.get<Map<String, dynamic>>('recipes/0'),
      throwsA(
        isA<ApiException>()
            .having((error) => error.message, 'message', 'Invalid recipe')
            .having((error) => error.statusCode, 'statusCode', 400),
      ),
    );
    expect(
      () => client.putVoid('recipes/0/like'),
      throwsA(isA<ApiException>()),
    );
  });
}

class _HttpAdapter() implements HttpClientAdapter {
  int statusCode = 200;
  Object body = const {'ok': true};
  RequestOptions? options;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    this.options = options;
    final String encodedBody = statusCode == 204 ? '' : jsonEncode(body);
    return ResponseBody.fromString(
      encodedBody,
      statusCode,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}
