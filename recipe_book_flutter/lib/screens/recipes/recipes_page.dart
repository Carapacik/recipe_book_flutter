import 'dart:async';
import 'dart:convert';

import 'package:beamer/beamer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:recipe_book_flutter/notifier/auth_notifier.dart';
import 'package:recipe_book_flutter/notifier/recipe_notifier.dart';
import 'package:recipe_book_flutter/resources/icons.dart';
import 'package:recipe_book_flutter/resources/images.dart';
import 'package:recipe_book_flutter/resources/palette.dart';
import 'package:recipe_book_flutter/service/api_service.dart';
import 'package:recipe_book_flutter/theme.dart';
import 'package:recipe_book_flutter/widgets/category_card.dart';
import 'package:recipe_book_flutter/widgets/contained_button.dart';
import 'package:recipe_book_flutter/widgets/header_buttons.dart';
import 'package:recipe_book_flutter/widgets/header_widget.dart';
import 'package:recipe_book_flutter/widgets/not_auth_dialog.dart';
import 'package:recipe_book_flutter/widgets/outlined_button.dart';
import 'package:recipe_book_flutter/widgets/recipe_list_widget.dart';

// ignore: must_be_immutable
class RecipesPage extends StatefulWidget {
  RecipesPage({
    this.searchQuery,
    super.key,
  });

  String? searchQuery;

  @override
  _RecipesPageState createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  late ApiService apiService;
  late RecipeNotifier recipeNotifier;
  TextEditingController? textController = TextEditingController();
  bool isEndOfList = true;
  int skipCounter = 0;

