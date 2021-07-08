import 'package:flutter/material.dart';
import 'package:recipe_book_flutter/src/core/layout/window_size_class.dart';
import 'package:recipe_book_flutter/src/features/recipes/domain/recipe.dart';
import 'package:recipe_book_flutter/src/features/recipes/presentation/widgets/recipe_card.dart';

class const RecipeGrid({
  required final List<Recipe> recipes,
  final ValueChanged<Recipe>? onFavorite,
  final ValueChanged<Recipe>? onLike,
  final VoidCallback? onChanged,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: recipes.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: AppBreakpoints.gridColumns(constraints.maxWidth),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.78,
        ),
        itemBuilder: (_, index) {
          final Recipe recipe = recipes[index];
          return RecipeCard(
            recipe: recipe,
            onFavorite: onFavorite == null ? null : () => onFavorite!(recipe),
            onLike: onLike == null ? null : () => onLike!(recipe),
            onChanged: onChanged,
          );
        },
      ),
    );
  }
}
