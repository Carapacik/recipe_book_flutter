abstract final class AppRoutes() {
  static const home = '/';
  static const recipes = '/recipes';
  static const favorites = '/favorites';
  static const profile = '/profile';
  static const recipeNew = '/recipe/new';

  static String recipe(int id) => '/recipe/$id';

  static String recipeEdit(int id) => '/recipe/$id/edit';

  static String section(int index) => switch (index) {
    1 => recipes,
    2 => favorites,
    3 => profile,
    _ => home,
  };
}