  Future<void> searchRecipes() async {
    Response<dynamic> response;

    try {
      response = await apiService.getRequestWithParam(
        endPoint: 'recipes',
        take: 4,
        skip: skipCounter,
        searchQuery: widget.searchQuery,
      );
      if (response.statusCode == 200) {
        final listOfRecipes =
            jsonDecode(response.data as String) as List<dynamic>;
        if (listOfRecipes.length == 4) {
          setState(() {
            isEndOfList = false;
          });
        }
        if (widget.searchQuery!.isEmpty) {
          recipeNotifier.resultString = 'Ничего не найдено';
        } else {
          recipeNotifier.resultString =
              '''По запросу "${widget.searchQuery}" ничего не найдено''';
        }
        if (skipCounter == 0) {
          recipeNotifier.addClearRecipes(listOfRecipes);
        } else {
          recipeNotifier.addRecipes(listOfRecipes);
        }
        textController?.text = widget.searchQuery!;
        skipCounter += 4;
      } else {}
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> getMoreRecipes() async {
    Response<dynamic> response;

    try {
      response = await apiService.getRequestWithParam(
        endPoint: 'recipes',
        take: 4,
        skip: skipCounter,
      );
      if (response.statusCode == 200) {
        final listOfRecipes =
            jsonDecode(response.data as String) as List<dynamic>;
        if (listOfRecipes.length == 4) {
          setState(() {
            isEndOfList = false;
          });
        } else {
          setState(() {
            isEndOfList = true;
          });
        }
        recipeNotifier.addRecipes(listOfRecipes);
        skipCounter += 4;
      } else {}
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> getInitialRecipes() async {
    Response<dynamic> response;

    try {
      response = await apiService.getInitialWithParam('recipes', 4);
      if (response.statusCode == 200) {
        final listOfRecipes =
            jsonDecode(response.data as String) as List<dynamic>;
        if (listOfRecipes.length == 4) {
          setState(() {
            isEndOfList = false;
          });
        }
        recipeNotifier.addClearRecipes(listOfRecipes);
        skipCounter += 4;
      } else {}
    } on Exception catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  void initState() {
    apiService = ApiService();
    if (widget.searchQuery != null) {
      unawaited(searchRecipes());
    } else {
      unawaited(getInitialRecipes());
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    recipeNotifier = Provider.of<RecipeNotifier>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            SvgPicture.asset(
              CookingImages.wave1,
              colorFilter:
                  const ColorFilter.mode(Palette.wave, BlendMode.srcIn),
              width: MediaQuery.of(context).size.width,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 900),
              child: SvgPicture.asset(
                CookingImages.wave2,
                width: MediaQuery.of(context).size.width,
                colorFilter:
                    const ColorFilter.mode(Palette.wave, BlendMode.srcIn),
              ),
            ),
            const HeaderWidget(currentSelectedPage: HeaderButtons.recipes),
            Center(
              child: Container(
                alignment: Alignment.topLeft,
                constraints: const BoxConstraints(maxWidth: 1200),
                margin: const EdgeInsets.only(top: 160),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Рецепты',
                          style: Theme.of(context).textTheme.b42,
                        ),
                        Consumer<AuthNotifier>(
                          builder: (context, auth, child) =>
                              ButtonContainedWidget(
                            icon: Icons.add,
                            padding: 18,
                            text: 'Добавить рецепт',
                            width: 278,
                            height: 60,
                            onPressed: auth.isAuth
                                ? () {
                                    context.beamToNamed('/recipes/add');
                                  }
                                : () {
                                    notAuthDialog(
                                      context,
                                      'Добавлять рецепты могут только зарегистрированные пользователи.',
                                    );
                                  },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CategoryCardWidget(
                          iconPath: CookingIcons.menu,
                          title: 'Простые блюда',
                          onPressed: () async {
                            skipCounter = 0;
                            isEndOfList = false;
                            widget.searchQuery = 'простое';
                            context.currentBeamLocation.update(
                              (state) => state.copyWith(
                                pathBlueprintSegments: ['recipes'],
                                queryParameters: {
                                  'searchQuery': widget.searchQuery!
                                },
                              ),
                            );
                            await searchRecipes();
                          },
                        ),
                        CategoryCardWidget(
                          iconPath: CookingIcons.cook,
                          title: 'Детское',
                          onPressed: () async {
                            skipCounter = 0;
                            isEndOfList = false;
                            widget.searchQuery = 'детское';
                            context.currentBeamLocation.update(
                              (state) => state.copyWith(
                                pathBlueprintSegments: ['recipes'],
                                queryParameters: {
                                  'searchQuery': widget.searchQuery!
                                },
                              ),
                            );
                            await searchRecipes();
                          },
                        ),
                        CategoryCardWidget(
                          iconPath: CookingIcons.chef,
                          title: 'От шеф-поваров',
                          onPressed: () async {
                            skipCounter = 0;
                            isEndOfList = false;
                            widget.searchQuery = 'шеф-повар';
                            context.currentBeamLocation.update(
                              (state) => state.copyWith(
                                pathBlueprintSegments: ['recipes'],
                                queryParameters: {
                                  'searchQuery': widget.searchQuery!
                                },
                              ),
                            );
                            await searchRecipes();
                          },
                        ),
                        CategoryCardWidget(
                          iconPath: CookingIcons.confetti,
                          title: 'На праздник',
                          onPressed: () async {
                            skipCounter = 0;
                            isEndOfList = false;
                            widget.searchQuery = 'праздник';
                            context.currentBeamLocation.update(
                              (state) => state.copyWith(
                                pathBlueprintSegments: ['recipes'],
                                queryParameters: {
                                  'searchQuery': widget.searchQuery!
                                },
                              ),
                            );
                            await searchRecipes();
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Поиск рецепта',
                          style: Theme.of(context).textTheme.b24,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              height: 73,
                              width: 779,
                              padding: const EdgeInsets.symmetric(
                                vertical: 28,
                                horizontal: 32,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Palette.shadowColor,
                                    offset: Offset(0, 8),
                                    blurRadius: 42,
                                  )
                                ],
                              ),
                              child: TextField(
                                controller: textController,
                                cursorColor: Palette.orange,
                                style: Theme.of(context)
                                    .textTheme
                                    .r18
                                    .copyWith(color: Palette.main),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Название блюда...',
                                  hintStyle: Theme.of(context).textTheme.r16,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            ButtonContainedWidget(
                              text: 'Поиск',
                              width: 152,
                              height: 73,
                              onPressed: () async {
                                skipCounter = 0;
                                isEndOfList = false;
                                widget.searchQuery = textController!.text;
                                context.currentBeamLocation.update(
                                  (state) => state.copyWith(
                                    pathBlueprintSegments: ['recipes'],
                                    queryParameters: {
                                      'searchQuery': widget.searchQuery!
                                    },
                                  ),
                                );
                                await searchRecipes();
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                    const SizedBox(height: 80),
                    const Center(child: RecipeListWidget()),
                    const SizedBox(height: 65),
                    if (!isEndOfList)
                      ButtonOutlinedWidget(
                        text: 'Загрузить еще',
                        width: 309,
                        height: 60,
                        onPressed: getMoreRecipes,
                      ),
                    const SizedBox(height: 108),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
