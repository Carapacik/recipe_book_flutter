import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book_flutter/src/core/config/app_config.dart';
import 'package:recipe_book_flutter/src/core/network/image_url_resolver.dart';

void main() {
  test('keeps absolute image URLs unchanged', () {
    expect(
      ImageUrlResolver.resolve('https://cdn.example.com/image.jpg'),
      'https://cdn.example.com/image.jpg',
    );
  });

  test('resolves backend-root and storage image paths', () {
    final Uri base = Uri.parse(AppConfig.apiBaseUrl);
    expect(
      ImageUrlResolver.resolve('/storage/images/root.jpg'),
      base.replace(path: '/storage/images/root.jpg').toString(),
    );
    expect(
      ImageUrlResolver.resolve('relative.jpg'),
      base.resolve('storage/images/relative.jpg').toString(),
    );
  });
}
