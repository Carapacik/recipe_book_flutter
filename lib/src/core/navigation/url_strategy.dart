import 'package:recipe_book_flutter/src/core/navigation/url_strategy_stub.dart'
    if (dart.library.js_interop) 'package:recipe_book_flutter/src/core/navigation/url_strategy_web.dart';

void configureUrlStrategy() {
  configurePlatformUrlStrategy();
}
