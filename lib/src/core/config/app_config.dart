import 'package:flutter/foundation.dart';

abstract final class AppConfig() {
  static const _definedApiBaseUrl = String.fromEnvironment('API_BASE_URL');

  static String get apiBaseUrl {
    if (_definedApiBaseUrl.isNotEmpty) {
      return _withTrailingSlash(_definedApiBaseUrl);
    }

    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:5110/api/';
    }

    return 'http://localhost:5110/api/';
  }

  static String _withTrailingSlash(String value) =>
      value.endsWith('/') ? value : '$value/';
}
