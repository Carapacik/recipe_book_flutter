import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:recipe_book_flutter/src/core/config/app_config.dart';
import 'package:recipe_book_flutter/src/core/network/api_exception.dart';
import 'package:recipe_book_flutter/src/core/storage/token_storage.dart';

abstract interface class ApiGateway() {
  Future<T> get<T>(String path, {Map<String, Object?>? queryParameters});

  Future<T> post<T>(String path, {Object? data});

  Future<T> put<T>(String path, {Object? data});

  Future<T> delete<T>(String path);

  Future<void> putVoid(String path, {Object? data});

  Future<void> deleteVoid(String path);
}

class ApiClient(final TokenStorage _tokenStorage) implements ApiGateway {
  this
    : _dio = Dio(
        BaseOptions(
          baseUrl: AppConfig.apiBaseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 20),
          sendTimeout: const Duration(seconds: 20),
          headers: const {'Accept': 'application/json'},
        ),
      ) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final String? token = _tokenStorage.token;
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          if (kDebugMode) {
            log('${options.method} ${options.uri}', name: 'RecipeBook API');
          }
          handler.next(options);
        },
      ),
    );
  }

  final Dio _dio;

  @visibleForTesting
  Dio get testingDio => _dio;

  @override
  Future<T> get<T>(String path, {Map<String, Object?>? queryParameters}) =>
      _request(() => _dio.get<T>(path, queryParameters: queryParameters));

  @override
  Future<T> post<T>(String path, {Object? data}) =>
      _request(() => _dio.post<T>(path, data: data));

  @override
  Future<T> put<T>(String path, {Object? data}) =>
      _request(() => _dio.put<T>(path, data: data));

  @override
  Future<T> delete<T>(String path) => _request(() => _dio.delete<T>(path));

  @override
  Future<void> putVoid(String path, {Object? data}) =>
      _requestVoid(() => _dio.put<void>(path, data: data));

  @override
  Future<void> deleteVoid(String path) =>
      _requestVoid(() => _dio.delete<void>(path));

  Future<T> _request<T>(Future<Response<T>> Function() request) async {
    try {
      final Response<T> response = await request();
      return response.data as T;
    } on DioException catch (exception) {
      throw ApiException.fromDio(exception);
    }
  }

  Future<void> _requestVoid(Future<Response<void>> Function() request) async {
    try {
      await request();
    } on DioException catch (exception) {
      throw ApiException.fromDio(exception);
    }
  }
}
