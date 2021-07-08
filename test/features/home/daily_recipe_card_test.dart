import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_book_flutter/src/core/localization/localization.dart';
import 'package:recipe_book_flutter/src/features/home/presentation/widgets/daily_recipe_card.dart';
import 'package:recipe_book_flutter/src/features/recipes/domain/recipe.dart';

void main() {
  testWidgets('stretches the daily recipe image across compact width', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(500, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: Localization.delegates,
        supportedLocales: Localization.supportedLocales,
        home: const Scaffold(body: DailyRecipeCard(recipe: _recipe)),
      ),
    );
    await tester.pumpAndSettle();

    final double availableWidth = tester
        .getSize(find.byKey(DailyRecipeCard.layoutKey))
        .width;
    final double imageWidth = tester
        .getSize(find.byKey(DailyRecipeCard.imageKey))
        .width;
    expect(imageWidth, availableWidth);
  });
}

const Recipe _recipe = Recipe(
  id: 1,
  title: 'Soup',
  description: 'Warm soup',
  imageUrl: '',
  imageUrls: [],
  cookingTime: 20,
  portions: 2,
  likes: 5,
  favorites: 3,
  author: 'Chef',
  isLiked: false,
  isFavorite: false,
  tags: [],
);
