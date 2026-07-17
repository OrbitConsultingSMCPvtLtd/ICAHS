import 'package:flutter/material.dart';
import 'package:icahs_hwr/core/my_color_palette.dart';
import 'package:icahs_hwr/widgets/my_chip.dart';

class MyListTile extends StatelessWidget {
  const MyListTile({
    super.key,
    required this.title,
    this.trailing,
    this.alignment = CrossAxisAlignment.start,
    this.leading,
    this.sub1,
    this.sub2,
    this.sub3,
    this.chipColor,
    this.onTap,
    this.trailingIsChip = true,
    this.titleTextStyle,
    this.elevation = 2,
    this.horizontalMargin = 16,
    this.verticalMargin = 3,
    this.borderRadius = 12,
    this.color,
    this.bottom,
  });

  final CrossAxisAlignment alignment;
  final Widget? leading;
  final String title;
  final String? sub1;
  final String? sub2;
  final String? sub3;
  final Widget? trailing;
  final Widget? bottom;
  final Color? chipColor;
  final Color? color;
  final TextStyle? titleTextStyle;
  final void Function()? onTap;
  final bool trailingIsChip;
  final double? elevation;
  final double horizontalMargin;
  final double verticalMargin;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      color: color ?? MyColorPalette.white,
      margin: EdgeInsets.symmetric(
        vertical: verticalMargin,
        horizontal: horizontalMargin,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(borderRadius),
      ),
      child: InkWell(
        onTap: onTap,
        radius: 35,
        splashColor: MyColorPalette.lowOpacityPurple,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: .min,
            children: [
              Row(
                spacing: 15,
                mainAxisAlignment: .start,
                crossAxisAlignment: alignment,
                children: [
                  ?leading,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: .start,
                      mainAxisSize: .min,
                      spacing: 8,
                      children: [
                        Text(
                          title,
                          style:
                              titleTextStyle ??
                              TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        if (sub1 != null)
                          Text(
                            sub1 ?? "",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                        if (sub2 != null)
                          Text(
                            sub2 ?? "",
                            style: TextStyle(color: MyColorPalette.textGrey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (sub3 != null)
                          Text(
                            sub3 ?? "",
                            style: TextStyle(color: MyColorPalette.textGrey),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),
                  trailing == null
                      ? const SizedBox.shrink()
                      : trailingIsChip
                      ? MyChip(label: trailing!, color: chipColor)
                      : trailing!,
                ],
              ),
              AnimatedContainer(duration: Duration(seconds: 1), child: bottom),
            ],
          ),
        ),
      ),
    );
  }
}
