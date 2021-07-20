import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:recipebook/resources/palette.dart';

ThemeData themeData(BuildContext context) {
  return ThemeData(
    primaryColor: Palette.orange,
    accentColor: Palette.orange,
    scaffoldBackgroundColor: Colors.white,
    backgroundColor: Colors.white,
    iconTheme: const IconThemeData(color: Palette.orange),
    textTheme: GoogleFonts.montserratTextTheme().copyWith(
      headline1: const TextStyle(
        color: Palette.main,
        fontSize: 72,
        fontWeight: FontWeight.w700,
      ),
      headline2: const TextStyle(
        color: Palette.main,
        fontSize: 42,
        fontWeight: FontWeight.w700,
      ),
      headline3: const TextStyle(
        color: Palette.main,
        fontSize: 24,
        fontWeight: FontWeight.w700,
      ),
      bodyText1: const TextStyle(
        color: Palette.mainLighten1,
        fontSize: 18,
      ),
      bodyText2: const TextStyle(
        color: Palette.mainLighten1,
        fontSize: 16,
      ),
    ),
  );
}
