import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book_flutter/src/core/navigation/app_route_matcher.dart';
import 'package:recipe_book_flutter/src/core/navigation/app_routes.dart';

void main() {
  test('builds recipe paths', () {
    expect(AppRoutes.recipe(42), '/recipe/42');
    expect(AppRoutes.recipeEdit(42), '/recipe/42/edit');
  });

  test('maps shell indexes to stable URLs', () {
    expect(AppRoutes.section(0), AppRoutes.home);
    expect(AppRoutes.section(1), AppRoutes.recipes);
    expect(AppRoutes.section(2), AppRoutes.favorites);
    expect(AppRoutes.section(3), AppRoutes.profile);
    expect(AppRoutes.section(99), AppRoutes.home);
  });

  test('matches every supported deep link and rejects malformed paths', () {
    expect(AppRouteMatcher.match(null).kind, AppRouteKind.home);
    expect(
      AppRouteMatcher.match('/recipes?query=soup').kind,
      AppRouteKind.recipes,
    );
    expect(AppRouteMatcher.match('/favorites').kind, AppRouteKind.favorites);
    expect(AppRouteMatcher.match('/profile').kind, AppRouteKind.profile);
    expect(AppRouteMatcher.match('/recipe/new').kind, AppRouteKind.recipeNew);
    expect(AppRouteMatcher.match('/recipe/42'), (
      kind: AppRouteKind.recipeDetail,
      recipeId: 42,
    ));
    expect(AppRouteMatcher.match('/recipe/42/edit'), (
      kind: AppRouteKind.recipeEdit,
      recipeId: 42,
    ));
    expect(
      AppRouteMatcher.match('/recipe/not-a-number').kind,
      AppRouteKind.notFound,
    );
    expect(AppRouteMatcher.match('/missing').kind, AppRouteKind.notFound);
  });
}
