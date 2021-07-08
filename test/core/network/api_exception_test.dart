import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book_flutter/src/core/network/api_exception.dart';

void main() {
  test('extracts backend detail and status code', () {
    final exception = ApiException.fromDio(
      _dioException(data: {'detail': 'Recipe not found'}, statusCode: 404),
    );

    expect(exception.message, 'Recipe not found');
    expect(exception.statusCode, 404);
    expect(exception.toString(), 'Recipe not found');
  });

  test('uses title, text, Dio message, and connection fallback', () {
    expect(
      ApiException.fromDio(_dioException(data: {'title': 'Invalid'})).message,
      'Invalid',
    );
    expect(
      ApiException.fromDio(_dioException(data: 'Denied')).message,
      'Denied',
    );
    expect(
      ApiException.fromDio(_dioException(message: 'Timeout')).message,
      'Timeout',
    );
    expect(
      ApiException.fromDio(_dioException()).message,
      'Unable to connect to the server',
    );
  });
}

DioException _dioException({Object? data, int? statusCode, String? message}) {
  final request = RequestOptions(path: '/recipes');
  return DioException(
    requestOptions: request,
    response: data == null && statusCode == null
        ? null
        : Response<Object?>(
            requestOptions: request,
            data: data,
            statusCode: statusCode,
          ),
    message: message,
  );
}
