import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icahs_hwr/controllers/auth_controller.dart';
import 'package:icahs_hwr/controllers/batch_controller.dart';
import 'package:icahs_hwr/core/my_color_palette.dart';

bool canCreateOrEdit() {
  if (Get.find<AuthController>().user?.userType == 1 &&
      Get.find<BatchController>().batchDetail.value!.isActive()) {
    return true;
  } else {
    return false;
  }
}

bool isAndroid() {
  return Platform.isAndroid;
}

Future<bool?> deleteDialog(
  BuildContext context, {
  required String title,
  required String content,
  required void Function() onTap,
}) async {
  return await showAdaptiveDialog<bool>(
    context: context,
    builder: (context) => AlertDialog.adaptive(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      title: Text(
        title,
        style: TextStyle(
          color: MyColorPalette.red,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: Text(content),
      actionsAlignment: MainAxisAlignment.end,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: Text("Go back", style: TextStyle(color: MyColorPalette.black)),
        ),

        TextButton(
          onPressed: onTap,
          style: isAndroid()
              ? ElevatedButton.styleFrom(backgroundColor: MyColorPalette.red)
              : null,
          child: Text(
            "Yes",
            style: TextStyle(
              color: isAndroid() ? MyColorPalette.white : MyColorPalette.red,
            ),
          ),
        ),
      ],
    ),
  );
}
