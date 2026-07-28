import 'package:flutter/material.dart';
import 'package:icahs_hwr/core/my_color_palette.dart';
import 'package:icahs_hwr/widgets/my_dropdown_menu.dart';
import 'package:icahs_hwr/widgets/my_text_field.dart';

const scoreOptions = <Map<String, String>>[
  {'value': '1', 'label': "1"},
  {'value': '2', 'label': "2"},
  {'value': '3', 'label': "3"},
  {'value': '4', 'label': "4"},
  {'value': '5', 'label': "5"},
];

class EvaluationScoreRow extends StatelessWidget {
  const EvaluationScoreRow({
    super.key,
    required this.controller,
    required this.label,
  });

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    debugPrint("EvaluationScoreRow $label rebuild");
    return Row(
      spacing: 8,
      crossAxisAlignment: .center,
      children: [
        Expanded(
          flex: 2,
          child: SizedBox(
            child: MyDropdownMenu(
              labelText: label,
              entries: scoreOptions,
              hintText: "Select score",
              borderColor: MyColorPalette.textGrey,
              color: MyColorPalette.white,
              borderRadius: 8,
              menuColor: const Color.fromARGB(255, 244, 245, 252),
              textAlign: TextAlign.center,
              labelStyle: TextStyle(fontSize: 16),
              elevation: 2,
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: MyTextField(
            controller: controller,
            label: "Remarks",
            hint: "Enter Remarks",
            borderRadius: BorderRadius.circular(8),
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
