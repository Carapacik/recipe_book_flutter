import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book_flutter/src/features/profile/domain/profile.dart';

void main() {
  test('parses the email returned by the backend', () {
    final profile = Profile.fromJson({
      'name': 'Chef',
      'login': 'chef@example.com',
      'description': 'Home cook',
      'recipesCount': 1,
      'likesCount': 2,
      'favoritesCount': 3,
    });

    expect(profile.email, 'chef@example.com');
  });

  test('parses login and defaults for a partial profile', () {
    final profile = Profile.fromJson({
      'login': 'cook@example.com',
      'recipesCount': 2.0,
    });

    expect(profile.name, isEmpty);
    expect(profile.email, 'cook@example.com');
    expect(profile.description, isEmpty);
    expect(profile.recipesCount, 2);
    expect(profile.likesCount, 0);
    expect(profile.favoritesCount, 0);
  });
}
