import 'package:flutter/material.dart';

class ColorUtil {



  late final Color color;

  ColorUtil([int? colorValue]) {
    if (colorValue is int) {
      color = Color(colorValue);
    }
  }

  MaterialColor toMaterial() {
    List strengths = <double>[.05];
    final swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (double strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  factory ColorUtil.fromColor(Color color) {
    return ColorUtil()..color = color;
  }
}

class ColorUtils {
  static const Color textColor = Color(0xff717070);
  static MaterialColor black = ColorUtil(0xff181818).toMaterial();
  static MaterialColor blue = ColorUtil(Colors.blue.value).toMaterial();
  static MaterialColor yellow = ColorUtil(0xffFFCB4A).toMaterial();
  static MaterialColor orange = ColorUtil(0xffFF5F00).toMaterial();
  static MaterialColor green = ColorUtil(0xff00C897).toMaterial();
  static MaterialColor red = ColorUtil(0xffFF3C3C).toMaterial();
  static MaterialColor gray = ColorUtil(0xff181818).toMaterial();
  static MaterialColor purple = ColorUtil(0xff8c32df).toMaterial();

}
