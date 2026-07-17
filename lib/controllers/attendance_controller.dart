import 'dart:convert';

import 'package:get/get.dart';
import 'package:icahs_hwr/controllers/auth_controller.dart';
import 'package:icahs_hwr/models/attendance_model.dart';
import 'package:icahs_hwr/models/student_attendance_model.dart';
import 'package:icahs_hwr/service/http_service.dart';

class AttendanceController extends GetxController {
  AttendanceController(this._http, this.authController);

  final HttpService _http;
  final AuthController authController;

  final RxList<AttendanceModel> attendanceRecords = <AttendanceModel>[].obs;
  RxBool isLoading = false.obs;
  final RxList<StudentAttendanceModel> stdAttendanceRecords =
      <StudentAttendanceModel>[].obs;
  RxBool isStdLoading = false.obs;

  RxBool isNewAttendanceLoading = false.obs;

  bool hasMore = false;
  int offset = 0;

  Future<void> loadInitialAttendanceRecords(String batchId) async {
    isLoading.value = true;
    try {
      var user = authController.user!;
      offset = 0;

      var res = await _http.getRequest(
        '/show_attendance/${user.instituteId}/$batchId/${user.userType}/${user.id}',
        null,
      );

      var body = jsonDecode(res.body);
      hasMore = body['hasMore'];
      attendanceRecords.assignAll(
        List<AttendanceModel>.from(
          (body['items'] as List).map((jsonData) {
            return AttendanceModel.fromJson(jsonData);
          }),
        ),
      );

    } catch (e) {
      printError(info: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadStudentAttendanceRecords(
    String batchId,
    String attenId,
  ) async {
    isStdLoading.value = true;
    try {
      var user = authController.user!;
      offset = 0;

      var res = await _http.getRequest(
        '/attendance_details/${user.instituteId}/$batchId/${user.userType}/${user.id}/$attenId',
        null,
      );

      var body = jsonDecode(res.body);
      hasMore = body['hasMore'];
      stdAttendanceRecords.assignAll(
        List<StudentAttendanceModel>.from(
          (body['items'] as List).map((jsonData) {
            return StudentAttendanceModel.fromJson(jsonData);
          }),
        ),
      );
    } catch (e) {
      printError(info: e.toString());
    } finally {
      isStdLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> createNewAttendance(
    List<Map<String, dynamic>> attendanceRecords,
    String hospitalId,
    String batchId,
    String date,
  ) async {
    isStdLoading.value = true;
    try {
      var user = authController.user!;
      var res = await _http.postRequestEncoded('/create_attendance', null, {
        "p_co": user.instituteId,
        "user_id": user.id,
        "user_type": user.userType.toString(),
        "hospital_id": hospitalId,
        "attendance_date": date,
        "students": attendanceRecords,
      });

      var body = jsonDecode(res.body);
      await loadInitialAttendanceRecords(batchId);

      isStdLoading.value = false;
      return body as Map<String, dynamic>;
    } catch (e) {
      printError(info: e.toString());
      isStdLoading.value = false;
      return {"status": "ERROR", "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateAttendance(
    List<Map<String, dynamic>> attendanceRecords,
    String hospitalId,
    AttendanceModel attendance,
  ) async {
    isStdLoading.value = true;
    try {
      var user = authController.user!;
      var res = await _http.postRequestEncoded('/update_attendance', null, {
        "attendance_id": attendance.hwrAttendanceId,
        "hwr_batch_id": attendance.hwrBatchId,
        "p_co": user.instituteId,
        "user_id": user.id,
        "user_type": user.userType.toString(),
        "hospital_id": hospitalId,
        "attendance_date": attendance.dated.split("T")[0],
        "students": attendanceRecords,
      });

      var body = jsonDecode(res.body);

      await loadStudentAttendanceRecords(
        attendance.hwrBatchId,
        attendance.hwrAttendanceId,
      );
      isStdLoading.value = false;
      return body as Map<String, dynamic>;
    } catch (e) {
      printError(info: e.toString());
      isStdLoading.value = false;
      return {"status": "ERROR", "message": e.toString()};
    }
  }

  Future<Map<String, dynamic>> deletAttendance(
    String attendanceId,
    String batchId,
  ) async {
    isStdLoading.value = true;
    try {
      var user = authController.user!;
      var res = await _http.postRequestEncoded('/delete_attendance', null, {
        "attendance_id": attendanceId,
        "p_co": user.instituteId,
        "user_id": user.id,
        "user_type": user.userType.toString(),
      });

      var body = jsonDecode(res.body);
      await loadInitialAttendanceRecords(batchId);

      isStdLoading.value = false;
      return body as Map<String, dynamic>;
    } catch (e) {
      printError(info: e.toString());
      isStdLoading.value = false;
      return {"status": "ERROR", "message": e.toString()};
    }
  }
}
