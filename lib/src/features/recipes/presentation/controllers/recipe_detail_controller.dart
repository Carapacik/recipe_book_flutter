import 'package:flutter/foundation.dart';
import 'package:recipe_book_flutter/src/features/recipes/data/recipe_repository.dart';
import 'package:recipe_book_flutter/src/features/recipes/domain/recipe.dart';

class RecipeDetailController(
  final RecipeDataSource _repository, {
  required final int recipeId,
}) extends ChangeNotifier {
  Recipe? _recipe;
  bool _isLoading = false;
  bool _isFavoriteChanging = false;
  bool _isLikeChanging = false;
  String? _error;

  Recipe? get recipe => _recipe;
  bool get isLoading => _isLoading;
  bool get isFavoriteChanging => _isFavoriteChanging;
  bool get isLikeChanging => _isLikeChanging;
  bool get isRatingChanging => _isFavoriteChanging || _isLikeChanging;
  String? get error => _error;

  Future<void> load() async {
    if (_isLoading) {
      return;
    }
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _recipe = await _repository.getById(recipeId);
    } on Object catch (error) {
      _error = error.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> toggleFavorite() async {
    final Recipe? current = _recipe;
    if (current == null || isRatingChanging) {
      return false;
    }
    final bool value = !current.isFavorite;
    _isFavoriteChanging = true;
    _error = null;
    _recipe = current.copyWith(
      isFavorite: value,
      isLiked: value || current.isLiked,
      favorites: _changedCount(current.favorites, value),
      likes: value && !current.isLiked ? current.likes + 1 : current.likes,
    );
    notifyListeners();
    try {
      await _repository.setFavorite(current.id, value: value);
      return true;
    } on Object catch (error) {
      _recipe = current;
      _error = error.toString();
      return false;
    } finally {
      _isFavoriteChanging = false;
      notifyListeners();
    }
  }

  Future<bool> toggleLike() async {
    final Recipe? current = _recipe;
    if (current == null || isRatingChanging) {
      return false;
    }
    final bool value = !current.isLiked;
    _isLikeChanging = true;
    _error = null;
    _recipe = current.copyWith(
      isLiked: value,
      isFavorite: value && current.isFavorite,
      likes: _changedCount(current.likes, value),
      favorites: !value && current.isFavorite
          ? _changedCount(current.favorites, false)
          : current.favorites,
    );
    notifyListeners();
    try {
      await _repository.setLiked(current.id, value: value);
      return true;
    } on Object catch (error) {
      _recipe = current;
      _error = error.toString();
      return false;
    } finally {
      _isLikeChanging = false;
      notifyListeners();
    }
  }

  int _changedCount(int count, bool increment) =>
      increment ? count + 1 : (count - 1).clamp(0, count);
}
