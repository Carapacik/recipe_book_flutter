import 'package:flutter/material.dart';
import 'package:recipe_book_flutter/src/core/localization/localization.dart';
import 'package:recipe_book_flutter/src/core/navigation/app_route_matcher.dart';
import 'package:recipe_book_flutter/src/core/navigation/app_routes.dart';
import 'package:recipe_book_flutter/src/core/navigation/app_shell_screen.dart';
import 'package:recipe_book_flutter/src/core/widgets/glass_page_app_bar.dart';
import 'package:recipe_book_flutter/src/core/widgets/glass_panel.dart';
import 'package:recipe_book_flutter/src/features/recipes/presentation/screens/recipe_detail_screen.dart';
import 'package:recipe_book_flutter/src/features/recipes/presentation/screens/recipe_form_screen.dart';

abstract final class AppRouter() {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final ({AppRouteKind kind, int? recipeId}) route = AppRouteMatcher.match(
      settings.name,
    );
    final Widget page = switch (route.kind) {
      AppRouteKind.home => const AppShellScreen(),
      AppRouteKind.recipes => AppShellScreen(
        initialIndex: 1,
        initialRecipeQuery: settings.arguments as String? ?? '',
      ),
      AppRouteKind.favorites => const AppShellScreen(initialIndex: 2),
      AppRouteKind.profile => const AppShellScreen(initialIndex: 3),
      AppRouteKind.recipeNew => const RecipeFormScreen(),
      AppRouteKind.recipeDetail => RecipeDetailScreen(
        recipeId: route.recipeId!,
      ),
      AppRouteKind.recipeEdit => RecipeFormScreen(recipeId: route.recipeId),
      AppRouteKind.notFound => const _NotFoundScreen(),
    };

    return MaterialPageRoute<void>(builder: (_) => page, settings: settings);
  }
}

class const _NotFoundScreen() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GlassPageAppBar(title: context.l10n.pageNotFound),
      body: GlassBackground(
        child: Center(
          child: FilledButton(
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.home,
              (_) => false,
            ),
            child: Text(context.l10n.goHome),
          ),
        ),
      ),
    );
  }
}
