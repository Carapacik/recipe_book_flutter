import 'package:flutter/material.dart';
import 'package:recipe_book_flutter/src/app/app.dart';
import 'package:recipe_book_flutter/src/core/layout/window_size_class.dart';
import 'package:recipe_book_flutter/src/core/localization/localization.dart';
import 'package:recipe_book_flutter/src/core/navigation/app_routes.dart';
import 'package:recipe_book_flutter/src/core/theme/app_colors.dart';
import 'package:recipe_book_flutter/src/core/widgets/content_width.dart';
import 'package:recipe_book_flutter/src/core/widgets/glass_panel.dart';
import 'package:recipe_book_flutter/src/features/auth/presentation/auth_dialog.dart';
import 'package:recipe_book_flutter/src/features/home/presentation/widgets/daily_recipe_card.dart';
import 'package:recipe_book_flutter/src/features/recipes/domain/recipe.dart';

class const HomeScreen({
  required final ValueChanged<String> onOpenRecipes,
  super.key,
}) extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState() extends State<HomeScreen> {
  final _searchController = TextEditingController();
  Future<Recipe>? _dailyRecipe;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _dailyRecipe ??= AppScope.of(context).recipeRepository.getDaily();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ContentWidth(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _HeroSection(onAddRecipe: _openRecipeForm),
            const SizedBox(height: 56),
            Text(
              context.l10n.homeMoodTitle,
              style: Theme.of(context).textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Text(context.l10n.popularTagsDescription),
            const SizedBox(height: 24),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _CategoryCard(
                  icon: Icons.timer_outlined,
                  title: context.l10n.categoryEasy,
                  query: 'простое',
                  onOpenRecipes: widget.onOpenRecipes,
                ),
                _CategoryCard(
                  icon: Icons.child_care,
                  title: context.l10n.categoryKids,
                  query: 'детское',
                  onOpenRecipes: widget.onOpenRecipes,
                ),
                _CategoryCard(
                  icon: Icons.workspace_premium_outlined,
                  title: context.l10n.categoryChef,
                  query: 'шеф-повар',
                  onOpenRecipes: widget.onOpenRecipes,
                ),
                _CategoryCard(
                  icon: Icons.celebration_outlined,
                  title: context.l10n.categoryHoliday,
                  query: 'праздник',
                  onOpenRecipes: widget.onOpenRecipes,
                ),
              ],
            ),
            const SizedBox(height: 56),
            Text(
              context.l10n.recipeOfDay,
              style: Theme.of(context).textTheme.headlineMedium
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            FutureBuilder<Recipe>(
              future: _dailyRecipe,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const SizedBox(
                    height: 280,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                if (snapshot.hasError) {
                  return _DailyRecipeError(
                    onRetry: () => setState(
                      () =>
                          _dailyRecipe = AppScope.of(context).recipeRepository
                              .getDaily(),
                    ),
                  );
                }
                return DailyRecipeCard(recipe: snapshot.requireData);
              },
            ),
            const SizedBox(height: 56),
            _SearchCard(
              controller: _searchController,
              onOpenRecipes: widget.onOpenRecipes,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Future<void> _openRecipeForm() async {
    try {
      if (!AuthScope.of(context, listen: false).isAuthenticated) {
        final bool signedIn = await showAuthDialog(context);
        if (!signedIn || !mounted) {
          return;
        }
      }
      if (mounted) {
        await Navigator.pushNamed(context, AppRoutes.recipeNew);
      }
    } on Object catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }
}

class const _HeroSection({required final VoidCallback onAddRecipe})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final compact =
        AppBreakpoints.widthClassOf(context) == WindowWidthClass.compact;
    final text = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          context.l10n.heroTitle,
          style:
              (compact
                      ? Theme.of(context).textTheme.displaySmall
                      : Theme.of(context).textTheme.displayMedium)
                  ?.copyWith(fontWeight: FontWeight.w700, height: 1.05),
        ),
        const SizedBox(height: 18),
        Text(
          context.l10n.heroDescription,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 28),
        FilledButton.icon(
          onPressed: onAddRecipe,
          icon: const Icon(Icons.add),
          label: Text(context.l10n.addRecipe),
        ),
      ],
    );
    final image = Image.asset(
      'assets/images/home_background.png',
      fit: BoxFit.contain,
      errorBuilder: (_, _, _) => const Icon(Icons.restaurant, size: 160),
    );
    return GlassPanel(
      padding: EdgeInsets.all(compact ? 24 : 40),
      color: AppColors.iconBackground.withAlpha(205),
      child: compact
          ? SizedBox(
              height: 560,
              child: Column(
                children: [
                  Expanded(child: image),
                  text,
                ],
              ),
            )
          : SizedBox(
              height: 440,
              child: Row(
                children: [
                  Expanded(flex: 6, child: text),
                  const SizedBox(width: 24),
                  Expanded(flex: 5, child: image),
                ],
              ),
            ),
    );
  }
}

class const _CategoryCard({
  required final IconData icon,
  required final String title,
  required final String query,
  required final ValueChanged<String> onOpenRecipes,
}) extends StatefulWidget {
  @override
  State<_CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState() extends State<_CategoryCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final TextStyle labelStyle =
        Theme.of(context).textTheme.labelLarge ?? const TextStyle();
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 180),
        scale: _hovered ? 1.035 : 1,
        child: ActionChip(
          avatar: Icon(widget.icon),
          label: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 180),
              style: labelStyle.copyWith(
                fontVariations: [FontVariation('wght', _hovered ? 720 : 560)],
              ),
              child: Text(widget.title),
            ),
          ),
          onPressed: () => widget.onOpenRecipes(widget.query),
        ),
      ),
    );
  }
}

class const _DailyRecipeError({required final VoidCallback onRetry})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            Text(context.l10n.dailyUnavailable),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: onRetry, child: Text(context.l10n.retry)),
          ],
        ),
      ),
    );
  }
}

class const _SearchCard({
  required final TextEditingController controller,
  required final ValueChanged<String> onOpenRecipes,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void search() => onOpenRecipes(controller.text.trim());

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            Text(
              context.l10n.searchRecipes,
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller,
              textInputAction: TextInputAction.search,
              onSubmitted: (_) => search(),
              decoration: InputDecoration(
                hintText: context.l10n.searchHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: search,
                  icon: const Icon(Icons.arrow_forward),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
