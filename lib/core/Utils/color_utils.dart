import 'dart:ui';

import 'package:icahs_hwr/core/my_color_palette.dart';

Color getColorFromStatus(String status, {required bool isBackground}) {
  Color color;
  switch (status.toLowerCase()) {
    case "completed":
      color = isBackground
          ? MyColorPalette.lowOpacityGreen
          : MyColorPalette.darkGreen;
      break;
    case "pending":
      color = isBackground
          ? MyColorPalette.lowOpacityOrange
          : MyColorPalette.darkOrange;
      break;
    case "y":
      color = isBackground
          ? MyColorPalette.lowOpacityGreen
          : MyColorPalette.darkGreen;
      break;
    case "n":
      color = isBackground
          ? MyColorPalette.lowOpacityRed
          : MyColorPalette.darkRed;
      break;
    case "p":
      color = isBackground
          ? MyColorPalette.lowOpacityGreen
          : MyColorPalette.darkGreen;
      break;
    case "a":
      color = isBackground
          ? MyColorPalette.lowOpacityRed
          : MyColorPalette.darkRed;
      break;
    case "off":
      color = isBackground
          ? MyColorPalette.lowOpacityOrange
          : MyColorPalette.darkOrange;
      break;
    case "low":
      color = isBackground
          ? MyColorPalette.lowOpacityGreen
          : MyColorPalette.darkGreen;
      break;
    case "moderate":
      color = isBackground
          ? MyColorPalette.lowOpacityOrange
          : MyColorPalette.darkOrange;
      break;
    case "high":
      color = isBackground
          ? MyColorPalette.lowOpacityRed
          : MyColorPalette.darkRed;
      break;
    case "critical":
      color = isBackground
          ? MyColorPalette.lowOpacityPurple
          : MyColorPalette.darkPurple;
      break;
    default:
      color = isBackground
          ? MyColorPalette.lowOpacityOrange
          : MyColorPalette.darkOrange;
  }

  return color;
}
