import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:icahs_hwr/controllers/attendance_controller.dart';
import 'package:icahs_hwr/controllers/student_controller.dart';
import 'package:icahs_hwr/core/custom_app_bar_method.dart';
import 'package:icahs_hwr/core/helper.dart';
import 'package:icahs_hwr/core/my_color_palette.dart';
import 'package:icahs_hwr/models/attendance_model.dart';
import 'package:icahs_hwr/models/batch_model.dart';
import 'package:icahs_hwr/models/student_attendance_model.dart';
import 'package:icahs_hwr/widgets/my_button.dart';
import 'package:icahs_hwr/widgets/my_input_label.dart';
import 'package:icahs_hwr/widgets/my_list_tile.dart';
import 'package:icahs_hwr/widgets/my_text_field.dart';
import 'package:icahs_hwr/widgets/student_attendance_tile.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

class MarkAttendancePage extends StatefulWidget {
  const MarkAttendancePage({
    super.key,
    required this.batch,
    this.pageTitle,
    this.attendanceDetails,
    this.attendance,
  });

  final String? pageTitle;
  final BatchModel batch;
  final AttendanceModel? attendance;
  final List<StudentAttendanceModel>? attendanceDetails;

  bool get isUpdate => attendanceDetails != null;

  @override
  State<MarkAttendancePage> createState() => _MarkAttendancePageState();
}

class _MarkAttendancePageState extends State<MarkAttendancePage> {
  final StudentController _studentController = Get.find<StudentController>();
  final AttendanceController _attendanceController =
      Get.find<AttendanceController>();
  final Map<String, StudentAttendanceModel> attendanceData = {};

  late final TextEditingController _dateController;

  @override
  void initState() {
    super.initState();
    _dateController = TextEditingController(
      text:
          widget.attendance?.dated.split("T")[0] ??
          DateTime.now().toIso8601String().split("T")[0],
    );
    checkAndLoadStudents();
  }

  void initializeAttendanceData() {
    if (widget.attendanceDetails != null) {
      for (var student in widget.attendanceDetails!) {
        attendanceData[student.studentId.toString()] = student;
      }
      return;
    }
    for (var student in _studentController.students) {
      attendanceData[student.id.toString()] = StudentAttendanceModel(
        studentId: student.id.toString(),
        studentName: student.name,
        studentStatus: 'P',
      );
    }
  }

  void checkAndLoadStudents() async {
    if (_studentController.students.firstOrNull?.hwrbatchId ==
        widget.batch.hwrBatchId) {
      initializeAttendanceData();
      return;
    }

    await _studentController.loadInitialStudents(widget.batch.hwrBatchId).then((
      _,
    ) {
      initializeAttendanceData();
    });
  }

  void _handleSaveNewAttendance() async {
    final attendanceRecords = attendanceData.values
        .map(
          (e) => {
            ...e.toNewAttendanceJson(),
            "hwr_batch_id": widget.batch.hwrBatchId,
          },
        )
        .toList();

    Map<String, dynamic> result;

    if (widget.isUpdate && widget.attendance != null) {
      result = await _attendanceController.updateAttendance(
        attendanceRecords,
        widget.batch.hospitalId,
        widget.attendance!,
      );
    } else {
      result = await _attendanceController.createNewAttendance(
        attendanceRecords,
        widget.batch.hospitalId,
        widget.batch.hwrBatchId,
        _dateController.text,
      );
    }

    showSnackBar(
      result['status'].toString().toLowerCase().capitalize!,
      result['message'],
      color: result['status'] == "SUCCESS"
          ? MyColorPalette.success
          : MyColorPalette.error,
    );

    if (result['status'] != "SUCCESS") {
      return;
    }

    if (!mounted) return;

    Navigator.pop(context, true);
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
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: _buildAppBar(context),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              _buildAttedanceInfoCard(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: const MyInputLabel(
                  label: "Attendance Date",
                  isRequired: false,
                  textColor: MyColorPalette.darkPurple,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: MyTextField(
                  controller: _dateController,
                  borderRadius: BorderRadius.circular(10),
                  hint: "YYYY-MM-DD",
                  fillColor: MyColorPalette.white,
                  showBorder: false,
                  isEnable: !widget.isUpdate,
                  trailing: IconButton(
                    onPressed: () async {
                      var date = await _handleDatePicker();
                      _dateController.text = date ?? "";
                    },
                    icon: Icon(LucideIcons.calendarDays),
                  ),
                  readOnly: true,
                  onTap: () async {
                    var date = await _handleDatePicker();
                    _dateController.text = date ?? "";
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 4,
                ),
                child: const MyInputLabel(
                  label: "Students",
                  isRequired: false,
                  textColor: MyColorPalette.darkPurple,
                ),
              ),
              _buildStudentList(),
              MyButton(
                onTap: _handleSaveNewAttendance,

                child: Text(
                  "Save Attendance",
                  style: TextStyle(
                    color: MyColorPalette.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 4),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return getCustomAppBar(
      context,
      title: widget.isUpdate ? "Update Attendance" : "Mark Attendance",
    );
  }

  Widget _buildAttedanceInfoCard() {
    return MyListTile(
      leading: Icon(
        CupertinoIcons.calendar_today,
        color: MyColorPalette.purple,
        size: 28,
      ),
      color: MyColorPalette.white,
      title: widget.batch.batchName,
      sub1: widget.batch.hospitalName,

      elevation: 1,
    );
  }

  Widget _buildStudentList() {
    return Expanded(
      child: GetX<StudentController>(
        builder: (controller) {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (controller.students.isEmpty) {
            return const Center(child: Text("No Records Found!"));
          }

          return ListView.builder(
            itemCount: controller.students.length,
            itemBuilder: (context, index) {
              var student = _studentController.students[index];

              return StudentAttendanceTile(
                initialAttendance:
                    attendanceData[student.id.toString()]?.studentStatus ?? "P",
                initialRemarks:
                    attendanceData[student.id.toString()]?.remarks ?? "",
                student: student,
                onChanged: (status, remarks) {
                  attendanceData[student.id
                      .toString()] = StudentAttendanceModel(
                    studentId: widget.isUpdate
                        ? widget.attendanceDetails![index].studentId.toString()
                        : student.id.toString(),
                    studentName: student.name,
                    studentStatus: status,
                    remarks: remarks,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
