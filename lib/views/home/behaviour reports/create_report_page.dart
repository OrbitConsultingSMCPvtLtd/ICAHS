import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icahs_hwr/controllers/report_controller.dart';
import 'package:icahs_hwr/controllers/student_controller.dart';
import 'package:icahs_hwr/core/custom_app_bar_method.dart';
import 'package:icahs_hwr/core/helper.dart';
import 'package:icahs_hwr/core/my_color_palette.dart';
import 'package:icahs_hwr/models/report_model.dart';
import 'package:icahs_hwr/widgets/my_button.dart';
import 'package:icahs_hwr/widgets/my_dropdown_menu.dart';
import 'package:icahs_hwr/widgets/my_input_label.dart';
import 'package:icahs_hwr/widgets/my_text_field.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class CreateReportPage extends StatefulWidget {
  const CreateReportPage({
    super.key,
    required this.batchId,
    required this.hospitalId,
    this.report,
  });

  final String batchId;
  final String hospitalId;
  final ReportModel? report;

  bool get isUpdate => report != null;

  @override
  State<CreateReportPage> createState() => _CreateReportPageState();
}

class _CreateReportPageState extends State<CreateReportPage> {
  final ReportController _reportController = Get.find<ReportController>();
  final StudentController _studentController = Get.find<StudentController>();

  late final TextEditingController detailController;
  late final TextEditingController actionrecommendedController;
  late final TextEditingController dateController;
  String? studentId;
  String? issueType;
  String? severity;
  String? actions;

  void _handleButtontap() async {
    if (!_validate()) {
      showSnackBar(
        "Missing Fields",
        "Please fill all the required fields",
        color: MyColorPalette.lowOpacityOrange,
      );
      return;
    }

    var data = {
      "hospital_id": widget.hospitalId,
      "hwr_batch_id": widget.batchId,
      "student_id": studentId,
      "report_date": dateController.text,
      "issue_type_id": issueType,
      "severity_id": severity,
      "action_required_id": actions,
      "issue_details": detailController.text == ""
          ? null
          : detailController.text.trim(),
      "recommended_action": actionrecommendedController.text == ""
          ? null
          : actionrecommendedController.text.trim(),
      "entered_by": "APP",
    };

    Map<String, dynamic> result;

    if (!widget.isUpdate) {
      result = await _reportController.createBehaivourReport(data);
    } else {
      result = await _reportController.updateBehaivourReport({
        "report_id": widget.report?.reportId ?? "",
        ...data,
      });
    }
    Color color;
    if (result['status'] != 'SUCCESS') {
      color = MyColorPalette.error;
    } else if (widget.isUpdate) {
      color = MyColorPalette.success;
      if (!mounted) return;
      Navigator.pop(context);
    } else {
      color = MyColorPalette.success;
      _clearForm();
    }

    showSnackBar(
      result['status'].toString().toLowerCase().capitalize!,
      result['message'],
      color: color,
    );
  }

  Future<String?> _handleDatePicker() async {
    DateTime? date = await showDatePicker(
      context: context,

      firstDate: DateTime(2000),
      lastDate: DateTime(2500),
      initialDate: DateTime.now(),
    );

    if (date == null) return null;

    return date.toIso8601String().split("T")[0];
  }

  @override
  void initState() {
    super.initState();
    detailController = TextEditingController(
      text: widget.report?.issueDetails ?? "",
    );
    dateController = TextEditingController(
      text: widget.report?.reportDate.split("T")[0] ?? "",
    );
    actionrecommendedController = TextEditingController(
      text: widget.report?.recommendedAction ?? "",
    );
    studentId = widget.report?.studentId;
    issueType = widget.report?.issueTypeId;
    severity = widget.report?.severityId;
    actions = widget.report?.actionRequiredId;
  }

