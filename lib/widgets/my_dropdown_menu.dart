import 'package:flutter/material.dart';
import 'package:icahs_hwr/core/my_color_palette.dart';

class MyDropdownMenu extends StatelessWidget {
  const MyDropdownMenu({
    super.key,
    this.hintText,
    required this.entries,
    this.onSelected,
    this.width,
    this.initial,
    this.labelStyle,
    this.color,
    this.menuColor,
    this.borderColor,
    this.textAlign,
    this.showTrailingIcon = true,
    this.showBorder = true,
    this.borderRadius = 10,
    this.elevation = 0,
    this.maxMenuWidth,
    this.labelText,
  });

  final String? hintText;
  final String? labelText;
  final String? initial;
  final double? width;
  final double? maxMenuWidth;
  final bool showTrailingIcon;
  final bool showBorder;
  final TextStyle? labelStyle;
  final TextAlign? textAlign;
  final Color? color;
  final Color? menuColor;
  final Color? borderColor;
  final double borderRadius;
  final double elevation;

  final List<Map<String, dynamic>> entries;
  final void Function(String?)? onSelected;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu(
      showTrailingIcon: showTrailingIcon,
      width: width,
      textAlign: textAlign ?? TextAlign.start,
      initialSelection: initial,
      hintText: hintText,
      label: labelText == null ? null : Text(labelText!),
      menuStyle: MenuStyle(
        backgroundColor: WidgetStatePropertyAll(menuColor),
        elevation: WidgetStatePropertyAll(elevation),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadiusGeometry.circular(borderRadius),
          ),
        ),
        maximumSize: WidgetStatePropertyAll(
          Size.fromWidth(maxMenuWidth ?? double.infinity),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: EdgeInsets.symmetric(horizontal: 5),
        filled: true,
        fillColor: color,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: showBorder
              ? BorderSide(color: borderColor ?? MyColorPalette.black)
              : BorderSide.none,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: showBorder
              ? BorderSide(color: borderColor ?? MyColorPalette.black)
              : BorderSide.none,
        ),
      ),
      textStyle: labelStyle,
      onSelected: onSelected,
      dropdownMenuEntries: entries
          .map(
            (item) => DropdownMenuEntry<String>(
              value: item['value'],
              label: item['label'],
            ),
          )
          .toList(),
    );
  }
}
