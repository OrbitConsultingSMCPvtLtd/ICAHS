import 'dart:convert';

import 'package:get/get.dart';
import 'package:icahs_hwr/controllers/auth_controller.dart';
import 'package:icahs_hwr/models/report_model.dart';
import 'package:icahs_hwr/service/http_service.dart';

class ReportController extends GetxController {
  ReportController(this._http, this.authController);

  final HttpService _http;
  final AuthController authController;

  final RxList<ReportModel> reports = <ReportModel>[].obs;
  RxBool isLoading = false.obs;

  final Rxn<ReportModel> reportDetail = Rxn<ReportModel>();
  RxBool isDetailLoading = false.obs;

  final List<Map<String, dynamic>> issurLov = [];
  final List<Map<String, dynamic>> severityLov = [];
  final List<Map<String, dynamic>> actionLov = [];

  bool hasMore = false;
  int offset = 0;

  Future<void> loadInitialReports(String batchId) async {
    isLoading.value = true;
    try {
      var user = authController.user!;
      offset = 0;

      var res = await _http.getRequest(
        '/show_behaviour_list/${user.instituteId}/$batchId/${user.userType}/${user.id}',
        null,
      );

      var body = jsonDecode(res.body);
      hasMore = body['hasMore'];
      reports.assignAll(
        List<ReportModel>.from(
          (body['items'] as List).map((jsonData) {
            return ReportModel.fromJson(jsonData);
          }),
        ),
      );
    } catch (e) {
      printError(info: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadLovs() async {
    await Future.microtask(() {
      getIssueTypeLov();
      getSeverityLov();
      getActionsRequiredLov();
    });
  }

  Future<void> loadReportDetails(String batchId, String reportId) async {
    final user = authController.user!;
    try {
      isDetailLoading.value = true;
      var res = await _http.getRequest(
        "/behaviour_details/${user.instituteId}/$batchId/${user.userType}/${user.id}/$reportId",
      );

      var body = jsonDecode(res.body);

      final items = body['items'];
      if (items != null && items.isNotEmpty) {
        reportDetail.value = ReportModel.fromJson(items[0]);
      } else {
        reportDetail.value = null;
      }
    } catch (e) {
      printError(info: e.toString());
    } finally {
      isDetailLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> createBehaivourReport(
    Map<String, dynamic> bodyData,
  ) async {
    final user = authController.user!;

    var reqBody = {
      "p_co": user.instituteId,
      "user_id": user.id,
      "user_type": user.userType,
      ...bodyData,
    };
    try {
      var res = await _http.postRequestEncoded(
        "/create_behaviour_report",
        null,
        reqBody,
      );

      var resBody = jsonDecode(res.body);

      await loadInitialReports(bodyData['hwr_batch_id']);

      return {'status': resBody['status'], 'message': resBody['message']};
    } catch (e) {
      return {'status': 'ERROR', 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateBehaivourReport(
    Map<String, dynamic> bodyData,
  ) async {
    final user = authController.user!;

    var reqBody = {
      "p_co": user.instituteId,
      "user_id": user.id,
      "user_type": user.userType,
      ...bodyData,
    };
    try {
      var res = await _http.postRequestEncoded(
        "/update_behaviour",
        null,
        reqBody,
      );

      var resBody = jsonDecode(res.body);

      await loadReportDetails(bodyData['hwr_batch_id'], bodyData['report_id']);
      await loadInitialReports(bodyData['hwr_batch_id']);

      return {'status': resBody['status'], 'message': resBody['message']};
    } catch (e) {
      return {'status': 'ERROR', 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deletReport(
    String batchId,
    String reportId,
  ) async {
    isLoading.value = true;
    try {
      var user = authController.user!;
      var res = await _http.postRequestEncoded('/delete_behaviour', null, {
        "p_co": user.instituteId,
        "user_id": user.id,
        "user_type": user.userType.toString(),
        "report_id": reportId,
      });

      var body = jsonDecode(res.body);
      await loadInitialReports(batchId);

      isLoading.value = false;
      return body as Map<String, dynamic>;
    } catch (e) {
      printError(info: e.toString());
      isLoading.value = false;
      return {"status": "ERROR", "message": e.toString()};
    }
  }

  Future<void> getIssueTypeLov() async {
    final user = authController.user!;
    try {
      var res = await _http.getRequest("/issue_type_lov/${user.instituteId}");
      var body = jsonDecode(res.body);
      issurLov.assignAll(
        (body['items'] as List)
            .map((item) => Map<String, dynamic>.from(item))
            .toList(),
      );
    } catch (e) {
      printError(info: e.toString());
    }
  }

  Future<void> getSeverityLov() async {
    final user = authController.user!;
    try {
      var res = await _http.getRequest("/severity_lov/${user.instituteId}");

      var body = jsonDecode(res.body);
      severityLov.assignAll(
        (body['items'] as List)
            .map((item) => Map<String, dynamic>.from(item))
            .toList(),
      );
    } catch (e) {
      printError(info: e.toString());
    }
  }

  Future<void> getActionsRequiredLov() async {
    final user = authController.user!;
    try {
      var res = await _http.getRequest("/action_required/${user.instituteId}");

      var body = jsonDecode(res.body);
      actionLov.assignAll(
        (body['items'] as List)
            .map((item) => Map<String, dynamic>.from(item))
            .toList(),
      );
    } catch (e) {
      printError(info: e.toString());
    }
  }
}
