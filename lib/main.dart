import 'package:flutter/material.dart';
import 'package:recipe_book_flutter/src/app/app.dart';
import 'package:recipe_book_flutter/src/app/app_dependencies.dart';
import 'package:recipe_book_flutter/src/core/localization/locale_controller.dart';
import 'package:recipe_book_flutter/src/core/navigation/url_strategy.dart';
import 'package:recipe_book_flutter/src/core/network/api_client.dart';
import 'package:recipe_book_flutter/src/core/storage/token_storage.dart';
import 'package:recipe_book_flutter/src/features/auth/data/auth_repository.dart';
import 'package:recipe_book_flutter/src/features/profile/data/profile_repository.dart';
import 'package:recipe_book_flutter/src/features/recipes/data/recipe_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    configureUrlStrategy();
    final TokenStorage tokenStorage = await TokenStorage.create();
    final LocaleController localeController = await LocaleController.create();
    final apiClient = ApiClient(tokenStorage);
    final dependencies = AppDependencies(
      authRepository: AuthRepository(apiClient, tokenStorage),
      profileRepository: ProfileRepository(apiClient, tokenStorage),
      recipeRepository: RecipeRepository(apiClient),
    );

    runApp(
      RecipeBookApp(
        dependencies: dependencies,
        localeController: localeController,
      ),
    );
  } on Object catch (error, stackTrace) {
    FlutterError.reportError(
      FlutterErrorDetails(exception: error, stack: stackTrace),
    );
    rethrow;
  }
}
