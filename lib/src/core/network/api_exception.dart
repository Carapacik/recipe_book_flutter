import 'package:dio/dio.dart';

class const ApiException(final String message, {final int? statusCode})
    implements Exception {
  factory fromDio(DioException exception) {
    final Object? data = exception.response?.data;
    final String message = switch (data) {
      {'detail': final String detail} => detail,
      {'title': final String title} => title,
      final String text when text.isNotEmpty => text,
      _ => exception.message ?? 'Unable to connect to the server',
    };

    return ApiException(message, statusCode: exception.response?.statusCode);
  }

  @override
  String toString() => message;
}
