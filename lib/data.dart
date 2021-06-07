import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Data {
  static const cleo_blue = Color.fromRGBO(52, 28, 255, 1.0);

  // Have to define 10 different swatches
  static const Map<int, Color> cleo_blue_map = {
    50: cleo_blue,
    100: cleo_blue,
    200: cleo_blue,
    300: cleo_blue,
    400: cleo_blue,
    500: cleo_blue,
    600: cleo_blue,
    700: cleo_blue,
    800: cleo_blue,
    900: cleo_blue,
  };
  static const material_cleo_blue = MaterialColor(0xFF341CFF, cleo_blue_map);

  static const cleo_blue_tint_2 = Color.fromRGBO(138, 158, 251, 1.0);

  static const cleo_blue_tint_3 = Color.fromRGBO(194, 210, 253, 1.0);

  // Have to define 10 different swatches
  static const Map<int, Color> cleo_blue_tint_3_map = {
    50: cleo_blue_tint_3,
    100: cleo_blue_tint_3,
    200: cleo_blue_tint_3,
    300: cleo_blue_tint_3,
    400: cleo_blue_tint_3,
    500: cleo_blue_tint_3,
    600: cleo_blue_tint_3,
    700: cleo_blue_tint_3,
    800: cleo_blue_tint_3,
    900: cleo_blue_tint_3,
  };
  static const material_cleo_blue_tint_3 =
      MaterialColor(0xFFC2D2FD, cleo_blue_tint_3_map);
  static const dollar_green = Color.fromRGBO(0, 255, 127, 1.0);
  static const lit_purple = Color.fromRGBO(194, 121, 251, 1.0);
  static const roast_red = Color.fromRGBO(255, 60, 77, 1.0);
  static const boss_black = Color.fromRGBO(0, 0, 0, 1.0);
  static const boss_black_tint_1 = Color.fromRGBO(121, 121, 139, 1.0);
  static const boss_black_tint_2 = Color.fromRGBO(168, 168, 181, 1.0);
  static const boss_black_tint_3 = Color.fromRGBO(218, 218, 222, 1.0);

  static const paper_white = Color.fromRGBO(255, 255, 255, 1.0);
}
