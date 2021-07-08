import 'package:dio/dio.dart';
import 'package:recipe_book_flutter/src/core/network/api_client.dart';
import 'package:recipe_book_flutter/src/features/recipes/domain/ingredient.dart';
import 'package:recipe_book_flutter/src/features/recipes/domain/recipe.dart';
import 'package:recipe_book_flutter/src/features/recipes/domain/recipe_draft.dart';

abstract interface class RecipeDataSource() {
  Future<List<Recipe>> getRecipes({int skip = 0, int take = 20, String? query});

  Future<List<Recipe>> getFavorites({int skip = 0, int take = 20});

  Future<List<Recipe>> getMine({int skip = 0, int take = 20});

  Future<Recipe> getDaily();

  Future<Recipe> getById(int id);

  Future<int> create(RecipeDraft draft);

  Future<void> update(int id, RecipeDraft draft);

  Future<void> delete(int id);

  Future<void> setFavorite(int id, {required bool value});

  Future<void> setLiked(int id, {required bool value});
}

class const RecipeRepository(final ApiGateway _apiClient)
    implements RecipeDataSource {
  @override
  Future<List<Recipe>> getRecipes({
    int skip = 0,
    int take = 20,
    String? query,
  }) async {
    final List<dynamic> data = await _apiClient.get<List<dynamic>>(
      'recipes',
      queryParameters: {'skip': skip, 'take': take, 'searchQuery': query},
    );
    return _parseRecipes(data);
  }

  @override
  Future<List<Recipe>> getFavorites({int skip = 0, int take = 20}) async {
    final List<dynamic> data = await _apiClient.get<List<dynamic>>(
      'recipes/favorites',
      queryParameters: {'skip': skip, 'take': take},
    );
    return _parseRecipes(data);
  }

  @override
  Future<List<Recipe>> getMine({int skip = 0, int take = 20}) async {
    final List<dynamic> data = await _apiClient.get<List<dynamic>>(
      'recipes/mine',
      queryParameters: {'skip': skip, 'take': take},
    );
    return _parseRecipes(data);
  }

  @override
  Future<Recipe> getDaily() async {
    final Map<String, dynamic> data = await _apiClient
        .get<Map<String, dynamic>>('recipes/daily');
    return Recipe.fromJson(data);
  }

  @override
  Future<Recipe> getById(int id) async {
    final Map<String, dynamic> data = await _apiClient
        .get<Map<String, dynamic>>('recipes/$id');
    return Recipe.fromJson(data);
  }

  @override
  Future<int> create(RecipeDraft draft) async {
    final Map<String, dynamic> data = await _apiClient
        .post<Map<String, dynamic>>('recipes', data: _toFormData(draft));
    return (data['id'] as num).toInt();
  }

  @override
  Future<void> update(int id, RecipeDraft draft) =>
      _apiClient.putVoid('recipes/$id', data: _toFormData(draft));

  @override
  Future<void> delete(int id) => _apiClient.deleteVoid('recipes/$id');

  @override
  Future<void> setFavorite(int id, {required bool value}) => value
      ? _apiClient.putVoid('recipes/$id/favorite')
      : _apiClient.deleteVoid('recipes/$id/favorite');

  @override
  Future<void> setLiked(int id, {required bool value}) => value
      ? _apiClient.putVoid('recipes/$id/like')
      : _apiClient.deleteVoid('recipes/$id/like');

  List<Recipe> _parseRecipes(List<dynamic> data) => data
      .whereType<Map<String, dynamic>>()
      .map(Recipe.fromJson)
      .toList(growable: false);

  FormData _toFormData(RecipeDraft draft) {
    final formData = FormData();
    void addField(String name, Object value) =>
        formData.fields.add(MapEntry(name, '$value'));

    addField('Title', draft.title);
    addField('Description', draft.description);
    addField('CookingTimeInMinutes', draft.cookingTime);
    addField('PortionsCount', draft.portions);
    for (var index = 0; index < draft.tags.length; index++) {
      addField('Tags[$index]', draft.tags[index]);
    }
    for (var index = 0; index < draft.steps.length; index++) {
      addField('Steps[$index]', draft.steps[index]);
    }
    for (var group = 0; group < draft.ingredients.length; group++) {
      final Ingredient ingredient = draft.ingredients[group];
      addField('Ingredients[$group].Title', ingredient.title);
      for (var item = 0; item < ingredient.names.length; item++) {
        addField(
          'Ingredients[$group].IngredientNames[$item]',
          ingredient.names[item],
        );
      }
    }
    for (final (int index, RecipeImageDraft image) in draft.images.indexed) {
      formData.files.add(
        MapEntry(
          index == 0 ? 'RecipeImage' : 'RecipeImages',
          MultipartFile.fromBytes(image.bytes, filename: image.name),
        ),
      );
    }
    return formData;
  }
}