  @override
  void dispose() {
    detailController.dispose();
    dateController.dispose();
    actionrecommendedController.dispose();
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
          margin: EdgeInsets.symmetric(horizontal: 12),
          child: ListView(
            children: [
              _buildDropdownMenuInputField(
                label: "Student",
                initialSelection: studentId,
                hintText: "Select student",
                entries: _studentController.studentForLov,
                onSelected: (val) {
                  if (val == null) return;

                  studentId = val;
                },
              ),
              _buildInputTextField(
                controller: dateController,
                label: "Report date",
                hint: "YYYY-MM-DD",
                isEndabled: !widget.isUpdate,
                onTap: () async {
                  var date = await _handleDatePicker();
                  dateController.text = date ?? "";
                },
                trailing: IconButton(
                  onPressed: () async {
                    var date = await _handleDatePicker();
                    dateController.text = date ?? "";
                  },
                  icon: Icon(LucideIcons.calendarDays),
                ),
                readOnly: true,
              ),
              _buildDropdownMenuInputField(
                label: "Issue Type",
                initialSelection: issueType,
                hintText: "Select type of Issue",
                entries: _reportController.issurLov,
                onSelected: (val) {
                  if (val == null) return;

                  issueType = val;
                },
              ),
              _buildDropdownMenuInputField(
                label: "Severity",
                initialSelection: severity,
                hintText: "Select Severity of issue",
                entries: _reportController.severityLov,
                onSelected: (val) {
                  if (val == null) return;

                  severity = val;
                },
              ),
              _buildDropdownMenuInputField(
                label: "Action Required",
                initialSelection: actions,
                hintText: "Select the Required Action",
                entries: _reportController.actionLov,
                onSelected: (val) {
                  if (val == null) return;

                  actions = val;
                },
              ),
              _buildInputTextField(
                controller: detailController,
                label: "Issue Details",
                hint: "Enter issue details",
                isRequired: false,
                minLines: 3,
              ),
              _buildInputTextField(
                isRequired: false,
                controller: actionrecommendedController,
                label: "Recommended Actions",
                hint: "Enter the recommended actions",
                minLines: 3,
              ),
              const SizedBox(height: 20),
              MyButton(
                onTap: _handleButtontap,
                child: Text(
                  widget.isUpdate ? "Update Report" : "Submit Report",
                  style: TextStyle(
                    color: MyColorPalette.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return getCustomAppBar(
      context,
      title: widget.isUpdate ? "Update Report" : "Create Report",
      backgroundColor: MyColorPalette.white,
    );
  }

  Widget _buildDropdownMenuInputField({
    required String label,
    required String hintText,
    required String? initialSelection,
    required List<Map<String, dynamic>> entries,
    required void Function(String?)? onSelected,
    bool isRequired = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3.0),
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          MyInputLabel(
            label: label,
            isRequired: isRequired,
            textColor: MyColorPalette.darkPurple,
          ),
          MyDropdownMenu(
            hintText: hintText,
            entries: entries,
            initial: initialSelection,
            borderColor: MyColorPalette.textGrey,
            color: MyColorPalette.white,
            borderRadius: 8,
            menuColor: const Color.fromARGB(255, 244, 245, 252),
            onSelected: onSelected,
            elevation: 2,
            maxMenuWidth: MediaQuery.widthOf(context) - 24,
            width: double.infinity,
          ),
        ],
      ),
    );
  }

  Widget _buildInputTextField({
    required String label,
    required String hint,
    required TextEditingController controller,

    Widget? trailing,
    int minLines = 1,
    bool isRequired = true,
    bool readOnly = false,
    bool isEndabled = true,
    void Function()? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3.0),
      child: Column(
        mainAxisSize: .min,
        crossAxisAlignment: .start,
        children: [
          MyInputLabel(
            label: label,
            isRequired: isRequired,
            textColor: MyColorPalette.darkPurple,
          ),
          MyTextField(
            controller: controller,
            borderRadius: BorderRadius.circular(8),
            hint: hint,
            maxLines: null,
            minLines: minLines,
            isEnable: isEndabled,
            onTap: onTap,
            readOnly: readOnly,
            trailing: trailing,
          ),
        ],
      ),
    );
  }

  bool _validate() {
    if (studentId == null ||
        dateController.text == "" ||
        issueType == null ||
        severity == null ||
        actions == null) {
      return false;
    } else {
      return true;
    }
  }

  void _clearForm() {
    studentId = null;
    dateController.clear();
    issueType = null;
    severity = null;
    actions = null;
    detailController.clear();
    actionrecommendedController.clear();

    setState(() {});
  }
}
