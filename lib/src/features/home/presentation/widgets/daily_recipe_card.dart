import 'package:flutter/material.dart';
import 'package:recipe_book_flutter/src/core/layout/window_size_class.dart';
import 'package:recipe_book_flutter/src/core/localization/localization.dart';
import 'package:recipe_book_flutter/src/core/navigation/app_routes.dart';
import 'package:recipe_book_flutter/src/core/widgets/app_network_image.dart';
import 'package:recipe_book_flutter/src/features/recipes/domain/recipe.dart';

class const DailyRecipeCard({required final Recipe recipe, super.key})
    extends StatelessWidget {
  static const ValueKey<String> layoutKey = ValueKey('daily-recipe-layout');
  static const ValueKey<String> imageKey = ValueKey('daily-recipe-image');

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () => Navigator.pushNamed(context, AppRoutes.recipe(recipe.id)),
        child: LayoutBuilder(
          key: layoutKey,
          builder: (context, constraints) {
            final bool horizontal =
                constraints.maxWidth >= AppBreakpoints.compact;
            final Widget image = SizedBox(
              key: imageKey,
              width: horizontal ? constraints.maxWidth * 0.44 : double.infinity,
              height: horizontal ? 320 : 220,
              child: AppNetworkImage(imagePath: recipe.imageUrl),
            );
            final Widget description = Padding(
              padding: const EdgeInsets.all(28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.title,
                    style: Theme.of(context).textTheme.headlineSmall
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    recipe.description,
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 18),
                  Text(
                    context.l10n.dailyRecipeMeta(
                      recipe.cookingTime,
                      recipe.likes,
                    ),
                  ),
                ],
              ),
            );
            return horizontal
                ? SizedBox(
                    height: 320,
                    child: Row(
                      children: [
                        image,
                        Expanded(child: description),
                      ],
                    ),
                  )
                : Column(children: [image, description]);
          },
        ),
      ),
    );
  }
}
