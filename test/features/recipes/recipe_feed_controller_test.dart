import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book_flutter/src/features/recipes/data/recipe_repository.dart';
import 'package:recipe_book_flutter/src/features/recipes/domain/recipe.dart';
import 'package:recipe_book_flutter/src/features/recipes/domain/recipe_draft.dart';
import 'package:recipe_book_flutter/src/features/recipes/presentation/controllers/recipe_feed_controller.dart';

void main() {
  group('RecipeFeedController', () {
    test('trims query, loads a page, and stops after a short page', () async {
      final repository = _FeedDataSource()..items = [_recipe(1), _recipe(2)];
      final controller = RecipeFeedController(repository);

      await controller.loadInitial(query: '  soup  ');

      expect(controller.query, 'soup');
      expect(controller.items.map((recipe) => recipe.id), [1, 2]);
      expect(controller.hasMore, isFalse);
      expect(repository.query, 'soup');
      expect(repository.skip, 0);
      expect(repository.take, 12);
      await controller.loadMore();
      expect(repository.allCalls, 1);
    });

    test('selects favorites and mine data sources', () async {
      final favoritesRepository = _FeedDataSource()..items = [_recipe(1)];
      final favorites = RecipeFeedController(
        favoritesRepository,
        type: RecipeFeedType.favorites,
      );
      final mineRepository = _FeedDataSource()..items = [_recipe(2)];
      final mine = RecipeFeedController(
        mineRepository,
        type: RecipeFeedType.mine,
      );

      await favorites.loadInitial();
      await mine.loadInitial();

      expect(favoritesRepository.favoriteCalls, 1);
      expect(mineRepository.mineCalls, 1);
    });

    test('reports loading errors and refreshes the current query', () async {
      final repository = _FeedDataSource()..loadError = true;
      final controller = RecipeFeedController(repository);
      await controller.loadInitial(query: 'cake');
      expect(controller.error, contains('load failed'));
      expect(controller.isLoading, isFalse);

      repository
        ..loadError = false
        ..items = [_recipe(3)];
      await controller.refresh();

      expect(controller.error, isNull);
      expect(controller.query, 'cake');
      expect(controller.items.single.id, 3);
    });

    test('favorite and like honor linked backend state', () async {
      final repository = _FeedDataSource()..items = [_recipe(1)];
      final controller = RecipeFeedController(repository);
      await controller.loadInitial();

      await controller.toggleFavorite(controller.items.single);

      expect(controller.items.single.isFavorite, isTrue);
      expect(controller.items.single.isLiked, isTrue);
      expect(controller.items.single.favorites, 4);
      expect(controller.items.single.likes, 6);
      await controller.toggleLike(controller.items.single);
      expect(controller.items.single.isLiked, isFalse);
      expect(controller.items.single.isFavorite, isFalse);
      expect(controller.items.single.likes, 5);
      expect(controller.items.single.favorites, 3);
    });

    test('rolls back rating changes when the repository fails', () async {
      final repository = _FeedDataSource()
        ..items = [_recipe(1)]
        ..ratingError = true;
      final controller = RecipeFeedController(repository);
      await controller.loadInitial();
      final Recipe original = controller.items.single;

      await controller.toggleFavorite(original);
      expect(controller.items.single.isFavorite, isFalse);
      expect(controller.error, contains('rating failed'));

      await controller.toggleLike(original);
      expect(controller.items.single.isLiked, isFalse);
      expect(controller.error, contains('rating failed'));
    });
  });
}

Recipe _recipe(int id) => Recipe(
  id: id,
  title: 'Recipe $id',
  description: 'Description',
  imageUrl: 'image.jpg',
  imageUrls: const ['image.jpg'],
  cookingTime: 10,
  portions: 2,
  likes: 5,
  favorites: 3,
  author: 'Chef',
  isLiked: false,
  isFavorite: false,
  tags: const [],
);

class _FeedDataSource() implements RecipeDataSource {
  List<Recipe> items = [];
  bool loadError = false;
  bool ratingError = false;
  int allCalls = 0;
  int favoriteCalls = 0;
  int mineCalls = 0;
  int? skip;
  int? take;
  String? query;

  @override
  Future<List<Recipe>> getRecipes({
    int skip = 0,
    int take = 20,
    String? query,
  }) async {
    allCalls++;
    this.skip = skip;
    this.take = take;
    this.query = query;
    if (loadError) {
      throw StateError('load failed');
    }
    return items;
  }

  @override
  Future<List<Recipe>> getFavorites({int skip = 0, int take = 20}) async {
    favoriteCalls++;
    if (loadError) {
      throw StateError('load failed');
    }
    return items;
  }

  @override
  Future<List<Recipe>> getMine({int skip = 0, int take = 20}) async {
    mineCalls++;
    if (loadError) {
      throw StateError('load failed');
    }
    return items;
  }

  @override
  Future<void> setFavorite(int id, {required bool value}) async {
    if (ratingError) {
      throw StateError('rating failed');
    }
  }

  @override
  Future<void> setLiked(int id, {required bool value}) async {
    if (ratingError) {
      throw StateError('rating failed');
    }
  }

  @override
  Future<int> create(RecipeDraft draft) => throw UnimplementedError();

  @override
  Future<void> delete(int id) => throw UnimplementedError();

  @override
  Future<Recipe> getById(int id) => throw UnimplementedError();

  @override
  Future<Recipe> getDaily() => throw UnimplementedError();

  @override
  Future<void> update(int id, RecipeDraft draft) => throw UnimplementedError();
}
