import 'package:flutter/material.dart';
import 'package:icahs_hwr/core/my_color_palette.dart';

class MyStatCard extends StatelessWidget {
  const MyStatCard({
    super.key,
    this.icon,
    required this.title,
    required this.count,
    this.alignment = CrossAxisAlignment.start,
    this.onTap,
    this.countColor,
    this.spacing = 6,
    this.countFontSize = 22,
    this.titleColor,
    this.color,
    this.elevation = 2,
    this.leading,
    this.countPadding,
  });

  final IconData? icon;
  final Widget? leading;
  final String title;
  final String count;
  final double countFontSize;
  final double spacing;
  final double elevation;
  final EdgeInsetsGeometry? countPadding;

  final Color? color;
  final Color? countColor;
  final Color? titleColor;
  final CrossAxisAlignment alignment;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      color: color ?? MyColorPalette.white,
      child: InkWell(
        onTap: onTap,
        radius: 35,
        splashColor: MyColorPalette.lowOpacityPurple,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: alignment,
            spacing: spacing,
            children: [
              Row(
                spacing: 10,
                mainAxisAlignment: alignment == CrossAxisAlignment.center
                    ? .center
                    : .start,
                children: [
                  if (icon != null)
                    Icon(icon, color: MyColorPalette.darkPurple, size: 26),

                  ?leading,

                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: titleColor,
                    ),
                  ),
                ],
              ),
              Padding(
                padding: countPadding ?? EdgeInsets.all(0.0),
                child: Text(
                  count,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: countFontSize,
                    color: countColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
