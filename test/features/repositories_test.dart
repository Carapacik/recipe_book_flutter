import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book_flutter/src/core/network/api_client.dart';
import 'package:recipe_book_flutter/src/core/storage/token_storage.dart';
import 'package:recipe_book_flutter/src/features/auth/data/auth_repository.dart';
import 'package:recipe_book_flutter/src/features/profile/data/profile_repository.dart';
import 'package:recipe_book_flutter/src/features/profile/domain/profile.dart';
import 'package:recipe_book_flutter/src/features/recipes/data/recipe_repository.dart';
import 'package:recipe_book_flutter/src/features/recipes/domain/ingredient.dart';
import 'package:recipe_book_flutter/src/features/recipes/domain/recipe.dart';
import 'package:recipe_book_flutter/src/features/recipes/domain/recipe_draft.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthRepository', () {
    test('logs in, registers, validates, and logs out', () async {
      SharedPreferences.setMockInitialValues({});
      final TokenStorage storage = await TokenStorage.create();
      final api = _ApiGateway()
        ..response = <String, dynamic>{'accessToken': 'token'};
      final repository = AuthRepository(api, storage);

      await repository.login(email: 'chef@example.com', password: 'secret');
      expect(api.path, 'auth/login');
      expect(api.data, {'email': 'chef@example.com', 'password': 'secret'});
      expect(storage.token, 'token');
      expect(storage.email, 'chef@example.com');
      expect(repository.hasToken, isTrue);

      await repository.register(
        name: 'Cook',
        email: 'cook@example.com',
        password: 'password',
      );
      expect(api.path, 'auth/register');
      expect(storage.email, 'cook@example.com');

      api.response = null;
      await repository.validate();
      expect(api.path, 'auth/validate');
      await repository.logout();
      expect(repository.hasToken, isFalse);
    });

    test('rejects an empty access token', () async {
      SharedPreferences.setMockInitialValues({});
      final TokenStorage storage = await TokenStorage.create();
      final api = _ApiGateway()
        ..response = <String, dynamic>{'accessToken': ''};
      final repository = AuthRepository(api, storage);

      expect(
        () => repository.login(email: 'a', password: 'b'),
        throwsA(isA<FormatException>()),
      );
    });
  });

  group('ProfileRepository', () {
    test(
      'parses profile, updates stored email, and sends optional password',
      () async {
        SharedPreferences.setMockInitialValues({});
        final TokenStorage storage = await TokenStorage.create();
        await storage.saveCredentials(
          token: 'token',
          email: 'chef@example.com',
        );
        final api = _ApiGateway()
          ..response = <String, dynamic>{
            'name': 'Chef',
            'login': 'chef@example.com',
            'description': 'Bio',
            'recipesCount': 1,
            'likesCount': 2,
            'favoritesCount': 3,
          };
        final repository = ProfileRepository(api, storage);

        final Profile profile = await repository.getProfile();
        expect(profile.email, 'chef@example.com');
        expect(api.path, 'profile');

        await repository.update(
          name: 'Cook',
          email: 'cook@example.com',
          description: 'New bio',
          password: 'new-password',
        );
        expect(api.voidMethod, 'PUT');
        expect(api.data, containsPair('password', 'new-password'));
        expect(storage.email, 'cook@example.com');

        await repository.update(
          name: 'Cook',
          email: 'cook@example.com',
          description: 'New bio',
          password: '',
        );
        expect(api.data, isNot(contains('password')));
      },
    );
  });

  group('RecipeRepository', () {
    test('uses list, daily, detail, and rating endpoints', () async {
      final api = _ApiGateway()
        ..response = <dynamic>[_recipeJson(1), 'ignored'];
      final repository = RecipeRepository(api);

      final List<Recipe> recipes = await repository.getRecipes(
        skip: 4,
        take: 8,
        query: 'soup',
      );
      expect(recipes.single.id, 1);
      expect(api.path, 'recipes');
      expect(api.queryParameters, {
        'skip': 4,
        'take': 8,
        'searchQuery': 'soup',
      });

      api.response = <dynamic>[_recipeJson(2)];
      expect((await repository.getFavorites()).single.id, 2);
      expect(api.path, 'recipes/favorites');
      expect((await repository.getMine()).single.id, 2);
      expect(api.path, 'recipes/mine');

      api.response = _recipeJson(3);
      expect((await repository.getDaily()).id, 3);
      expect(api.path, 'recipes/daily');
      expect((await repository.getById(9)).id, 3);
      expect(api.path, 'recipes/9');

      await repository.setFavorite(9, value: true);
      expect(api.voidMethod, 'PUT');
      expect(api.path, 'recipes/9/favorite');
      await repository.setFavorite(9, value: false);
      expect(api.voidMethod, 'DELETE');
      await repository.setLiked(9, value: true);
      expect(api.path, 'recipes/9/like');
      await repository.setLiked(9, value: false);
      expect(api.voidMethod, 'DELETE');
      await repository.delete(9);
      expect(api.path, 'recipes/9');
    });

    test('serializes recipe draft for create and update', () async {
      final api = _ApiGateway()..response = <String, dynamic>{'id': 17};
      final repository = RecipeRepository(api);
      final draft = RecipeDraft(
        title: 'Soup',
        description: 'Warm',
        cookingTime: 25,
        portions: 4,
        tags: const ['quick', 'warm'],
        steps: const ['Mix', 'Cook'],
        ingredients: const [
          Ingredient(title: 'Base', names: ['Water', 'Salt']),
        ],
        images: [
          RecipeImageDraft(bytes: Uint8List.fromList([1, 2]), name: 'one.jpg'),
          RecipeImageDraft(bytes: Uint8List.fromList([3]), name: 'two.jpg'),
        ],
      );

      expect(await repository.create(draft), 17);
      expect(api.path, 'recipes');
      final createData = api.data! as FormData;
      final Map<String, String> fields = Map.fromEntries(createData.fields);
      expect(fields, containsPair('Title', 'Soup'));
      expect(fields, containsPair('Ingredients[0].IngredientNames[1]', 'Salt'));
      expect(createData.files.map((entry) => entry.key), [
        'RecipeImage',
        'RecipeImages',
      ]);

      await repository.update(17, draft);
      expect(api.path, 'recipes/17');
      expect(api.voidMethod, 'PUT');
    });
  });
}

Map<String, Object?> _recipeJson(int id) => {
  'recipeId': id,
  'title': 'Recipe $id',
  'description': 'Description',
  'imageUrl': 'image.jpg',
};

class _ApiGateway() implements ApiGateway {
  Object? response;
  String? path;
  Object? data;
  Map<String, Object?>? queryParameters;
  String? voidMethod;

  @override
  Future<T> get<T>(String path, {Map<String, Object?>? queryParameters}) async {
    this.path = path;
    this.queryParameters = queryParameters;
    return response as T;
  }

  @override
  Future<T> post<T>(String path, {Object? data}) async {
    this.path = path;
    this.data = data;
    return response as T;
  }

  @override
  Future<T> put<T>(String path, {Object? data}) async {
    this.path = path;
    this.data = data;
    return response as T;
  }

  @override
  Future<T> delete<T>(String path) async {
    this.path = path;
    return response as T;
  }

  @override
  Future<void> putVoid(String path, {Object? data}) async {
    this.path = path;
    this.data = data;
    voidMethod = 'PUT';
  }

  @override
  Future<void> deleteVoid(String path) async {
    this.path = path;
    voidMethod = 'DELETE';
  }
}
