import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icahs_hwr/core/my_color_palette.dart';

void showSnackBar(String title, String message, {Color? color}) {
  Get.snackbar(
    title,
    message,
    backgroundColor: color?.withAlpha(165) ?? MyColorPalette.white.withAlpha(135),
    colorText: color == null ? MyColorPalette.black : MyColorPalette.white,
    snackPosition: SnackPosition.TOP,
    snackStyle: SnackStyle.FLOATING,
    messageText: Text(
      message,
      style: TextStyle(
        color: color == null ? MyColorPalette.black : MyColorPalette.white,
        fontWeight: FontWeight.bold,
      ),
    ),
    margin: const EdgeInsets.symmetric(horizontal: 14),
  );
}