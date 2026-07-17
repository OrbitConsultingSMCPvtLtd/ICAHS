import 'package:flutter/material.dart';
import 'package:icahs_hwr/core/my_color_palette.dart';

class MyInputLabel extends StatelessWidget {
  const MyInputLabel({super.key, required this.label, this.isRequired = true, this.textColor, this.fontSize = 18, this.height});

  final String label;
  final bool isRequired;
  final double? height;
  final Color? textColor;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: '$label ',
        style: TextStyle(
          color: textColor ?? MyColorPalette.black,
          fontWeight: FontWeight.w500,
          fontSize: fontSize,
          height: height ?? 2.15,
        ),
        children: [
          if (isRequired)
            TextSpan(
              text: "*",
              style: TextStyle(
                color: MyColorPalette.red,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                height: 2.15,
              ),
            ),
        ],
      ),
    );
  }
}
