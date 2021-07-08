import 'package:recipe_book_flutter/src/core/navigation/app_routes.dart';

abstract final class AppRouteMatcher() {
  static ({AppRouteKind kind, int? recipeId}) match(String? name) {
    final Uri uri = Uri.parse(name ?? AppRoutes.home);
    final List<String> segments = uri.pathSegments;
    final int? recipeId = segments.length >= 2 && segments.first == 'recipe'
        ? int.tryParse(segments[1])
        : null;
    final AppRouteKind kind;
    if (uri.path == AppRoutes.home) {
      kind = AppRouteKind.home;
    } else if (uri.path == AppRoutes.recipes) {
      kind = AppRouteKind.recipes;
    } else if (uri.path == AppRoutes.favorites) {
      kind = AppRouteKind.favorites;
    } else if (uri.path == AppRoutes.profile) {
      kind = AppRouteKind.profile;
    } else if (uri.path == AppRoutes.recipeNew) {
      kind = AppRouteKind.recipeNew;
    } else if (recipeId != null && segments.length == 2) {
      kind = AppRouteKind.recipeDetail;
    } else if (recipeId != null &&
        segments.length == 3 &&
        segments.last == 'edit') {
      kind = AppRouteKind.recipeEdit;
    } else {
      kind = AppRouteKind.notFound;
    }
    return (kind: kind, recipeId: recipeId);
  }
}

enum AppRouteKind() {
  home,
  recipes,
  favorites,
  profile,
  recipeNew,
  recipeDetail,
  recipeEdit,
  notFound
}
