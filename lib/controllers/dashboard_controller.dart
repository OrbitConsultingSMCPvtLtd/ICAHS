import 'dart:convert';

import 'package:get/get.dart';
import 'package:icahs_hwr/controllers/auth_controller.dart';
import 'package:icahs_hwr/models/dashboard_stats.dart';
import 'package:icahs_hwr/service/http_service.dart';

class DashboardController extends GetxController {
  DashboardController(this._http);

  final HttpService _http;
  final AuthController _authController = Get.find<AuthController>();

  DashboardStats stats = DashboardStats();
  RxBool isLoading = false.obs;
  String? error;

  Future<void> loadDashboard() async {
    try {
      isLoading.value = true;
      error = null;

      final results = await Future.wait([
        getAttendanceCount(),
        getBatchesCount(),
        getBehaviourReportsCount(),
        getEvaluationCount(),
      ]);

      stats = DashboardStats(
        presentCount: results[0]['present'] as int,
        absentCount: results[0]['absent'] as int,
        totalAttendanceCount: results[0]['total_students'] as int,
        batchesCount: results[1]['total_batches'] as int,
        reportsCount: results[2]['total_reports'] as int,
        evaluationsCount: results[3]['total_evaluations'] as int,
      );
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> getAttendanceCount() async {
    var user = _authController.user!;
    try {
      final response = await _http.getRequest(
        '/attendance_count/${user.instituteId}/${user.userType}/${user.id}',
      );
      var body = jsonDecode(response.body);

      return body['items'][0];
    } catch (e) {
      printError(info: "Attendance ${e.toString()}");
      return {"present": 0, "absent": 0, "total_students": 0};
    }
  }

  Future<Map<String, dynamic>> getBatchesCount() async {
    var user = _authController.user!;
    try {
      final response = await _http.getRequest(
        '/batches_count/${user.instituteId}/${user.userType}/${user.id}',
      );
      var body = jsonDecode(response.body);

      return body['items'][0];
    } catch (e) {
      printError(info: "batches ${e.toString()}");
      return {"total_batches": 0};
    }
  }

  Future<Map<String, dynamic>> getEvaluationCount() async {
    var user = _authController.user!;
    try {
      final response = await _http.getRequest(
        '/evaluation_count/${user.instituteId}/${user.userType}/${user.id}',
      );
      var body = jsonDecode(response.body);

      return body['items'][0];
    } catch (e) {
      printError(info: "Eval ${e.toString()}");
      return {"total_evaluations": 0};
    }
  }

  Future<Map<String, dynamic>> getBehaviourReportsCount() async {
    var user = _authController.user!;
    try {
      final response = await _http.getRequest(
        '/behaviour_count/${user.instituteId}/${user.userType}/${user.id}',
      );
      var body = jsonDecode(response.body);

      return body['items'][0];
    } catch (e) {
      printError(info: "Report ${e.toString()}");
      return {"total_reports": 0};
    }
  }
}
