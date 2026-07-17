import 'package:flutter/material.dart';
import 'package:icahs_hwr/core/my_color_palette.dart';

class MyTextField extends StatelessWidget {
  const MyTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.label,
    this.icon,
    this.trailing,
    this.obscureText = false,
    this.validator,
    this.borderRadius,
    this.readOnly = false,
    this.onTap,
    this.fillColor,
    this.onChanged,
    this.showBorder = true,
    this.isEnable = true,
    this.maxLines,
    this.minLines,
  });

  final TextEditingController controller;
  final String hint;
  final String? label;
  final Icon? icon;
  final Widget? trailing;
  final Color? fillColor;
  final bool obscureText;
  final int? maxLines;
  final int? minLines;
  final String? Function(String?)? validator;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final BorderRadius? borderRadius;
  final bool readOnly;
  final bool showBorder;
  final bool isEnable;

  

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = borderRadius ?? BorderRadius.circular(10);

final normalBorder = OutlineInputBorder(
  borderRadius: radius,
  borderSide: showBorder
      ? BorderSide(
          width: 1,
          color: MyColorPalette.textGrey,
        )
      : BorderSide.none,
);

final focusedBorder = OutlineInputBorder(
  borderRadius: radius,
  borderSide: showBorder
      ? BorderSide(
          width: 1,
          color: MyColorPalette.black,
        )
      : BorderSide.none,
);
    debugPrint("MyTextField rebuild");
    return TextFormField(
      controller: controller,
      validator: validator,
      obscureText: obscureText,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      enabled: isEnable,
      minLines: minLines,
      maxLines: maxLines,
      decoration: InputDecoration(
        prefixIcon: icon,
        hintText: hint,
        labelText: label,
        suffixIcon: trailing,
        filled: true,
        fillColor: fillColor ?? MyColorPalette.white,
        border: normalBorder,
        enabledBorder: normalBorder,
        focusedBorder: focusedBorder,
        errorBorder: normalBorder,
        focusedErrorBorder: focusedBorder,
      ),
    );
  }
}
