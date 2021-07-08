import 'package:recipe_book_flutter/src/features/auth/data/auth_repository.dart';
import 'package:recipe_book_flutter/src/features/profile/data/profile_repository.dart';
import 'package:recipe_book_flutter/src/features/recipes/data/recipe_repository.dart';

class const AppDependencies({
  required final AuthRepository authRepository,
  required final ProfileRepository profileRepository,
  required final RecipeRepository recipeRepository,
});
