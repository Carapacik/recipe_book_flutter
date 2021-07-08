// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ru';

  static String m0(author) => "Автор: ${author}";

  static String m1(minutes, likes) =>
      "${minutes} мин • ${likes} отметок «нравится»";

  static String m2(title) => "«${title}» нельзя будет восстановить.";

  static String m3(number) => "Группа ${number}";

  static String m4(count) =>
      "${Intl.plural(count, one: '1 изображение', few: '${count} изображения', many: '${count} изображений', other: '${count} изображения')}";

  static String m5(number) => "Изображение ${number}";

  static String m6(count) => "${count} мин";

  static String m7(min, max) => "Введите число от ${min} до ${max}";

  static String m8(count) => "${count} порций";

  static String m9(number) => "Шаг ${number}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("О себе"),
    "addIngredient": MessageLookupByLibrary.simpleMessage(
      "Добавить ингредиент",
    ),
    "addRecipe": MessageLookupByLibrary.simpleMessage("Добавить рецепт"),
    "alreadyHaveAccount": MessageLookupByLibrary.simpleMessage(
      "У меня есть аккаунт",
    ),
    "appTitle": MessageLookupByLibrary.simpleMessage("Recipe Book"),
    "authorLabel": m0,
    "cancel": MessageLookupByLibrary.simpleMessage("Отмена"),
    "catalogSearchHint": MessageLookupByLibrary.simpleMessage(
      "Поиск по названию, описанию или тегу",
    ),
    "categoryChef": MessageLookupByLibrary.simpleMessage("От шеф-поваров"),
    "categoryEasy": MessageLookupByLibrary.simpleMessage("Простые блюда"),
    "categoryHoliday": MessageLookupByLibrary.simpleMessage("На праздник"),
    "categoryKids": MessageLookupByLibrary.simpleMessage("Детское меню"),
    "choose": MessageLookupByLibrary.simpleMessage("Выбрать"),
    "chooseAtLeastTwoImages": MessageLookupByLibrary.simpleMessage(
      "Добавьте минимум два изображения",
    ),
    "chooseImages": MessageLookupByLibrary.simpleMessage("Выбрать изображения"),
    "close": MessageLookupByLibrary.simpleMessage("Закрыть"),
    "cookingSteps": MessageLookupByLibrary.simpleMessage("Шаги приготовления"),
    "cookingTimeLabel": MessageLookupByLibrary.simpleMessage(
      "Время приготовления, мин",
    ),
    "create": MessageLookupByLibrary.simpleMessage("Создать"),
    "createAccount": MessageLookupByLibrary.simpleMessage("Создать аккаунт"),
    "createRecipe": MessageLookupByLibrary.simpleMessage("Создать рецепт"),
    "dailyRecipeMeta": m1,
    "dailyUnavailable": MessageLookupByLibrary.simpleMessage(
      "Рецепт дня пока недоступен",
    ),
    "delete": MessageLookupByLibrary.simpleMessage("Удалить"),
    "deleteRecipeMessage": m2,
    "deleteRecipeTitle": MessageLookupByLibrary.simpleMessage(
      "Удалить рецепт?",
    ),
    "edit": MessageLookupByLibrary.simpleMessage("Редактировать"),
    "editing": MessageLookupByLibrary.simpleMessage("Редактирование"),
    "email": MessageLookupByLibrary.simpleMessage("Email"),
    "favoriteTooltip": MessageLookupByLibrary.simpleMessage("Избранное"),
    "favoritesCountLabel": MessageLookupByLibrary.simpleMessage("В избранном"),
    "favoritesEmpty": MessageLookupByLibrary.simpleMessage(
      "Добавляйте рецепты в избранное — они появятся здесь.",
    ),
    "fillField": MessageLookupByLibrary.simpleMessage("Заполните поле"),
    "goHome": MessageLookupByLibrary.simpleMessage("На главную"),
    "group": MessageLookupByLibrary.simpleMessage("Группа"),
    "groupNumber": m3,
    "heroDescription": MessageLookupByLibrary.simpleMessage(
      "Храни любимые рецепты в одном месте и открывай новые идеи каждый день.",
    ),
    "heroTitle": MessageLookupByLibrary.simpleMessage(
      "Готовь и делись рецептами",
    ),
    "homeMoodTitle": MessageLookupByLibrary.simpleMessage(
      "Найдите блюдо по настроению",
    ),
    "imageCount": m4,
    "imageNumber": m5,
    "images": MessageLookupByLibrary.simpleMessage("Изображения"),
    "ingredient": MessageLookupByLibrary.simpleMessage("Ингредиент"),
    "ingredients": MessageLookupByLibrary.simpleMessage("Ингредиенты"),
    "invalidEmail": MessageLookupByLibrary.simpleMessage(
      "Введите корректный email",
    ),
    "likeTooltip": MessageLookupByLibrary.simpleMessage("Нравится"),
    "likesCountLabel": MessageLookupByLibrary.simpleMessage("Лайков"),
    "loginDescription": MessageLookupByLibrary.simpleMessage(
      "Войдите, чтобы открыть профиль и избранное.",
    ),
    "mainImage": MessageLookupByLibrary.simpleMessage("Главное изображение"),
    "minimumEightCharacters": MessageLookupByLibrary.simpleMessage(
      "Минимум 8 символов",
    ),
    "minimumTwoCharacters": MessageLookupByLibrary.simpleMessage(
      "Минимум 2 символа",
    ),
    "minutes": m6,
    "myRecipes": MessageLookupByLibrary.simpleMessage("Мои рецепты"),
    "name": MessageLookupByLibrary.simpleMessage("Имя"),
    "navFavorites": MessageLookupByLibrary.simpleMessage("Избранное"),
    "navHome": MessageLookupByLibrary.simpleMessage("Главная"),
    "navProfile": MessageLookupByLibrary.simpleMessage("Профиль"),
    "navRecipes": MessageLookupByLibrary.simpleMessage("Рецепты"),
    "newPasswordOptional": MessageLookupByLibrary.simpleMessage(
      "Новый пароль (необязательно)",
    ),
    "newRecipe": MessageLookupByLibrary.simpleMessage("Новый рецепт"),
    "nextImage": MessageLookupByLibrary.simpleMessage("Следующее изображение"),
    "noPublishedRecipes": MessageLookupByLibrary.simpleMessage(
      "У вас пока нет опубликованных рецептов.",
    ),
    "numberRange": m7,
    "pageNotFound": MessageLookupByLibrary.simpleMessage("Страница не найдена"),
    "password": MessageLookupByLibrary.simpleMessage("Пароль"),
    "popularTagsDescription": MessageLookupByLibrary.simpleMessage(
      "Популярные теги помогают быстро перейти к подходящим рецептам.",
    ),
    "portions": MessageLookupByLibrary.simpleMessage("Порции"),
    "portionsCount": m8,
    "preparation": MessageLookupByLibrary.simpleMessage("Приготовление"),
    "previousImage": MessageLookupByLibrary.simpleMessage(
      "Предыдущее изображение",
    ),
    "profileNotFound": MessageLookupByLibrary.simpleMessage(
      "Профиль не найден",
    ),
    "recipe": MessageLookupByLibrary.simpleMessage("Рецепт"),
    "recipeOfDay": MessageLookupByLibrary.simpleMessage("Рецепт дня"),
    "recipesCountLabel": MessageLookupByLibrary.simpleMessage("Рецептов"),
    "recipesNotFound": MessageLookupByLibrary.simpleMessage(
      "Рецепты не найдены",
    ),
    "registerDescription": MessageLookupByLibrary.simpleMessage(
      "Сохраняйте любимые рецепты и делитесь своими.",
    ),
    "removeImage": MessageLookupByLibrary.simpleMessage("Удалить изображение"),
    "replace": MessageLookupByLibrary.simpleMessage("Заменить"),
    "requiredField": MessageLookupByLibrary.simpleMessage("Обязательное поле"),
    "retry": MessageLookupByLibrary.simpleMessage("Повторить"),
    "save": MessageLookupByLibrary.simpleMessage("Сохранить"),
    "searchHint": MessageLookupByLibrary.simpleMessage(
      "Название, описание или тег",
    ),
    "searchRecipes": MessageLookupByLibrary.simpleMessage("Поиск рецептов"),
    "selectAtLeastTwoImages": MessageLookupByLibrary.simpleMessage(
      "Выберите минимум два изображения рецепта.",
    ),
    "shortDescription": MessageLookupByLibrary.simpleMessage(
      "Краткое описание",
    ),
    "showMore": MessageLookupByLibrary.simpleMessage("Показать ещё"),
    "signIn": MessageLookupByLibrary.simpleMessage("Войти"),
    "signOut": MessageLookupByLibrary.simpleMessage("Выйти"),
    "stepActionHint": MessageLookupByLibrary.simpleMessage("Опишите действие"),
    "stepNumber": m9,
    "switchLanguage": MessageLookupByLibrary.simpleMessage("Сменить язык"),
    "tagHint": MessageLookupByLibrary.simpleMessage("Например, завтрак"),
    "tags": MessageLookupByLibrary.simpleMessage("Теги"),
    "title": MessageLookupByLibrary.simpleMessage("Название"),
    "welcomeBack": MessageLookupByLibrary.simpleMessage("С возвращением"),
  };
}
