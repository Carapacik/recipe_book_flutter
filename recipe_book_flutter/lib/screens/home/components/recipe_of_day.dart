import 'dart:async';
import 'dart:convert';

import 'package:beamer/beamer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:recipe_book_flutter/model/recipe_of_day.dart';
import 'package:recipe_book_flutter/resources/icons.dart';
import 'package:recipe_book_flutter/resources/palette.dart';
import 'package:recipe_book_flutter/service/api_service.dart';
import 'package:recipe_book_flutter/theme.dart';
import 'package:recipe_book_flutter/widgets/recipe_image_with_author.dart';

class RecipeOfDayWidget extends StatefulWidget {
  const RecipeOfDayWidget({super.key});

  @override
  _RecipeOfDayWidgetState createState() => _RecipeOfDayWidgetState();
}

class _RecipeOfDayWidgetState extends State<RecipeOfDayWidget> {
  late ApiService apiService;
  bool isLoading = true;
  late RecipeOfDay? recipeOfDay;

  @override
  void initState() {
    super.initState();
    apiService = ApiService();
    unawaited(getRecipeOfDay());
  }

  Future<void> getRecipeOfDay() async {
    Response<dynamic> response;

    try {
      response = await apiService.getRequest('recipes/recipe-of-day');
      isLoading = false;
      if (response.statusCode == 200) {
        setState(() {
          recipeOfDay = RecipeOfDay.fromJson(
            jsonDecode(response.data as String) as Map<String, dynamic>,
          );
        });
      } else {}
    } on Exception catch (e) {
      setState(() {
        recipeOfDay = null;
      });
      isLoading = false;
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SizedBox(
        height: 500,
        child: Center(child: CircularProgressIndicator(color: Palette.orange)),
      );
    }
    if (recipeOfDay == null) {
      return SizedBox(
        height: 500,
        child: Center(
          child: Text(
            'Не удалось найти рецепт',
            style: Theme.of(context).textTheme.m24.copyWith(color: Palette.red),
          ),
        ),
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextButton(
          onPressed: () {
            context.beamToNamed('/recipes/${recipeOfDay!.recipeId}');
          },
          style: TextButton.styleFrom(
            foregroundColor: Palette.orange,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(72),
                bottomRight: Radius.circular(72),
              ),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: RecipeImageWithAuthor(
            imageUrl: recipeOfDay!.imageUrl,
            username: recipeOfDay!.username,
            size: 543,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(left: 62),
          width: 513,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Icon(
                    Icons.favorite_outline,
                    color: Palette.grey,
                    size: 20,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    recipeOfDay!.likesCount.toString(),
                    style: Theme.of(context).textTheme.r16,
                  ),
                  const SizedBox(width: 27),
                  const Icon(
                    Icons.timer,
                    size: 20,
                    color: Palette.grey,
                  ),
                  const SizedBox(width: 7),
                  Text(
                    '${recipeOfDay!.cookingTimeInMinutes} минут',
                    style: Theme.of(context).textTheme.r16,
                  ),
                ],
              ),
              SvgPicture.asset(
                CookingIcons.recipeOfDay,
                height: 95,
              ),
              const SizedBox(height: 32),
              Text(
                recipeOfDay!.title,
                style: Theme.of(context).textTheme.b42,
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              Text(
                recipeOfDay!.description,
                style: Theme.of(context).textTheme.r18,
              ),
            ],
          ),
        )
      ],
    );
  }
}
