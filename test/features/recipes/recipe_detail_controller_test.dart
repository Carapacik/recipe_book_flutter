import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book_flutter/src/features/recipes/data/recipe_repository.dart';
import 'package:recipe_book_flutter/src/features/recipes/domain/recipe.dart';
import 'package:recipe_book_flutter/src/features/recipes/domain/recipe_draft.dart';
import 'package:recipe_book_flutter/src/features/recipes/presentation/controllers/recipe_detail_controller.dart';

void main() {
  group('RecipeDetailController', () {
    test('loads a recipe and exposes loading state', () async {
      final repository = _RecipeDataSource();
      final completer = Completer<Recipe>();
      repository.getByIdResult = completer.future;
      final controller = RecipeDetailController(repository, recipeId: 7);

      final Future<void> future = controller.load();

      expect(controller.isLoading, isTrue);
      expect(repository.requestedId, 7);
      completer.complete(_recipe());
      await future;
      expect(controller.isLoading, isFalse);
      expect(controller.recipe?.id, 7);
      expect(controller.error, isNull);
    });

    test('exposes a load error and can retry', () async {
      final repository = _RecipeDataSource()
        ..getByIdResult = Future.error(StateError('offline'));
      final controller = RecipeDetailController(repository, recipeId: 7);

      await controller.load();

      expect(controller.recipe, isNull);
      expect(controller.error, contains('offline'));
      repository.getByIdResult = Future.value(_recipe());
      await controller.load();
      expect(controller.recipe, isNotNull);
      expect(controller.error, isNull);
    });

    test('favorite also adds a like and updates both counters', () async {
      final repository = _RecipeDataSource();
      final controller = RecipeDetailController(repository, recipeId: 7);
      await controller.load();

      expect(await controller.toggleFavorite(), isTrue);

      expect(repository.favoriteValue, isTrue);
      expect(controller.recipe?.isFavorite, isTrue);
      expect(controller.recipe?.favorites, 4);
      expect(controller.recipe?.isLiked, isTrue);
      expect(controller.recipe?.likes, 6);
    });

    test('removing a like also removes favorite', () async {
      final repository = _RecipeDataSource()
        ..getByIdResult = Future.value(
          _recipe(isLiked: true, isFavorite: true),
        );
      final controller = RecipeDetailController(repository, recipeId: 7);
      await controller.load();

      expect(await controller.toggleLike(), isTrue);

      expect(repository.likeValue, isFalse);
      expect(controller.recipe?.isLiked, isFalse);
      expect(controller.recipe?.likes, 4);
      expect(controller.recipe?.isFavorite, isFalse);
      expect(controller.recipe?.favorites, 2);
    });

    test('rolls back an optimistic favorite change on failure', () async {
      final repository = _RecipeDataSource()..favoriteError = true;
      final controller = RecipeDetailController(repository, recipeId: 7);
      await controller.load();

      expect(await controller.toggleFavorite(), isFalse);

      expect(controller.recipe?.isFavorite, isFalse);
      expect(controller.recipe?.favorites, 3);
      expect(controller.recipe?.isLiked, isFalse);
      expect(controller.error, contains('favorite failed'));
      expect(controller.isFavoriteChanging, isFalse);
    });

    test(
      'ignores actions before loading and duplicate in-flight actions',
      () async {
        final repository = _RecipeDataSource();
        final controller = RecipeDetailController(repository, recipeId: 7);
        expect(await controller.toggleLike(), isFalse);
        await controller.load();
        final completer = Completer<void>();
        repository.likeResult = completer.future;

        final Future<bool> first = controller.toggleLike();
        final bool second = await controller.toggleFavorite();

        expect(second, isFalse);
        expect(repository.likeCalls, 1);
        expect(repository.favoriteValue, isNull);
        completer.complete();
        expect(await first, isTrue);
      },
    );
  });
}

Recipe _recipe({bool isLiked = false, bool isFavorite = false}) => Recipe(
  id: 7,
  title: 'Soup',
  description: 'Warm soup',
  imageUrl: 'soup.jpg',
  imageUrls: const ['soup.jpg'],
  cookingTime: 20,
  portions: 2,
  likes: 5,
  favorites: 3,
  author: 'Chef',
  isLiked: isLiked,
  isFavorite: isFavorite,
  tags: const ['quick'],
);

class _RecipeDataSource() implements RecipeDataSource {
  Future<Recipe> getByIdResult = Future.value(_recipe());
  Future<void> likeResult = Future.value();
  bool favoriteError = false;
  int? requestedId;
  bool? favoriteValue;
  bool? likeValue;
  int likeCalls = 0;

  @override
  Future<Recipe> getById(int id) {
    requestedId = id;
    return getByIdResult;
  }

  @override
  Future<void> setFavorite(int id, {required bool value}) async {
    favoriteValue = value;
    if (favoriteError) {
      throw StateError('favorite failed');
    }
  }

  @override
  Future<void> setLiked(int id, {required bool value}) async {
    likeCalls++;
    likeValue = value;
    await likeResult;
  }

  @override
  Future<int> create(RecipeDraft draft) => throw UnimplementedError();

  @override
  Future<void> delete(int id) => throw UnimplementedError();

  @override
  Future<Recipe> getDaily() => throw UnimplementedError();

  @override
  Future<List<Recipe>> getFavorites({int skip = 0, int take = 20}) =>
      throw UnimplementedError();

  @override
  Future<List<Recipe>> getMine({int skip = 0, int take = 20}) =>
      throw UnimplementedError();

  @override
  Future<List<Recipe>> getRecipes({
    int skip = 0,
    int take = 20,
    String? query,
  }) => throw UnimplementedError();

  @override
  Future<void> update(int id, RecipeDraft draft) => throw UnimplementedError();
}
