import 'package:beamer/beamer.dart';
import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:recipebook/screens/error/error_page.dart';
import 'package:recipebook/screens/favorite/favorite_page.dart';
import 'package:recipebook/screens/home/home_page.dart';
import 'package:recipebook/screens/recipes/add_recipe_page.dart';
import 'package:recipebook/screens/recipes/recipe_detail_page.dart';
import 'package:recipebook/screens/recipes/recipes_page.dart';

final recipeLocationBuilder = BeamerLocationBuilder(
  beamLocations: [
    HomeLocation(),
    RecipesLocation(),
    FavoriteLocation(),
  ],
);

class HomeLocation extends BeamLocation<BeamState> {
  @override
  List<String> get pathBlueprints => ['/'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        BeamPage(
          key: const ValueKey('home'),
          title: 'Главная',
          child: HomePage(),
        ),
      ];
}

class FavoriteLocation extends BeamLocation<BeamState> {
  @override
  List<String> get pathBlueprints => ['/favorite'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        BeamPage(
          key: const ValueKey('favorite'),
          title: 'Избранное',
          child: const FavoritePage(),
        ),
      ];
}

class RecipesLocation extends BeamLocation<BeamState> {
  @override
  List<String> get pathBlueprints => [
        '/recipes/add',
        '/recipes/:recipeId',
        '/recipes/:recipeId/edit',
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final List<BeamPage> beamPages = [];

    if (state.pathBlueprintSegments.contains('recipes')) {
      final searchQuery = state.queryParameters['searchQuery'] ?? '';
      final pageTitle = searchQuery != '' ? "Результаты по '$searchQuery'" : 'Рецепты';

      beamPages.add(
        BeamPage(
          key: ValueKey('recipes-$searchQuery'),
          title: pageTitle,
          child: RecipesPage(searchQuery: searchQuery),
        ),
      );
    }


    if (state.pathParameters.containsKey('recipeId')) {
      final recipeId = state.pathParameters['recipeId'];
      const pageTitle = 'Детальный рецепт';
      // final result = int.tryParse(recipeId!) ?? "";
      // if (result == "") {}

      beamPages.add(
        BeamPage(
          key: ValueKey('recipes-$recipeId'),
          title: pageTitle,
          child: RecipeDetailPage(recipeId: recipeId!),
        ),
      );
    }

    if (state.uri.pathSegments.contains('add')) {
      const pageTitle = 'Добавить рецепт';

      beamPages.add(
        BeamPage(
          key: const ValueKey('recipes-add'),
          title: pageTitle,
          child: const AddRecipePage(),
        ),
      );
    }

    if (state.uri.pathSegments.contains('edit')) {
      final recipeId = state.pathParameters['recipeId'];
      const pageTitle = 'Редактировать рецепта';

      beamPages.add(
        BeamPage(
          key: ValueKey('recipes-$recipeId-edit'),
          title: pageTitle,
          child: AddRecipePage(recipeId: recipeId,), // редактирование рецепта
        ),
      );
    }

    return beamPages;
  }
}
