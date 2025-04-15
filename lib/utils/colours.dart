import 'dart:ui';

class Colours {
  static const surfaceColor = Color(0xFF282C34);
  static const surfaceDimColor = Color(0xFF111418);
  static const surfaceBrightColor = Color(0xFF2C3E50);

  static const redColor = Color(0xFFFF5252);
  static const orangeColor = Color(0xFFFF9800);
  static const yellowColor = Color(0xFFFFEB3B);
  static const greenColor = Color(0xFF4CAF50);
  static const blueColor = Color(0xFF2196F3);
  static const indigoColor = Color(0xFF3F51B5);
  static const violetColor = Color(0xFF673AB7);

  static const brownColor = Color(0xFF795548);

  static const diskColors = [
    violetColor,
    indigoColor,
    blueColor,
    greenColor,
    yellowColor,
    orangeColor,
    redColor,
  ];

  static Color getDiskColor(int index) => diskColors[index % diskColors.length];
}
