import 'package:flutter/material.dart';
import 'package:icahs_hwr/core/custom_app_bar_method.dart';
import 'package:icahs_hwr/core/my_color_palette.dart';
import 'package:icahs_hwr/widgets/my_button.dart';
import 'package:icahs_hwr/widgets/my_dropdown_menu.dart';
import 'package:icahs_hwr/widgets/my_input_label.dart';
import 'package:icahs_hwr/widgets/my_text_field.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CreateBatchPage extends StatefulWidget {
  const CreateBatchPage({super.key});

  @override
  State<CreateBatchPage> createState() => _CreateBatchPageState();
}

class _CreateBatchPageState extends State<CreateBatchPage> {
  String hospital = "";
  final TextEditingController _batchNameController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _remarksController = TextEditingController();

  void _handleDatePicker(TextEditingController controller) async {
    showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      initialDate: DateTime.now(),
    ).then((date) {
      if (date != null) {
        controller.text = date.toIso8601String().split("T")[0];
      }
    });
  }

  @override
  void dispose() {
    _batchNameController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: MyColorPalette.white,
        appBar: _buildAppBar(context),

        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: .start,
              crossAxisAlignment: .start,
              children: [
                _buildDropdownMenuInputField(
                  label: "Hospital",
                  hintText: "Select a hospital",
                  entries: [
                    {"value": "hospital1", "entry": "Hospital 1"},
                    {"value": "hospital2", "entry": "Hospital 2"},
                    {"value": "hospital3", "entry": "Hospital 3"},
                    {"value": "hospital4", "entry": "Hospital 4"},
                    {"value": "hospital5", "entry": "Hospital 5"},
                  ],
                ),
                _buildDropdownMenuInputField(
                  label: "Program",
                  hintText: "Select a program",
                  entries: [
                    {"value": "program1", "entry": "Program 1"},
                    {"value": "program2", "entry": "Program 2"},
                    {"value": "program3", "entry": "Program 3"},
                    {"value": "program4", "entry": "Program 4"},
                    {"value": "program5", "entry": "Program 5"},
                  ],
                ),
                _buildDropdownMenuInputField(
                  label: "Supervisor",
                  hintText: "Select a supervisor",
                  entries: [
                    {"value": "supervisor1", "entry": "Supervisor 1"},
                    {"value": "supervisor2", "entry": "Supervisor 2"},
                    {"value": "supervisor3", "entry": "Supervisor 3"},
                    {"value": "supervisor4", "entry": "Supervisor 4"},
                    {"value": "supervisor5", "entry": "Supervisor 5"},
                  ],
                ),
                _buildInputTextField(
                  controller: _batchNameController,
                  label: "Batch Name",
                  hint: "Enter batch name",
                ),
                _buildInputTextField(
                  controller: _startDateController,
                  label: "Start Date",
                  hint: "YYYY-MM-DD",
                  onTap: () {
                    _handleDatePicker(_startDateController);
                  },
                  trailing: IconButton(
                    onPressed: () {
                      _handleDatePicker(_startDateController);
                    },
                    icon: Icon(LucideIcons.calendarDays),
                  ),
                  readOnly: true,
                ),
                _buildInputTextField(
                  controller: _endDateController,
                  label: "End Date",
                  hint: "YYYY-MM-DD",
                  onTap: () {
                    _handleDatePicker(_startDateController);
                  },
                  trailing: IconButton(
                    onPressed: () {
                      _handleDatePicker(_endDateController);
                    },
                    icon: Icon(LucideIcons.calendarDays),
                  ),
                  readOnly: true,
                ),
                _buildInputTextField(
                  controller: _remarksController,
                  label: "Remarks",
                  hint: "Enter remarks",
                  isRequired: false,
                ),
                _buildDropdownMenuInputField(
                  label: "Status",
                  hintText: "Select status",
                  entries: [
                    {"value": "Y", "entry": "Active"},
                    {"value": "N", "entry": "Complete"},
                  ],
                ),
                _buildButtons(),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }

   PreferredSizeWidget _buildAppBar(BuildContext context) {
    return getCustomAppBar(
      context,
      title: "Create Batch",
      backgroundColor: MyColorPalette.white,
      foregroundColor: MyColorPalette.purple,
      hasDivider: true,
    );
  }

  Widget _buildDropdownMenuInputField({
    required String label,
    required String hintText,
    required List<Map<String, dynamic>> entries,
    bool isRequired = true,
  }) {
    return SizedBox(
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          MyInputLabel(label: label, isRequired: isRequired),
          MyDropdownMenu(hintText: hintText, entries: entries),
        ],
      ),
    );
  }

  Widget _buildInputTextField({
    required String label,
    required String hint,
    required TextEditingController controller,
    bool isRequired = true,
    bool readOnly = false,
    Widget? trailing,
    void Function()? onTap,
  }) {
    return SizedBox(
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          MyInputLabel(label: label, isRequired: isRequired),
          MyTextField(
            controller: controller,
            borderRadius: BorderRadius.circular(4),
            hint: hint,
            trailing: trailing,
            readOnly: readOnly,
            onTap: onTap,
          ),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Row(
        mainAxisSize: .max,
        children: [
          Expanded(
            child: MyButton(
              onTap: () => Navigator.pop(context),
              color: Colors.white,
              child: Text(
                "cancel",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
          Expanded(
            child: MyButton(
              onTap: () {},
              child: Text(
                "Save",
                style: TextStyle(color: MyColorPalette.white, fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
