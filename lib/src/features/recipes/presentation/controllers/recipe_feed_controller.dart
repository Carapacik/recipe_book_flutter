import 'package:flutter/foundation.dart';
import 'package:recipe_book_flutter/src/features/recipes/data/recipe_repository.dart';
import 'package:recipe_book_flutter/src/features/recipes/domain/recipe.dart';

enum RecipeFeedType() {
  all,
  favorites,
  mine
}

class RecipeFeedController(
  final RecipeDataSource _repository, {
  final RecipeFeedType type = RecipeFeedType.all,
}) extends ChangeNotifier {
  static const _pageSize = 12;

  final List<Recipe> _items = [];

  bool _isLoading = false;
  bool _hasMore = true;
  String? _error;
  String _query = '';

  List<Recipe> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;
  String? get error => _error;
  String get query => _query;

  Future<void> loadInitial({String query = ''}) async {
    _query = query.trim();
    _items.clear();
    _hasMore = true;
    await _load();
  }

  Future<void> loadMore() => _load();

  Future<void> refresh() => loadInitial(query: _query);

  Future<void> toggleFavorite(Recipe recipe) async {
    final bool value = !recipe.isFavorite;
    final bool liked = value || recipe.isLiked;
    _replace(
      recipe.copyWith(
        isFavorite: value,
        isLiked: liked,
        favorites: _changedCount(recipe.favorites, value),
        likes: recipe.likes + (value && !recipe.isLiked ? 1 : 0),
      ),
    );
    try {
      await _repository.setFavorite(recipe.id, value: value);
    } on Object catch (error) {
      _replace(recipe);
      _error = error.toString();
      notifyListeners();
    }
  }

  Future<void> toggleLike(Recipe recipe) async {
    final bool value = !recipe.isLiked;
    _replace(
      recipe.copyWith(
        isLiked: value,
        isFavorite: value && recipe.isFavorite,
        likes: _changedCount(recipe.likes, value),
        favorites: !value && recipe.isFavorite
            ? _changedCount(recipe.favorites, false)
            : recipe.favorites,
      ),
    );
    try {
      await _repository.setLiked(recipe.id, value: value);
    } on Object catch (error) {
      _replace(recipe);
      _error = error.toString();
      notifyListeners();
    }
  }

  Future<void> _load() async {
    if (_isLoading || !_hasMore) {
      return;
    }
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      final List<Recipe> recipes = switch (type) {
        RecipeFeedType.all => await _repository.getRecipes(
          skip: _items.length,
          take: _pageSize,
          query: _query.isEmpty ? null : _query,
        ),
        RecipeFeedType.favorites => await _repository.getFavorites(
          skip: _items.length,
          take: _pageSize,
        ),
        RecipeFeedType.mine => await _repository.getMine(
          skip: _items.length,
          take: _pageSize,
        ),
      };
      _items.addAll(recipes);
      _hasMore = recipes.length == _pageSize;
    } on Object catch (error) {
      _error = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _replace(Recipe recipe) {
    final int index = _items.indexWhere((item) => item.id == recipe.id);
    if (index == -1) {
      return;
    }
    _items[index] = recipe;
    notifyListeners();
  }

  int _changedCount(int count, bool increment) =>
      increment ? count + 1 : (count - 1).clamp(0, count);
}
