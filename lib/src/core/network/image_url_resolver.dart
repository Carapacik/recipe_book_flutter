import 'package:recipe_book_flutter/src/core/config/app_config.dart';

abstract final class ImageUrlResolver() {
  static String resolve(String imagePath) {
    final Uri? direct = Uri.tryParse(imagePath);
    if (direct?.hasScheme ?? false) {
      return imagePath;
    }
    final Uri base = Uri.parse(AppConfig.apiBaseUrl);
    if (imagePath.startsWith('/')) {
      return base.replace(path: imagePath).toString();
    }
    return base.resolve('storage/images/$imagePath').toString();
  }
}
