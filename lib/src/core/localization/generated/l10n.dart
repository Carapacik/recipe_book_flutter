// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class AppLocalizations {
  AppLocalizations();

  static AppLocalizations? _current;

  static AppLocalizations get current {
    assert(
      _current != null,
      'No instance of AppLocalizations was loaded. Try to initialize the AppLocalizations delegate before accessing AppLocalizations.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<AppLocalizations> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = AppLocalizations();
      AppLocalizations._current = instance;

      return instance;
    });
  }

  static AppLocalizations of(BuildContext context) {
    final instance = AppLocalizations.maybeOf(context);
    assert(
      instance != null,
      'No instance of AppLocalizations present in the widget tree. Did you add AppLocalizations.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static AppLocalizations? maybeOf(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// `Recipe Book`
  String get appTitle {
    return Intl.message('Recipe Book', name: 'appTitle', desc: '', args: []);
  }

  /// `Сменить язык`
  String get switchLanguage {
    return Intl.message(
      'Сменить язык',
      name: 'switchLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Главная`
  String get navHome {
    return Intl.message('Главная', name: 'navHome', desc: '', args: []);
  }

  /// `Рецепты`
  String get navRecipes {
    return Intl.message('Рецепты', name: 'navRecipes', desc: '', args: []);
  }

  /// `Избранное`
  String get navFavorites {
    return Intl.message('Избранное', name: 'navFavorites', desc: '', args: []);
  }

  /// `Профиль`
  String get navProfile {
    return Intl.message('Профиль', name: 'navProfile', desc: '', args: []);
  }

  /// `Войти`
  String get signIn {
    return Intl.message('Войти', name: 'signIn', desc: '', args: []);
  }

  /// `Выйти`
  String get signOut {
    return Intl.message('Выйти', name: 'signOut', desc: '', args: []);
  }

  /// `Создать аккаунт`
  String get createAccount {
    return Intl.message(
      'Создать аккаунт',
      name: 'createAccount',
      desc: '',
      args: [],
    );
  }

  /// `С возвращением`
  String get welcomeBack {
    return Intl.message(
      'С возвращением',
      name: 'welcomeBack',
      desc: '',
      args: [],
    );
  }

  /// `Сохраняйте любимые рецепты и делитесь своими.`
  String get registerDescription {
    return Intl.message(
      'Сохраняйте любимые рецепты и делитесь своими.',
      name: 'registerDescription',
      desc: '',
      args: [],
    );
  }

  /// `Войдите, чтобы открыть профиль и избранное.`
  String get loginDescription {
    return Intl.message(
      'Войдите, чтобы открыть профиль и избранное.',
      name: 'loginDescription',
      desc: '',
      args: [],
    );
  }

  /// `Закрыть`
  String get close {
    return Intl.message('Закрыть', name: 'close', desc: '', args: []);
  }

  /// `Имя`
  String get name {
    return Intl.message('Имя', name: 'name', desc: '', args: []);
  }

  /// `Email`
  String get email {
    return Intl.message('Email', name: 'email', desc: '', args: []);
  }

  /// `Пароль`
  String get password {
    return Intl.message('Пароль', name: 'password', desc: '', args: []);
  }

  /// `Минимум 2 символа`
  String get minimumTwoCharacters {
    return Intl.message(
      'Минимум 2 символа',
      name: 'minimumTwoCharacters',
      desc: '',
      args: [],
    );
  }

  /// `Минимум 8 символов`
  String get minimumEightCharacters {
    return Intl.message(
      'Минимум 8 символов',
      name: 'minimumEightCharacters',
      desc: '',
      args: [],
    );
  }

  /// `Введите корректный email`
  String get invalidEmail {
    return Intl.message(
      'Введите корректный email',
      name: 'invalidEmail',
      desc: '',
      args: [],
    );
  }

  /// `У меня есть аккаунт`
  String get alreadyHaveAccount {
    return Intl.message(
      'У меня есть аккаунт',
      name: 'alreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Создать`
  String get create {
    return Intl.message('Создать', name: 'create', desc: '', args: []);
  }

  /// `Найдите блюдо по настроению`
  String get homeMoodTitle {
    return Intl.message(
      'Найдите блюдо по настроению',
      name: 'homeMoodTitle',
      desc: '',
      args: [],
    );
  }

  /// `Популярные теги помогают быстро перейти к подходящим рецептам.`
  String get popularTagsDescription {
    return Intl.message(
      'Популярные теги помогают быстро перейти к подходящим рецептам.',
      name: 'popularTagsDescription',
      desc: '',
      args: [],
    );
  }

  /// `Простые блюда`
  String get categoryEasy {
    return Intl.message(
      'Простые блюда',
      name: 'categoryEasy',
      desc: '',
      args: [],
    );
  }

  /// `Детское меню`
  String get categoryKids {
    return Intl.message(
      'Детское меню',
      name: 'categoryKids',
      desc: '',
      args: [],
    );
  }

  /// `От шеф-поваров`
  String get categoryChef {
    return Intl.message(
      'От шеф-поваров',
      name: 'categoryChef',
      desc: '',
      args: [],
    );
  }

  /// `На праздник`
  String get categoryHoliday {
    return Intl.message(
      'На праздник',
      name: 'categoryHoliday',
      desc: '',
      args: [],
    );
  }

  /// `Рецепт дня`
  String get recipeOfDay {
    return Intl.message('Рецепт дня', name: 'recipeOfDay', desc: '', args: []);
  }

  /// `Готовь и делись рецептами`
  String get heroTitle {
    return Intl.message(
      'Готовь и делись рецептами',
      name: 'heroTitle',
      desc: '',
      args: [],
    );
  }

  /// `Храни любимые рецепты в одном месте и открывай новые идеи каждый день.`
  String get heroDescription {
    return Intl.message(
      'Храни любимые рецепты в одном месте и открывай новые идеи каждый день.',
      name: 'heroDescription',
      desc: '',
      args: [],
    );
  }

  /// `Добавить рецепт`
  String get addRecipe {
    return Intl.message(
      'Добавить рецепт',
      name: 'addRecipe',
      desc: '',
      args: [],
    );
  }

  /// `{minutes} мин • {likes} отметок «нравится»`
  String dailyRecipeMeta(Object minutes, Object likes) {
    return Intl.message(
      '$minutes мин • $likes отметок «нравится»',
      name: 'dailyRecipeMeta',
      desc: '',
      args: [minutes, likes],
    );
  }

  /// `Рецепт дня пока недоступен`
  String get dailyUnavailable {
    return Intl.message(
      'Рецепт дня пока недоступен',
      name: 'dailyUnavailable',
      desc: '',
      args: [],
    );
  }

  /// `Повторить`
  String get retry {
    return Intl.message('Повторить', name: 'retry', desc: '', args: []);
  }

  /// `Поиск рецептов`
  String get searchRecipes {
    return Intl.message(
      'Поиск рецептов',
      name: 'searchRecipes',
      desc: '',
      args: [],
    );
  }

  /// `Название, описание или тег`
  String get searchHint {
    return Intl.message(
      'Название, описание или тег',
      name: 'searchHint',
      desc: '',
      args: [],
    );
  }

  /// `Поиск по названию, описанию или тегу`
  String get catalogSearchHint {
    return Intl.message(
      'Поиск по названию, описанию или тегу',
      name: 'catalogSearchHint',
      desc: '',
      args: [],
    );
  }

  /// `Показать ещё`
  String get showMore {
    return Intl.message('Показать ещё', name: 'showMore', desc: '', args: []);
  }

  /// `Рецепты не найдены`
  String get recipesNotFound {
    return Intl.message(
      'Рецепты не найдены',
      name: 'recipesNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Добавляйте рецепты в избранное — они появятся здесь.`
  String get favoritesEmpty {
    return Intl.message(
      'Добавляйте рецепты в избранное — они появятся здесь.',
      name: 'favoritesEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Профиль не найден`
  String get profileNotFound {
    return Intl.message(
      'Профиль не найден',
      name: 'profileNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Мои рецепты`
  String get myRecipes {
    return Intl.message('Мои рецепты', name: 'myRecipes', desc: '', args: []);
  }

  /// `У вас пока нет опубликованных рецептов.`
  String get noPublishedRecipes {
    return Intl.message(
      'У вас пока нет опубликованных рецептов.',
      name: 'noPublishedRecipes',
      desc: '',
      args: [],
    );
  }

  /// `Редактировать`
  String get edit {
    return Intl.message('Редактировать', name: 'edit', desc: '', args: []);
  }

  /// `Отмена`
  String get cancel {
    return Intl.message('Отмена', name: 'cancel', desc: '', args: []);
  }

  /// `Сохранить`
  String get save {
    return Intl.message('Сохранить', name: 'save', desc: '', args: []);
  }

  /// `О себе`
  String get about {
    return Intl.message('О себе', name: 'about', desc: '', args: []);
  }

  /// `Новый пароль (необязательно)`
  String get newPasswordOptional {
    return Intl.message(
      'Новый пароль (необязательно)',
      name: 'newPasswordOptional',
      desc: '',
      args: [],
    );
  }

  /// `Рецептов`
  String get recipesCountLabel {
    return Intl.message(
      'Рецептов',
      name: 'recipesCountLabel',
      desc: '',
      args: [],
    );
  }

  /// `Лайков`
  String get likesCountLabel {
    return Intl.message('Лайков', name: 'likesCountLabel', desc: '', args: []);
  }

  /// `В избранном`
  String get favoritesCountLabel {
    return Intl.message(
      'В избранном',
      name: 'favoritesCountLabel',
      desc: '',
      args: [],
    );
  }

  /// `Рецепт`
  String get recipe {
    return Intl.message('Рецепт', name: 'recipe', desc: '', args: []);
  }

  /// `Новый рецепт`
  String get newRecipe {
    return Intl.message('Новый рецепт', name: 'newRecipe', desc: '', args: []);
  }

  /// `Редактирование`
  String get editing {
    return Intl.message('Редактирование', name: 'editing', desc: '', args: []);
  }

  /// `Название`
  String get title {
    return Intl.message('Название', name: 'title', desc: '', args: []);
  }

  /// `Краткое описание`
  String get shortDescription {
    return Intl.message(
      'Краткое описание',
      name: 'shortDescription',
      desc: '',
      args: [],
    );
  }

  /// `Время приготовления, мин`
  String get cookingTimeLabel {
    return Intl.message(
      'Время приготовления, мин',
      name: 'cookingTimeLabel',
      desc: '',
      args: [],
    );
  }

  /// `Порции`
  String get portions {
    return Intl.message('Порции', name: 'portions', desc: '', args: []);
  }

  /// `Теги`
  String get tags {
    return Intl.message('Теги', name: 'tags', desc: '', args: []);
  }

  /// `Например, завтрак`
  String get tagHint {
    return Intl.message(
      'Например, завтрак',
      name: 'tagHint',
      desc: '',
      args: [],
    );
  }

  /// `Шаги приготовления`
  String get cookingSteps {
    return Intl.message(
      'Шаги приготовления',
      name: 'cookingSteps',
      desc: '',
      args: [],
    );
  }

  /// `Опишите действие`
  String get stepActionHint {
    return Intl.message(
      'Опишите действие',
      name: 'stepActionHint',
      desc: '',
      args: [],
    );
  }

  /// `Ингредиенты`
  String get ingredients {
    return Intl.message('Ингредиенты', name: 'ingredients', desc: '', args: []);
  }

  /// `Группа`
  String get group {
    return Intl.message('Группа', name: 'group', desc: '', args: []);
  }

  /// `Создать рецепт`
  String get createRecipe {
    return Intl.message(
      'Создать рецепт',
      name: 'createRecipe',
      desc: '',
      args: [],
    );
  }

  /// `Изображения`
  String get images {
    return Intl.message('Изображения', name: 'images', desc: '', args: []);
  }

  /// `Добавьте минимум два изображения`
  String get chooseAtLeastTwoImages {
    return Intl.message(
      'Добавьте минимум два изображения',
      name: 'chooseAtLeastTwoImages',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, =1{1 изображение} few{{count} изображения} many{{count} изображений} other{{count} изображения}}`
  String imageCount(num count) {
    return Intl.plural(
      count,
      one: '1 изображение',
      few: '$count изображения',
      many: '$count изображений',
      other: '$count изображения',
      name: 'imageCount',
      desc: '',
      args: [count],
    );
  }

  /// `Выбрать`
  String get choose {
    return Intl.message('Выбрать', name: 'choose', desc: '', args: []);
  }

  /// `Заменить`
  String get replace {
    return Intl.message('Заменить', name: 'replace', desc: '', args: []);
  }

  /// `Удалить изображение`
  String get removeImage {
    return Intl.message(
      'Удалить изображение',
      name: 'removeImage',
      desc: '',
      args: [],
    );
  }

  /// `Главное изображение`
  String get mainImage {
    return Intl.message(
      'Главное изображение',
      name: 'mainImage',
      desc: '',
      args: [],
    );
  }

  /// `Изображение {number}`
  String imageNumber(Object number) {
    return Intl.message(
      'Изображение $number',
      name: 'imageNumber',
      desc: '',
      args: [number],
    );
  }

  /// `Выбрать изображения`
  String get chooseImages {
    return Intl.message(
      'Выбрать изображения',
      name: 'chooseImages',
      desc: '',
      args: [],
    );
  }

  /// `Шаг {number}`
  String stepNumber(Object number) {
    return Intl.message(
      'Шаг $number',
      name: 'stepNumber',
      desc: '',
      args: [number],
    );
  }

  /// `Заполните поле`
  String get fillField {
    return Intl.message(
      'Заполните поле',
      name: 'fillField',
      desc: '',
      args: [],
    );
  }

  /// `Группа {number}`
  String groupNumber(Object number) {
    return Intl.message(
      'Группа $number',
      name: 'groupNumber',
      desc: '',
      args: [number],
    );
  }

  /// `Ингредиент`
  String get ingredient {
    return Intl.message('Ингредиент', name: 'ingredient', desc: '', args: []);
  }

  /// `Добавить ингредиент`
  String get addIngredient {
    return Intl.message(
      'Добавить ингредиент',
      name: 'addIngredient',
      desc: '',
      args: [],
    );
  }

  /// `Обязательное поле`
  String get requiredField {
    return Intl.message(
      'Обязательное поле',
      name: 'requiredField',
      desc: '',
      args: [],
    );
  }

  /// `Введите число от {min} до {max}`
  String numberRange(Object min, Object max) {
    return Intl.message(
      'Введите число от $min до $max',
      name: 'numberRange',
      desc: '',
      args: [min, max],
    );
  }

  /// `Выберите минимум два изображения рецепта.`
  String get selectAtLeastTwoImages {
    return Intl.message(
      'Выберите минимум два изображения рецепта.',
      name: 'selectAtLeastTwoImages',
      desc: '',
      args: [],
    );
  }

  /// `Удалить рецепт?`
  String get deleteRecipeTitle {
    return Intl.message(
      'Удалить рецепт?',
      name: 'deleteRecipeTitle',
      desc: '',
      args: [],
    );
  }

  /// `«{title}» нельзя будет восстановить.`
  String deleteRecipeMessage(Object title) {
    return Intl.message(
      '«$title» нельзя будет восстановить.',
      name: 'deleteRecipeMessage',
      desc: '',
      args: [title],
    );
  }

  /// `Удалить`
  String get delete {
    return Intl.message('Удалить', name: 'delete', desc: '', args: []);
  }

  /// `Автор: {author}`
  String authorLabel(Object author) {
    return Intl.message(
      'Автор: $author',
      name: 'authorLabel',
      desc: '',
      args: [author],
    );
  }

  /// `{count} мин`
  String minutes(Object count) {
    return Intl.message('$count мин', name: 'minutes', desc: '', args: [count]);
  }

  /// `{count} порций`
  String portionsCount(Object count) {
    return Intl.message(
      '$count порций',
      name: 'portionsCount',
      desc: '',
      args: [count],
    );
  }

  /// `Приготовление`
  String get preparation {
    return Intl.message(
      'Приготовление',
      name: 'preparation',
      desc: '',
      args: [],
    );
  }

  /// `Избранное`
  String get favoriteTooltip {
    return Intl.message(
      'Избранное',
      name: 'favoriteTooltip',
      desc: '',
      args: [],
    );
  }

  /// `Нравится`
  String get likeTooltip {
    return Intl.message('Нравится', name: 'likeTooltip', desc: '', args: []);
  }

  /// `Предыдущее изображение`
  String get previousImage {
    return Intl.message(
      'Предыдущее изображение',
      name: 'previousImage',
      desc: '',
      args: [],
    );
  }

  /// `Следующее изображение`
  String get nextImage {
    return Intl.message(
      'Следующее изображение',
      name: 'nextImage',
      desc: '',
      args: [],
    );
  }

  /// `Страница не найдена`
  String get pageNotFound {
    return Intl.message(
      'Страница не найдена',
      name: 'pageNotFound',
      desc: '',
      args: [],
    );
  }

  /// `На главную`
  String get goHome {
    return Intl.message('На главную', name: 'goHome', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'en'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
