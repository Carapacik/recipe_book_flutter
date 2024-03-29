import 'package:json_annotation/json_annotation.dart';
import 'package:recipe_book_flutter/model/ingredient.dart';

part 'recipe_detail.g.dart';

@JsonSerializable()
class RecipeDetail {
  const RecipeDetail({
    required this.recipeId,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.cookingTimeInMinutes,
    required this.portionsCount,
    required this.likesCount,
    required this.favoritesCount,
    required this.username,
    required this.isLiked,
    required this.isFavorite,
    required this.tags,
    required this.steps,
    required this.ingredients,
  });

  factory RecipeDetail.fromJson(Map<String, dynamic> json) =>
      _$RecipeDetailFromJson(json);

  final int recipeId;
  final String title;
  final String description;
  final String imageUrl;
  final int cookingTimeInMinutes;
  final int portionsCount;
  final int likesCount;
  final int favoritesCount;
  final bool isLiked;
  final bool isFavorite;
  final String username;
  final List<String> tags;
  final List<String> steps;
  final List<Ingredient> ingredients;

  Map<String, dynamic> toJson() => _$RecipeDetailToJson(this);
}
