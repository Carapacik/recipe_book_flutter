import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book_flutter/src/features/recipes/domain/recipe.dart';

void main() {
  test('parses the current backend detail contract', () {
    final recipe = Recipe.fromJson({
      'recipeId': 42,
      'title': 'Сырники',
      'description': 'Домашний завтрак',
      'imageUrl': 'image.webp',
      'imageUrls': ['image.webp', 'detail.webp'],
      'cookingTimeInMinutes': 25,
      'portionsCount': 3,
      'likesCount': 7,
      'favoritesCount': 4,
      'authorName': 'Роман',
      'isLiked': true,
      'isFavorite': false,
      'tags': ['завтрак'],
      'steps': ['Смешать', 'Обжарить'],
      'ingredients': [
        {
          'title': 'Основа',
          'ingredientNames': ['Творог', 'Яйцо'],
        },
      ],
    });

    expect(recipe.id, 42);
    expect(recipe.author, 'Роман');
    expect(recipe.imageUrls, ['image.webp', 'detail.webp']);
    expect(recipe.steps, hasLength(2));
    expect(recipe.ingredients.single.names, ['Творог', 'Яйцо']);
  });

  test('uses safe defaults and image fallbacks for partial responses', () {
    final fromImages = Recipe.fromJson({
      'imageUrls': ['', 'gallery.jpg', 3],
      'author': 'Legacy author',
      'tags': ['tag', 2],
      'steps': ['step', false],
      'ingredients': [
        {
          'title': 'Base',
          'ingredientNames': ['Water', 1],
        },
        'ignored',
      ],
    });
    expect(fromImages.imageUrl, 'gallery.jpg');
    expect(fromImages.imageUrls, ['gallery.jpg']);
    expect(fromImages.author, 'Legacy author');
    expect(fromImages.tags, ['tag']);
    expect(fromImages.steps, ['step']);
    expect(fromImages.ingredients.single.title, 'Base');

    final empty = Recipe.fromJson(const {});
    expect(empty.id, 0);
    expect(empty.imageUrl, isEmpty);
    expect(empty.imageUrls, isEmpty);
    expect(empty.author, 'Author');
  });

  test('copyWith changes only rating state', () {
    final recipe = Recipe.fromJson({
      'recipeId': 1,
      'title': 'Soup',
      'likesCount': 2,
      'favoritesCount': 1,
    });

    final Recipe changed = recipe.copyWith(
      likes: 3,
      favorites: 2,
      isLiked: true,
      isFavorite: true,
    );

    expect(changed.title, recipe.title);
    expect(changed.likes, 3);
    expect(changed.favorites, 2);
    expect(changed.isLiked, isTrue);
    expect(changed.isFavorite, isTrue);
    expect(recipe.copyWith().likes, recipe.likes);
  });
}
