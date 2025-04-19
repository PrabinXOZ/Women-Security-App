import 'package:flutter/material.dart';

Color hexStringToColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor; // Default opacity to fully opaque if not specified
  }
  return Color(int.parse(hexColor, radix: 16));
}
