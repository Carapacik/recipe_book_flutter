import 'dart:async';

import 'package:flutter/material.dart';
import 'package:recipe_book_flutter/src/app/app.dart';
import 'package:recipe_book_flutter/src/core/localization/localization.dart';
import 'package:recipe_book_flutter/src/core/widgets/content_width.dart';
import 'package:recipe_book_flutter/src/features/recipes/domain/recipe.dart';
import 'package:recipe_book_flutter/src/features/recipes/presentation/controllers/recipe_feed_controller.dart';
import 'package:recipe_book_flutter/src/features/recipes/presentation/widgets/recipe_grid.dart';

class const FavoritesScreen({super.key}) extends StatefulWidget {
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState() extends State<FavoritesScreen> {
  RecipeFeedController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller != null) {
      return;
    }
    final controller = RecipeFeedController(
      AppScope.of(context).recipeRepository,
      type: RecipeFeedType.favorites,
    );
    _controller = controller;
    unawaited(controller.loadInitial());
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _controller!,
      builder: (context, _) => RefreshIndicator(
        onRefresh: _controller!.refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            ContentWidth(
              child: _controller!.items.isEmpty
                  ? SizedBox(
                      height: 400,
                      child: Center(
                        child: _controller!.isLoading
                            ? const CircularProgressIndicator()
                            : Text(
                                _controller!.error ??
                                    context.l10n.favoritesEmpty,
                                textAlign: TextAlign.center,
                              ),
                      ),
                    )
                  : Column(
                      children: [
                        RecipeGrid(
                          recipes: _controller!.items,
                          onFavorite: _removeFavorite,
                          onLike: _controller!.toggleLike,
                          onChanged: () => unawaited(_controller!.refresh()),
                        ),
                        if (_controller!.hasMore) ...[
                          const SizedBox(height: 24),
                          OutlinedButton(
                            onPressed: _controller!.isLoading
                                ? null
                                : _controller!.loadMore,
                            child: Text(context.l10n.showMore),
                          ),
                        ],
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _removeFavorite(Recipe recipe) async {
    try {
      await _controller!.toggleFavorite(recipe);
      await _controller!.refresh();
    } on Object catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }
}
