import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book_flutter/src/core/config/app_config.dart';

void main() {
  test('uses local backend URL on desktop', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.windows;
    try {
      expect(AppConfig.apiBaseUrl, 'http://localhost:5110/api/');
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });

  test('uses Android emulator loopback address', () {
    debugDefaultTargetPlatformOverride = TargetPlatform.android;
    try {
      expect(AppConfig.apiBaseUrl, 'http://10.0.2.2:5110/api/');
    } finally {
      debugDefaultTargetPlatformOverride = null;
    }
  });
}
