import 'package:flutter/material.dart';
import 'package:recipe_book_flutter/src/core/theme/app_colors.dart';

abstract final class AppTheme() {
  static ThemeData get light {
    final ColorScheme colorScheme =
        ColorScheme.fromSeed(
          seedColor: AppColors.orange,
          dynamicSchemeVariant: DynamicSchemeVariant.fidelity,
        ).copyWith(
          primary: AppColors.orange,
          onPrimary: AppColors.ink,
          secondary: const Color(0xFFD99400),
          tertiary: const Color(0xFFF28BA8),
          error: AppColors.red,
          surface: AppColors.wave,
          onSurface: AppColors.ink,
        );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      fontFamily: 'Montserrat',
      scaffoldBackgroundColor: colorScheme.surface,
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white.withAlpha(215),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        labelStyle: const TextStyle(color: AppColors.inkSoft),
        hintStyle: TextStyle(color: AppColors.inkSoft.withAlpha(150)),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: AppColors.orange.withAlpha(70)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: AppColors.orange.withAlpha(70)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.orange, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: AppColors.red, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
      ),
      cardTheme: CardThemeData(
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        color: Colors.white.withAlpha(175),
        shadowColor: AppColors.ink.withAlpha(24),
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(28),
          side: BorderSide(color: AppColors.orange.withAlpha(70), width: 1.2),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: Colors.white.withAlpha(235),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(32),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        height: 76,
        backgroundColor: Colors.white.withAlpha(205),
        indicatorColor: AppColors.orange.withAlpha(80),
        indicatorShape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        elevation: 0,
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: Colors.transparent,
        indicatorColor: AppColors.orange.withAlpha(80),
        indicatorShape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        minWidth: 80,
        minExtendedWidth: 230,
      ),
      searchBarTheme: SearchBarThemeData(
        backgroundColor: WidgetStatePropertyAll(Colors.white.withAlpha(175)),
        surfaceTintColor: const WidgetStatePropertyAll(Colors.transparent),
        elevation: const WidgetStatePropertyAll(0),
        side: WidgetStatePropertyAll(
          BorderSide(color: AppColors.orange.withAlpha(65)),
        ),
        shape: WidgetStatePropertyAll(
          RoundedSuperellipseBorder(borderRadius: BorderRadius.circular(24)),
        ),
        padding: const WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: 18),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.orange.withAlpha(230),
        foregroundColor: AppColors.ink,
        elevation: 0,
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(22),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          shape: RoundedSuperellipseBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedSuperellipseBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: Colors.white.withAlpha(180),
        side: BorderSide(color: AppColors.orange.withAlpha(70)),
        shape: RoundedSuperellipseBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          shape: RoundedSuperellipseBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
        },
      ),
    );
  }
}
