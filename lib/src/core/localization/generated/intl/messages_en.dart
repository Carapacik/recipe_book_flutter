// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
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
  String get localeName => 'en';

  static String m0(author) => "Author: ${author}";

  static String m1(minutes, likes) => "${minutes} min • ${likes} likes";

  static String m2(title) => "‘${title}’ cannot be restored.";

  static String m3(number) => "Group ${number}";

  static String m4(count) =>
      "${Intl.plural(count, one: '1 image', other: '${count} images')}";

  static String m5(number) => "Image ${number}";

  static String m6(count) => "${count} min";

  static String m7(min, max) => "Enter a number from ${min} to ${max}";

  static String m8(count) => "${count} portions";

  static String m9(number) => "Step ${number}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("About"),
    "addIngredient": MessageLookupByLibrary.simpleMessage("Add ingredient"),
    "addRecipe": MessageLookupByLibrary.simpleMessage("Add recipe"),
    "alreadyHaveAccount": MessageLookupByLibrary.simpleMessage(
      "I already have an account",
    ),
    "appTitle": MessageLookupByLibrary.simpleMessage("Recipe Book"),
    "authorLabel": m0,
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "catalogSearchHint": MessageLookupByLibrary.simpleMessage(
      "Search by title, description, or tag",
    ),
    "categoryChef": MessageLookupByLibrary.simpleMessage("From chefs"),
    "categoryEasy": MessageLookupByLibrary.simpleMessage("Easy dishes"),
    "categoryHoliday": MessageLookupByLibrary.simpleMessage(
      "For a celebration",
    ),
    "categoryKids": MessageLookupByLibrary.simpleMessage("Kids menu"),
    "choose": MessageLookupByLibrary.simpleMessage("Choose"),
    "chooseAtLeastTwoImages": MessageLookupByLibrary.simpleMessage(
      "Add at least two images",
    ),
    "chooseImages": MessageLookupByLibrary.simpleMessage("Choose images"),
    "close": MessageLookupByLibrary.simpleMessage("Close"),
    "cookingSteps": MessageLookupByLibrary.simpleMessage("Cooking steps"),
    "cookingTimeLabel": MessageLookupByLibrary.simpleMessage(
      "Cooking time, min",
    ),
    "create": MessageLookupByLibrary.simpleMessage("Create"),
    "createAccount": MessageLookupByLibrary.simpleMessage("Create account"),
    "createRecipe": MessageLookupByLibrary.simpleMessage("Create recipe"),
    "dailyRecipeMeta": m1,
    "dailyUnavailable": MessageLookupByLibrary.simpleMessage(
      "The recipe of the day is unavailable",
    ),
    "delete": MessageLookupByLibrary.simpleMessage("Delete"),
    "deleteRecipeMessage": m2,
    "deleteRecipeTitle": MessageLookupByLibrary.simpleMessage("Delete recipe?"),
    "edit": MessageLookupByLibrary.simpleMessage("Edit"),
    "editing": MessageLookupByLibrary.simpleMessage("Editing"),
    "email": MessageLookupByLibrary.simpleMessage("Email"),
    "favoriteTooltip": MessageLookupByLibrary.simpleMessage("Favorite"),
    "favoritesCountLabel": MessageLookupByLibrary.simpleMessage("Favorites"),
    "favoritesEmpty": MessageLookupByLibrary.simpleMessage(
      "Add recipes to favorites and they will appear here.",
    ),
    "fillField": MessageLookupByLibrary.simpleMessage("Fill in this field"),
    "goHome": MessageLookupByLibrary.simpleMessage("Go home"),
    "group": MessageLookupByLibrary.simpleMessage("Group"),
    "groupNumber": m3,
    "heroDescription": MessageLookupByLibrary.simpleMessage(
      "Keep favorite recipes in one place and discover fresh ideas every day.",
    ),
    "heroTitle": MessageLookupByLibrary.simpleMessage("Cook and share recipes"),
    "homeMoodTitle": MessageLookupByLibrary.simpleMessage(
      "Find a dish for your mood",
    ),
    "imageCount": m4,
    "imageNumber": m5,
    "images": MessageLookupByLibrary.simpleMessage("Images"),
    "ingredient": MessageLookupByLibrary.simpleMessage("Ingredient"),
    "ingredients": MessageLookupByLibrary.simpleMessage("Ingredients"),
    "invalidEmail": MessageLookupByLibrary.simpleMessage("Enter a valid email"),
    "likeTooltip": MessageLookupByLibrary.simpleMessage("Like"),
    "likesCountLabel": MessageLookupByLibrary.simpleMessage("Likes"),
    "loginDescription": MessageLookupByLibrary.simpleMessage(
      "Sign in to open your profile and favorites.",
    ),
    "mainImage": MessageLookupByLibrary.simpleMessage("Main image"),
    "minimumEightCharacters": MessageLookupByLibrary.simpleMessage(
      "At least 8 characters",
    ),
    "minimumTwoCharacters": MessageLookupByLibrary.simpleMessage(
      "At least 2 characters",
    ),
    "minutes": m6,
    "myRecipes": MessageLookupByLibrary.simpleMessage("My recipes"),
    "name": MessageLookupByLibrary.simpleMessage("Name"),
    "navFavorites": MessageLookupByLibrary.simpleMessage("Favorites"),
    "navHome": MessageLookupByLibrary.simpleMessage("Home"),
    "navProfile": MessageLookupByLibrary.simpleMessage("Profile"),
    "navRecipes": MessageLookupByLibrary.simpleMessage("Recipes"),
    "newPasswordOptional": MessageLookupByLibrary.simpleMessage(
      "New password (optional)",
    ),
    "newRecipe": MessageLookupByLibrary.simpleMessage("New recipe"),
    "nextImage": MessageLookupByLibrary.simpleMessage("Next image"),
    "noPublishedRecipes": MessageLookupByLibrary.simpleMessage(
      "You have not published any recipes yet.",
    ),
    "numberRange": m7,
    "pageNotFound": MessageLookupByLibrary.simpleMessage("Page not found"),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "popularTagsDescription": MessageLookupByLibrary.simpleMessage(
      "Popular tags help you quickly discover the right recipes.",
    ),
    "portions": MessageLookupByLibrary.simpleMessage("Portions"),
    "portionsCount": m8,
    "preparation": MessageLookupByLibrary.simpleMessage("Preparation"),
    "previousImage": MessageLookupByLibrary.simpleMessage("Previous image"),
    "profileNotFound": MessageLookupByLibrary.simpleMessage(
      "Profile not found",
    ),
    "recipe": MessageLookupByLibrary.simpleMessage("Recipe"),
    "recipeOfDay": MessageLookupByLibrary.simpleMessage("Recipe of the day"),
    "recipesCountLabel": MessageLookupByLibrary.simpleMessage("Recipes"),
    "recipesNotFound": MessageLookupByLibrary.simpleMessage("No recipes found"),
    "registerDescription": MessageLookupByLibrary.simpleMessage(
      "Save favorite recipes and share your own.",
    ),
    "removeImage": MessageLookupByLibrary.simpleMessage("Remove image"),
    "replace": MessageLookupByLibrary.simpleMessage("Replace"),
    "requiredField": MessageLookupByLibrary.simpleMessage("Required field"),
    "retry": MessageLookupByLibrary.simpleMessage("Retry"),
    "save": MessageLookupByLibrary.simpleMessage("Save"),
    "searchHint": MessageLookupByLibrary.simpleMessage(
      "Title, description, or tag",
    ),
    "searchRecipes": MessageLookupByLibrary.simpleMessage("Search recipes"),
    "selectAtLeastTwoImages": MessageLookupByLibrary.simpleMessage(
      "Select at least two recipe images.",
    ),
    "shortDescription": MessageLookupByLibrary.simpleMessage(
      "Short description",
    ),
    "showMore": MessageLookupByLibrary.simpleMessage("Show more"),
    "signIn": MessageLookupByLibrary.simpleMessage("Sign in"),
    "signOut": MessageLookupByLibrary.simpleMessage("Sign out"),
    "stepActionHint": MessageLookupByLibrary.simpleMessage(
      "Describe the action",
    ),
    "stepNumber": m9,
    "switchLanguage": MessageLookupByLibrary.simpleMessage("Switch language"),
    "tagHint": MessageLookupByLibrary.simpleMessage("For example, breakfast"),
    "tags": MessageLookupByLibrary.simpleMessage("Tags"),
    "title": MessageLookupByLibrary.simpleMessage("Title"),
    "welcomeBack": MessageLookupByLibrary.simpleMessage("Welcome back"),
  };
}
