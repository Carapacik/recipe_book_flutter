import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:recipe_book_flutter/src/app/app.dart';
import 'package:recipe_book_flutter/src/core/layout/app_shell_scaffold.dart';
import 'package:recipe_book_flutter/src/core/localization/localization.dart';
import 'package:recipe_book_flutter/src/core/navigation/app_routes.dart';
import 'package:recipe_book_flutter/src/features/auth/presentation/auth_controller.dart';
import 'package:recipe_book_flutter/src/features/auth/presentation/auth_dialog.dart';
import 'package:recipe_book_flutter/src/features/favorites/presentation/favorites_screen.dart';
import 'package:recipe_book_flutter/src/features/home/presentation/home_screen.dart';
import 'package:recipe_book_flutter/src/features/profile/presentation/profile_screen.dart';
import 'package:recipe_book_flutter/src/features/recipes/presentation/screens/recipes_screen.dart';

class const AppShellScreen({
  final int initialIndex = 0,
  final String initialRecipeQuery = '',
  super.key,
}) extends StatefulWidget {
  @override
  State<AppShellScreen> createState() => _AppShellScreenState();
}

class _AppShellScreenState() extends State<AppShellScreen> {
  late int _selectedIndex = widget.initialIndex;
  late String _recipeQuery = widget.initialRecipeQuery;
  int _recipeGeneration = 0;
  bool _initialAuthScheduled = false;

  @override
  Widget build(BuildContext context) {
    final AuthController auth = AuthScope.of(context);
    final bool protected = _selectedIndex == 2 || _selectedIndex == 3;
    if (protected &&
        auth.status == AuthStatus.unauthenticated &&
        !_initialAuthScheduled) {
      _initialAuthScheduled = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        unawaited(_guardInitialDestination());
      });
    }
    return AppShellScaffold(
      selectedIndex: _selectedIndex,
      title: switch (_selectedIndex) {
        0 => context.l10n.appTitle,
        1 => context.l10n.navRecipes,
        2 => context.l10n.navFavorites,
        _ => context.l10n.navProfile,
      },
      onDestinationSelected: (index) => unawaited(_selectDestination(index)),
      body: protected && !auth.isAuthenticated
          ? const Center(child: CircularProgressIndicator())
          : AnimatedSwitcher(
              duration: const Duration(milliseconds: 320),
              reverseDuration: const Duration(milliseconds: 220),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              transitionBuilder: (child, animation) {
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.025, 0),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                );
              },
              child: switch (_selectedIndex) {
                0 => HomeScreen(
                  key: const ValueKey('home'),
                  onOpenRecipes: _openRecipes,
                ),
                1 => RecipesScreen(
                  key: ValueKey('recipes-$_recipeGeneration'),
                  initialQuery: _recipeQuery,
                ),
                2 => const FavoritesScreen(key: ValueKey('favorites')),
                _ => const ProfileScreen(key: ValueKey('profile')),
              },
            ),
    );
  }

  void _openRecipes(String query) {
    unawaited(_selectDestination(1, recipeQuery: query));
  }

  Future<void> _guardInitialDestination() async {
    try {
      final bool signedIn = await showAuthDialog(context);
      if (!signedIn && mounted) {
        setState(() => _selectedIndex = 0);
        await SystemNavigator.routeInformationUpdated(
          uri: Uri(path: AppRoutes.home),
          replace: true,
        );
      }
    } on Object catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(exception: error, stack: stackTrace),
      );
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }

  Future<void> _selectDestination(int index, {String? recipeQuery}) async {
    try {
      final bool protected = index == 2 || index == 3;
      if (protected && !AuthScope.of(context, listen: false).isAuthenticated) {
        final bool signedIn = await showAuthDialog(context);
        if (!signedIn || !mounted) {
          return;
        }
      }
      if (!mounted) {
        return;
      }
      setState(() {
        if (index == 1 && recipeQuery != null) {
          _recipeQuery = recipeQuery;
          _recipeGeneration++;
        }
        _selectedIndex = index;
      });
      await SystemNavigator.routeInformationUpdated(
        uri: Uri(path: AppRoutes.section(index)),
      );
    } on Object catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(exception: error, stack: stackTrace),
      );
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(error.toString())));
      }
    }
  }
}
