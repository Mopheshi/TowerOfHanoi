import 'package:flutter/material.dart';

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
  fontFamily: 'Montserrat',
);
