import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'colours.dart';

// Theme configuration
final ThemeData appTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    brightness: Brightness.dark,
    surface: Colours.surfaceColor,
    surfaceDim: Colours.surfaceDimColor,
    surfaceBright: Colours.surfaceBrightColor,
  ),
  useMaterial3: true,
  textTheme: GoogleFonts.bungeeSpiceTextTheme(),
);
