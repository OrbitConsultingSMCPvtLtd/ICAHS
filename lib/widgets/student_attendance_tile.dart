import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/string_extensions.dart';
import 'package:icahs_hwr/core/Utils/color_utils.dart';
import 'package:icahs_hwr/core/my_color_palette.dart';
import 'package:icahs_hwr/models/student_model.dart';
import 'package:icahs_hwr/widgets/my_dropdown_menu.dart';
import 'package:icahs_hwr/widgets/my_list_tile.dart';
import 'package:icahs_hwr/widgets/my_text_field.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class StudentAttendanceTile extends StatefulWidget {
  const StudentAttendanceTile({
    super.key,
    required this.student,
    required this.onChanged,
    required this.initialAttendance,
    required this.initialRemarks,
  });

  final String initialAttendance;
  final String initialRemarks;
  final StudentModel student;
  final Function(String status, String? remarks) onChanged;

  @override
  State<StudentAttendanceTile> createState() => _StudentAttendanceTileState();
}

class _StudentAttendanceTileState extends State<StudentAttendanceTile> {
  late String attendance;
  bool showRemarks = false;

  late final TextEditingController remarksController;

  @override
  void initState() {
    super.initState();
    attendance = widget.initialAttendance;
    remarksController = TextEditingController(text: widget.initialRemarks);
  }

  @override
  void dispose() {
    remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MyListTile(
      elevation: 1,
      borderRadius: 6,
      verticalMargin: 2,
      color: MyColorPalette.white,
      horizontalMargin: 8,
      title: "${widget.student.name.toLowerCase().capitalize}",
      sub1: "(STU${widget.student.id})",
      trailingIsChip: false,
      trailing: Row(
        spacing: 10,
        children: [
          IconButton(
            onPressed: () {
              if (remarksController.text != "") {
                return;
              }
              setState(() {
                showRemarks = !showRemarks;
              });
            },
            icon: Icon(
              !showRemarks && remarksController.text == ""
                  ? LucideIcons.squarePen
                  : LucideIcons.circleChevronUp,
              color: MyColorPalette.purple,
            ),
          ),

          MyDropdownMenu(
            initial: attendance,
            width: 70,
            showBorder: false,
            showTrailingIcon: false,
            labelStyle: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: getColorFromStatus(attendance, isBackground: false),
            ),
            menuColor: const Color.fromARGB(255, 234, 238, 255),
            color: getColorFromStatus(attendance, isBackground: true),
            textAlign: TextAlign.center,
            entries: [
              {"value": "P", "label": "P"},
              {"value": "A", "label": "A"},
              {"value": "OFF", "label": "OFF"},
            ],
            onSelected: (val) {
              setState(() {
                attendance = val!;
              });
              widget.onChanged(
                attendance,
                remarksController.text.isEmpty ? null : remarksController.text,
              );
            },
          ),
        ],
      ),

      bottom: showRemarks || remarksController.text != ""
          ? Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Column(
                mainAxisSize: .min,
                crossAxisAlignment: .start,
                spacing: 8,
                children: [
                  RichText(
                    text: TextSpan(
                      text: 'Remarks ',
                      style: TextStyle(
                        color: MyColorPalette.darkPurple,
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                        height: 2.15,
                      ),
                      children: [
                        TextSpan(
                          text: "[Optional]",
                          style: TextStyle(
                            color: MyColorPalette.textGrey.withAlpha(165),
                            fontSize: 16,
                            height: 2.15,
                          ),
                        ),
                      ],
                    ),
                  ),
                  MyTextField(
                    controller: remarksController,
                    hint: "Enter remarks",
                    borderRadius: BorderRadius.circular(6),
                    onChanged: (value) {
                      widget.onChanged(
                        attendance,
                        value.isEmpty ? null : value,
                      );
                    },
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
