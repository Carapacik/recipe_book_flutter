import 'package:recipe_book_flutter/src/features/recipes/domain/ingredient.dart';

class const Recipe({
  required final int id,
  required final String title,
  required final String description,
  required final String imageUrl,
  required final List<String> imageUrls,
  required final int cookingTime,
  required final int portions,
  required final int likes,
  required final int favorites,
  required final String author,
  required final bool isLiked,
  required final bool isFavorite,
  required final List<String> tags,
  final List<String> steps = const [],
  final List<Ingredient> ingredients = const [],
}) {
  factory fromJson(Map<String, Object?> json) {
    final List<Object?> rawIngredients =
        json['ingredients'] as List<Object?>? ?? const [];
    final List<String> imageUrls =
        (json['imageUrls'] as List<Object?>? ?? const [])
            .whereType<String>()
            .where((url) => url.isNotEmpty)
            .toList(growable: false);
    final String imageUrl = json['imageUrl'] as String? ?? '';
    return Recipe(
      id: (json['recipeId'] as num?)?.toInt() ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: imageUrl.isNotEmpty ? imageUrl : imageUrls.firstOrNull ?? '',
      imageUrls: imageUrls.isNotEmpty
          ? imageUrls
          : imageUrl.isEmpty
          ? const []
          : [imageUrl],
      cookingTime: (json['cookingTimeInMinutes'] as num?)?.toInt() ?? 0,
      portions: (json['portionsCount'] as num?)?.toInt() ?? 0,
      likes: (json['likesCount'] as num?)?.toInt() ?? 0,
      favorites: (json['favoritesCount'] as num?)?.toInt() ?? 0,
      author:
          json['authorName'] as String? ??
          json['author'] as String? ??
          'Author',
      isLiked: json['isLiked'] as bool? ?? false,
      isFavorite: json['isFavorite'] as bool? ?? false,
      tags: (json['tags'] as List<Object?>? ?? const [])
          .whereType<String>()
          .toList(growable: false),
      steps: (json['steps'] as List<Object?>? ?? const [])
          .whereType<String>()
          .toList(growable: false),
      ingredients: rawIngredients
          .whereType<Map<String, Object?>>()
          .map(Ingredient.fromJson)
          .toList(growable: false),
    );
  }

  Recipe copyWith({
    int? likes,
    int? favorites,
    bool? isLiked,
    bool? isFavorite,
  }) => Recipe(
    id: id,
    title: title,
    description: description,
    imageUrl: imageUrl,
    imageUrls: imageUrls,
    cookingTime: cookingTime,
    portions: portions,
    likes: likes ?? this.likes,
    favorites: favorites ?? this.favorites,
    author: author,
    isLiked: isLiked ?? this.isLiked,
    isFavorite: isFavorite ?? this.isFavorite,
    tags: tags,
    steps: steps,
    ingredients: ingredients,
  );
}
