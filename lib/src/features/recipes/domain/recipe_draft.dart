import 'dart:typed_data';

import 'package:recipe_book_flutter/src/features/recipes/domain/ingredient.dart';

class const RecipeDraft({
  required final String title,
  required final String description,
  required final int cookingTime,
  required final int portions,
  required final List<String> tags,
  required final List<String> steps,
  required final List<Ingredient> ingredients,
  final List<RecipeImageDraft> images = const [],
});

class const RecipeImageDraft({
  required final Uint8List bytes,
  required final String name,
});
