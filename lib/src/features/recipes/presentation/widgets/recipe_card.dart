import 'package:flutter/material.dart';
import 'package:recipe_book_flutter/src/core/localization/localization.dart';
import 'package:recipe_book_flutter/src/core/navigation/app_routes.dart';
import 'package:recipe_book_flutter/src/core/widgets/app_network_image.dart';
import 'package:recipe_book_flutter/src/features/recipes/domain/recipe.dart';

class const RecipeCard({
  required final Recipe recipe,
  final VoidCallback? onFavorite,
  final VoidCallback? onLike,
  final VoidCallback? onChanged,
  super.key,
}) extends StatefulWidget {
  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState() extends State<RecipeCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final TextStyle titleStyle =
        Theme.of(context).textTheme.titleMedium ?? const TextStyle();
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        scale: _hovered ? 1.018 : 1,
        child: Card(
          elevation: _hovered ? 4 : 0,
          child: InkWell(
            onTap: _openRecipe,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Hero(
                        tag: 'recipe-${widget.recipe.id}',
                        child: AppNetworkImage(
                          imagePath: widget.recipe.imageUrl,
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton.filledTonal(
                          tooltip: context.l10n.favoriteTooltip,
                          onPressed: widget.onFavorite,
                          icon: Icon(
                            widget.recipe.isFavorite
                                ? Icons.favorite
                                : Icons.favorite_border,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: titleStyle.copyWith(
                          fontVariations: [
                            FontVariation('wght', _hovered ? 760 : 650),
                          ],
                        ),
                        child: Text(
                          widget.recipe.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.recipe.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(Icons.schedule, size: 18),
                          const SizedBox(width: 4),
                          Text(context.l10n.minutes(widget.recipe.cookingTime)),
                          const Spacer(),
                          IconButton(
                            visualDensity: VisualDensity.compact,
                            tooltip: context.l10n.likeTooltip,
                            onPressed: widget.onLike,
                            icon: Icon(
                              widget.recipe.isLiked
                                  ? Icons.thumb_up
                                  : Icons.thumb_up_outlined,
                              size: 19,
                            ),
                          ),
                          Text('${widget.recipe.likes}'),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openRecipe() async {
    try {
      final Object? result = await Navigator.pushNamed(
        context,
        AppRoutes.recipe(widget.recipe.id),
      );
      if (result == true) {
        widget.onChanged?.call();
      }
    } on Object catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }
}
