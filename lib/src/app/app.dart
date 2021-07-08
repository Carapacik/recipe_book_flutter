import 'dart:async';

import 'package:flutter/material.dart';
import 'package:recipe_book_flutter/src/app/app_dependencies.dart';
import 'package:recipe_book_flutter/src/core/localization/locale_controller.dart';
import 'package:recipe_book_flutter/src/core/localization/localization.dart';
import 'package:recipe_book_flutter/src/core/navigation/app_router.dart';
import 'package:recipe_book_flutter/src/core/theme/app_theme.dart';
import 'package:recipe_book_flutter/src/features/auth/presentation/auth_controller.dart';

class const RecipeBookApp({
  required final AppDependencies dependencies,
  required final LocaleController localeController,
  super.key,
}) extends StatefulWidget {
  @override
  State<RecipeBookApp> createState() => _RecipeBookAppState();
}

class _RecipeBookAppState() extends State<RecipeBookApp> {
  late final AuthController _authController;

  @override
  void initState() {
    super.initState();
    _authController = AuthController(widget.dependencies.authRepository);
    unawaited(_authController.restore());
  }

  @override
  void dispose() {
    _authController.dispose();
    widget.localeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LocaleScope(
      notifier: widget.localeController,
      child: AppScope(
        dependencies: widget.dependencies,
        child: AuthScope(
          notifier: _authController,
          child: ListenableBuilder(
            listenable: widget.localeController,
            builder: (context, _) {
              return MaterialApp(
                title: 'Recipe Book',
                onGenerateTitle: (context) => context.l10n.appTitle,
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light,
                locale: widget.localeController.locale,
                localizationsDelegates: Localization.delegates,
                supportedLocales: Localization.supportedLocales,
                onGenerateRoute: AppRouter.onGenerateRoute,
              );
            },
          ),
        ),
      ),
    );
  }
}

class const LocaleScope({
  required LocaleController notifier,
  required super.child,
  super.key,
}) extends InheritedNotifier<LocaleController> {
  this : super(notifier: notifier);

  static LocaleController of(BuildContext context) {
    final LocaleScope? scope = context
        .dependOnInheritedWidgetOfExactType<LocaleScope>();
    assert(scope != null, 'LocaleScope was not found in the widget tree.');
    return scope!.notifier!;
  }
}

class const AppScope({
  required final AppDependencies dependencies,
  required super.child,
  super.key,
}) extends InheritedWidget {
  static AppDependencies of(BuildContext context) {
    final AppScope? scope = context
        .dependOnInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope was not found in the widget tree.');
    return scope!.dependencies;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) =>
      dependencies != oldWidget.dependencies;
}

class const AuthScope({
  required AuthController notifier,
  required super.child,
  super.key,
}) extends InheritedNotifier<AuthController> {
  this : super(notifier: notifier);

  static AuthController of(BuildContext context, {bool listen = true}) {
    if (listen) {
      final AuthScope? scope = context
          .dependOnInheritedWidgetOfExactType<AuthScope>();
      assert(scope != null, 'AuthScope was not found in the widget tree.');
      return scope!.notifier!;
    }

    final InheritedElement? element = context
        .getElementForInheritedWidgetOfExactType<AuthScope>();
    final scope = element?.widget as AuthScope?;
    assert(scope != null, 'AuthScope was not found in the widget tree.');
    return scope!.notifier!;
  }
}
