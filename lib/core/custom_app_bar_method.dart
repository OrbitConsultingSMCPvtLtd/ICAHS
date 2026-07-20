import 'package:flutter/material.dart';
import 'package:icahs_hwr/core/my_color_palette.dart';

PreferredSizeWidget getCustomAppBar(
  BuildContext context, {
  required String title,
  Widget? icon,
  Color? foregroundColor,
  Color? backgroundColor,
  List<Widget>? actions,
  bool hasActionsPadding = true,
  bool hasDivider = true,
  bool showLeading = true,
}) {
  return AppBar(
    scrolledUnderElevation: 0,
    foregroundColor: foregroundColor ?? MyColorPalette.purple,
    backgroundColor: backgroundColor,
    leading: showLeading
        ? IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.arrow_back_ios_new_rounded),
          )
        : null,
    title: Row(
      mainAxisSize: .min,
      spacing: 15,
      crossAxisAlignment: .center,
      children: [
        ?icon,
        Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
    centerTitle: true,

    actionsPadding: hasActionsPadding
        ? const EdgeInsets.symmetric(horizontal: 24)
        : const EdgeInsets.all(0),
    actions: actions,
    elevation: 0,
    bottom: hasDivider
        ? PreferredSize(
            preferredSize: Size(double.infinity, 10),
            child: Divider(color: MyColorPalette.darkPurple.withAlpha(40)),
          )
        : null,
  );
}
