import 'dart:async';

import 'package:flutter/material.dart';
import 'package:recipe_book_flutter/src/app/app.dart';
import 'package:recipe_book_flutter/src/core/localization/localization.dart';
import 'package:recipe_book_flutter/src/core/navigation/app_routes.dart';
import 'package:recipe_book_flutter/src/core/widgets/content_width.dart';
import 'package:recipe_book_flutter/src/features/auth/presentation/auth_dialog.dart';
import 'package:recipe_book_flutter/src/features/recipes/domain/recipe.dart';
import 'package:recipe_book_flutter/src/features/recipes/presentation/controllers/recipe_feed_controller.dart';
import 'package:recipe_book_flutter/src/features/recipes/presentation/widgets/recipe_grid.dart';

class const RecipesScreen({final String initialQuery = '', super.key})
    extends StatefulWidget {
  @override
  State<RecipesScreen> createState() => _RecipesScreenState();
}

class _RecipesScreenState() extends State<RecipesScreen> {
  final _searchController = TextEditingController();
  RecipeFeedController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller != null) {
      return;
    }
    final String initialQuery = widget.initialQuery;
    _searchController.text = initialQuery;
    final controller = RecipeFeedController(
      AppScope.of(context).recipeRepository,
    );
    _controller = controller;
    unawaited(controller.loadInitial(query: initialQuery));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: ListenableBuilder(
            listenable: _controller!,
            builder: (context, _) => RefreshIndicator(
              onRefresh: _controller!.refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  ContentWidth(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SearchBar(
                          controller: _searchController,
                          hintText: context.l10n.catalogSearchHint,
                          leading: const Icon(Icons.search),
                          trailing: [
                            IconButton(
                              onPressed: () => _controller!.loadInitial(
                                query: _searchController.text,
                              ),
                              icon: const Icon(Icons.arrow_forward),
                            ),
                          ],
                          onSubmitted: (value) =>
                              _controller!.loadInitial(query: value),
                        ),
                        const SizedBox(height: 24),
                        if (_controller!.items.isEmpty &&
                            _controller!.isLoading)
                          const SizedBox(
                            height: 320,
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else if (_controller!.items.isEmpty)
                          _EmptyFeed(error: _controller!.error)
                        else ...[
                          RecipeGrid(
                            recipes: _controller!.items,
                            onFavorite: _toggleFavorite,
                            onLike: _toggleLike,
                            onChanged: () => unawaited(_controller!.refresh()),
                          ),
                          if (_controller!.error case final error?) ...[
                            const SizedBox(height: 16),
                            Text(error, textAlign: TextAlign.center),
                          ],
                          if (_controller!.hasMore) ...[
                            const SizedBox(height: 24),
                            Center(
                              child: OutlinedButton.icon(
                                onPressed: _controller!.isLoading
                                    ? null
                                    : _controller!.loadMore,
                                icon: _controller!.isLoading
                                    ? const SizedBox.square(
                                        dimension: 18,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const Icon(Icons.expand_more),
                                label: Text(context.l10n.showMore),
                              ),
                            ),
                          ],
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Positioned(
          right: 24,
          bottom: 24,
          child: FloatingActionButton.extended(
            onPressed: _addRecipe,
            icon: const Icon(Icons.add),
            label: Text(context.l10n.addRecipe),
          ),
        ),
      ],
    );
  }

  Future<bool> _ensureAuth() async =>
      AuthScope.of(context, listen: false).isAuthenticated ||
      await showAuthDialog(context);

  Future<void> _toggleFavorite(Recipe recipe) async {
    try {
      if (await _ensureAuth() && mounted) {
        await _controller!.toggleFavorite(recipe);
      }
    } on Object catch (error) {
      _showError(error);
    }
  }

  Future<void> _toggleLike(Recipe recipe) async {
    try {
      if (await _ensureAuth() && mounted) {
        await _controller!.toggleLike(recipe);
      }
    } on Object catch (error) {
      _showError(error);
    }
  }

  Future<void> _addRecipe() async {
    try {
      if (await _ensureAuth() && mounted) {
        await Navigator.pushNamed(context, AppRoutes.recipeNew);
        await _controller!.refresh();
      }
    } on Object catch (error) {
      _showError(error);
    }
  }

  void _showError(Object error) {
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(error.toString())));
    }
  }
}

class const _EmptyFeed({final String? error}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: Center(
        child: Text(
          error ?? context.l10n.recipesNotFound,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
    );
  }
}
