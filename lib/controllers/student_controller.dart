import 'dart:convert';

import 'package:get/get.dart';
import 'package:icahs_hwr/controllers/auth_controller.dart';
import 'package:icahs_hwr/models/student_model.dart';
import 'package:icahs_hwr/service/http_service.dart';

class StudentController extends GetxController {
  StudentController(this._http, this.authController);

  final HttpService _http;
  final AuthController authController;

  final RxList<StudentModel> students = <StudentModel>[].obs;
  RxBool isLoading = false.obs;

  bool hasMore = false;
  int offset = 0;

  List<Map<String, dynamic>> get studentForLov => students
      .map(
        (student) => {
          "value": student.id,
          "label": "${student.name} [STU${student.id}]",
        },
      )
      .toList();

  Future<void> loadInitialStudents(String batchId) async {
    isLoading.value = true;
    try {
      var user = authController.user!;
      offset = 0;

      var res = await _http.getRequest(
        '/batch_student_list/${user.instituteId}/$batchId/${user.userType}/${user.id}',
        null,
      );

      var body = jsonDecode(res.body);
      hasMore = body['hasMore'];
      students.assignAll(
        List<StudentModel>.from(
          (body['items'] as List).map((jsonData) {
            return StudentModel.fromJson(jsonData);
          }),
        ),
      );
    } catch (e) {
      printError(info: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreStudents(String batchId) async {
    if (!hasMore) return;

    try {
      final user = authController.user!;
      offset += 25;

      var res = await _http.getRequest(
        '/batch_student_list/${user.instituteId}/$batchId/${user.userType}/${user.id}',
        {'offset': offset.toString()},
      );

      var body = jsonDecode(res.body);
      hasMore = body['hasMore'];

      students.addAll(
        List<StudentModel>.from(
          (body['items'] as List).map((jsonData) {
            return StudentModel.fromJson(jsonData);
          }),
        ),
      );
    } catch (e) {
      printError(info: e.toString());
      return;
    }
  }
}
