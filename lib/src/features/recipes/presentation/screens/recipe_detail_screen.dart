import 'dart:async';

import 'package:flutter/material.dart';
import 'package:recipe_book_flutter/src/app/app.dart';
import 'package:recipe_book_flutter/src/core/layout/window_size_class.dart';
import 'package:recipe_book_flutter/src/core/localization/localization.dart';
import 'package:recipe_book_flutter/src/core/navigation/app_routes.dart';
import 'package:recipe_book_flutter/src/core/widgets/app_network_image.dart';
import 'package:recipe_book_flutter/src/core/widgets/content_width.dart';
import 'package:recipe_book_flutter/src/core/widgets/glass_page_app_bar.dart';
import 'package:recipe_book_flutter/src/core/widgets/glass_panel.dart';
import 'package:recipe_book_flutter/src/features/auth/presentation/auth_dialog.dart';
import 'package:recipe_book_flutter/src/features/recipes/data/recipe_repository.dart';
import 'package:recipe_book_flutter/src/features/recipes/domain/recipe.dart';
import 'package:recipe_book_flutter/src/features/recipes/presentation/controllers/recipe_detail_controller.dart';

class const RecipeDetailScreen({required final int recipeId, super.key})
    extends StatefulWidget {
  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState() extends State<RecipeDetailScreen> {
  RecipeDetailController? _controller;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_controller == null) {
      _controller = RecipeDetailController(
        AppScope.of(context).recipeRepository,
        recipeId: widget.recipeId,
      );
      unawaited(_controller!.load());
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlassPageAppBar(title: context.l10n.recipe),
      body: GlassBackground(
        child: ListenableBuilder(
          listenable: _controller!,
          builder: (context, child) {
            final RecipeDetailController controller = _controller!;
            final Recipe? recipe = controller.recipe;
            if (controller.isLoading && recipe == null) {
              return const Center(child: CircularProgressIndicator());
            }
            if (recipe == null) {
              return _ErrorState(
                message: controller.error ?? context.l10n.dailyUnavailable,
                onRetry: controller.load,
              );
            }
            return _RecipeDetail(
              recipe: recipe,
              isFavoriteChanging: controller.isFavoriteChanging,
              isLikeChanging: controller.isLikeChanging,
              isRatingChanging: controller.isRatingChanging,
              onFavorite: _toggleFavorite,
              onLike: _toggleLike,
              onEdit: () => _edit(recipe),
              onDelete: () => _delete(recipe),
            );
          },
        ),
      ),
    );
  }

  Future<bool> _ensureAuth() async =>
      AuthScope.of(context, listen: false).isAuthenticated ||
      await showAuthDialog(context);

  Future<void> _toggleFavorite() async {
    try {
      if (!await _ensureAuth()) {
        return;
      }
      final bool succeeded = await _controller!.toggleFavorite();
      if (!succeeded && _controller!.error != null) {
        _showError(_controller!.error!);
      }
    } on Object catch (error) {
      _showError(error);
    }
  }

  Future<void> _toggleLike() async {
    try {
      if (!await _ensureAuth()) {
        return;
      }
      final bool succeeded = await _controller!.toggleLike();
      if (!succeeded && _controller!.error != null) {
        _showError(_controller!.error!);
      }
    } on Object catch (error) {
      _showError(error);
    }
  }

  Future<void> _edit(Recipe recipe) async {
    try {
      if (!await _ensureAuth() || !mounted) {
        return;
      }
      await Navigator.pushNamed(context, AppRoutes.recipeEdit(recipe.id));
      await _controller!.load();
    } on Object catch (error) {
      _showError(error);
    }
  }

  Future<void> _delete(Recipe recipe) async {
    try {
      final RecipeRepository repository = AppScope.of(context).recipeRepository;
      if (!await _ensureAuth() || !mounted) {
        return;
      }
      final bool? confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(context.l10n.deleteRecipeTitle),
          content: Text(context.l10n.deleteRecipeMessage(recipe.title)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(context.l10n.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(context.l10n.delete),
            ),
          ],
        ),
      );
      if (confirmed != true) {
        return;
      }
      await repository.delete(recipe.id);
      if (mounted) {
        Navigator.pop(context, true);
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

class const _RecipeDetail({
  required final Recipe recipe,
  required final bool isFavoriteChanging,
  required final bool isLikeChanging,
  required final bool isRatingChanging,
  required final VoidCallback onFavorite,
  required final VoidCallback onLike,
  required final VoidCallback onEdit,
  required final VoidCallback onDelete,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final expanded =
        AppBreakpoints.widthClassOf(context) == WindowWidthClass.expanded;
    final gallery = _RecipeGallery(recipe: recipe);
    final summary = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          recipe.title,
          style: Theme.of(context).textTheme.displaySmall
              ?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 8),
        Text(context.l10n.authorLabel(recipe.author)),
        const SizedBox(height: 20),
        Text(recipe.description, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 20),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Chip(
              avatar: const Icon(Icons.schedule),
              label: Text(context.l10n.minutes(recipe.cookingTime)),
            ),
            Chip(
              avatar: const Icon(Icons.people_outline),
              label: Text(context.l10n.portionsCount(recipe.portions)),
            ),
            ...recipe.tags.map((tag) => Chip(label: Text('#$tag'))),
          ],
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          children: [
            FilledButton.tonalIcon(
              onPressed: isRatingChanging ? null : onLike,
              icon: isLikeChanging
                  ? const _ActionProgressIndicator()
                  : Icon(
                      recipe.isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                    ),
              label: Text('${recipe.likes}'),
            ),
            FilledButton.tonalIcon(
              onPressed: isRatingChanging ? null : onFavorite,
              icon: isFavoriteChanging
                  ? const _ActionProgressIndicator()
                  : Icon(
                      recipe.isFavorite
                          ? Icons.favorite
                          : Icons.favorite_border,
                    ),
              label: Text('${recipe.favorites}'),
            ),
            if (AuthScope.of(context).isAuthenticated)
              PopupMenuButton<String>(
                onSelected: (value) => value == 'edit' ? onEdit() : onDelete(),
                itemBuilder: (_) => [
                  PopupMenuItem(value: 'edit', child: Text(context.l10n.edit)),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text(context.l10n.delete),
                  ),
                ],
              ),
          ],
        ),
      ],
    );

    return SingleChildScrollView(
      child: ContentWidth(
        maxWidth: 1200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (expanded)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: gallery),
                  const SizedBox(width: 40),
                  Expanded(child: summary),
                ],
              )
            else ...[
              gallery,
              const SizedBox(height: 28),
              summary,
            ],
            const SizedBox(height: 48),
            _Ingredients(recipe: recipe),
            const SizedBox(height: 40),
            _Steps(recipe: recipe),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class const _RecipeGallery({required final Recipe recipe})
    extends StatefulWidget {
  @override
  State<_RecipeGallery> createState() => _RecipeGalleryState();
}

