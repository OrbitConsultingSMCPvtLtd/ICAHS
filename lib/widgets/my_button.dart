import 'package:flutter/material.dart';
import 'package:icahs_hwr/core/my_color_palette.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.onTap,
    required this.child,
    this.color,
    this.borderRadius = 10,
    this.hasFixedSize = true
  });

  final void Function()? onTap;
  final Widget child;
  final Color? color;
  final bool hasFixedSize;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(borderRadius),
          ),
          fixedSize: hasFixedSize ? Size(double.infinity, 55) : null,
          padding: EdgeInsets.zero,
        ),

        child: ClipRRect(
          borderRadius: BorderRadiusGeometry.circular(10),
          child: Container(
            decoration: BoxDecoration(
              gradient: color == null
                  ? LinearGradient(
                      begin: AlignmentGeometry.topLeft,
                      end: AlignmentGeometry.bottomRight,
                      colors: [
                        MyColorPalette.purple.withAlpha(155),
                        MyColorPalette.purple,
                      ],
                    )
                  : null,
            ),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