class _RecipeGalleryState() extends State<_RecipeGallery> {
  final PageController _pageController = PageController();
  final ValueNotifier<int> _indexNotifier = ValueNotifier(0);

  @override
  void dispose() {
    _pageController.dispose();
    _indexNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> images = widget.recipe.imageUrls.isEmpty
        ? [widget.recipe.imageUrl]
        : widget.recipe.imageUrls;
    return AspectRatio(
      aspectRatio: 4 / 3,
      child: ClipRSuperellipse(
        borderRadius: BorderRadius.circular(32),
        child: ListenableBuilder(
          listenable: _indexNotifier,
          builder: (context, child) {
            final int selectedIndex = _indexNotifier.value;
            return Stack(
              fit: StackFit.expand,
              children: [
                PageView.builder(
                  controller: _pageController,
                  itemCount: images.length,
                  onPageChanged: (index) => _indexNotifier.value = index,
                  itemBuilder: (context, index) {
                    final Widget image = AppNetworkImage(
                      imagePath: images[index],
                    );
                    return index == 0
                        ? Hero(tag: 'recipe-${widget.recipe.id}', child: image)
                        : image;
                  },
                ),
                if (images.length > 1)
                  Positioned(
                    left: 16,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: _GalleryArrow(
                        icon: Icons.arrow_back_ios_new,
                        tooltip: context.l10n.previousImage,
                        onPressed: selectedIndex == 0
                            ? null
                            : () => _showImage(selectedIndex - 1),
                      ),
                    ),
                  ),
                if (images.length > 1)
                  Positioned(
                    right: 16,
                    top: 0,
                    bottom: 0,
                    child: Center(
                      child: _GalleryArrow(
                        icon: Icons.arrow_forward_ios,
                        tooltip: context.l10n.nextImage,
                        onPressed: selectedIndex == images.length - 1
                            ? null
                            : () => _showImage(selectedIndex + 1),
                      ),
                    ),
                  ),
                if (images.length > 1)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 14,
                    child: Center(
                      child: GlassPanel(
                        blur: 16,
                        borderRadius: BorderRadius.circular(20),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            images.length,
                            (index) => Semantics(
                              button: true,
                              selected: index == selectedIndex,
                              child: InkWell(
                                customBorder: const CircleBorder(),
                                onTap: () => _showImage(index),
                                child: Padding(
                                  padding: const EdgeInsets.all(7),
                                  child: AnimatedScale(
                                    duration: const Duration(milliseconds: 220),
                                    scale: index == selectedIndex ? 1.35 : 1,
                                    child: SizedBox.square(
                                      dimension: 7,
                                      child: DecoratedBox(
                                        decoration: BoxDecoration(
                                          color: index == selectedIndex
                                              ? Theme.of(context)
                                                    .colorScheme
                                                    .primary
                                              : Theme.of(context)
                                                    .colorScheme
                                                    .onSurface
                                                    .withAlpha(80),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showImage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }
}

class const _ActionProgressIndicator() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SizedBox.square(
      dimension: 18,
      child: CircularProgressIndicator(strokeWidth: 2),
    );
  }
}

class const _GalleryArrow({
  required final IconData icon,
  required final String tooltip,
  required final VoidCallback? onPressed,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      blur: 18,
      borderRadius: BorderRadius.circular(22),
      child: IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(icon),
      ),
    );
  }
}

class const _Ingredients({required final Recipe recipe})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool twoColumns = constraints.maxWidth >= AppBreakpoints.medium;
        final double itemWidth = twoColumns
            ? (constraints.maxWidth - 20) / 2
            : constraints.maxWidth;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.ingredients,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              children: recipe.ingredients
                  .map(
                    (group) => SizedBox(
                      width: itemWidth,
                      child: Card(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(minHeight: 180),
                          child: Padding(
                            padding: const EdgeInsets.all(28),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  group.title,
                                  style: Theme.of(context).textTheme.titleLarge
                                      ?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 14),
                                ...group.names.map(
                                  (name) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Text('• $name'),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
          ],
        );
      },
    );
  }
}

class const _Steps({required final Recipe recipe}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.preparation,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        ...recipe.steps.indexed.map(
          (entry) => ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 6),
            leading: CircleAvatar(child: Text('${entry.$1 + 1}')),
            title: Text(entry.$2),
          ),
        ),
      ],
    );
  }
}

class const _ErrorState({
  required final String message,
  required final VoidCallback onRetry,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            FilledButton(onPressed: onRetry, child: Text(context.l10n.retry)),
          ],
        ),
      ),
    );
  }
}
