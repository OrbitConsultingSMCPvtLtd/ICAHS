import 'dart:convert';

import 'package:get/get.dart';
import 'package:icahs_hwr/controllers/auth_controller.dart';
import 'package:icahs_hwr/models/evaluation_model.dart';
import 'package:icahs_hwr/service/http_service.dart';

class EvaluationController extends GetxController {
  EvaluationController(this._http, this.authController);

  final HttpService _http;
  final AuthController authController;

  final RxList<EvaluationModel> evaluations = <EvaluationModel>[].obs;
  RxBool isLoading = false.obs;

  final Rxn<EvaluationModel> evaluationDetail = Rxn<EvaluationModel>();
  RxBool isDetailLoading = false.obs;

  final List<Map<String, dynamic>> learningAttitudeLov = [];
  final List<Map<String, dynamic>> levelOfSeriousnessLov = [];

  bool hasMore = false;
  int offset = 0;

  Future<void> loadInitialEvaluations(String batchId) async {
    isLoading.value = true;
    try {
      var user = authController.user!;
      offset = 0;

      var res = await _http.getRequest(
        '/show_evaluation_list/${user.instituteId}/$batchId/${user.userType}/${user.id}',
        null,
      );

      var body = jsonDecode(res.body);
      hasMore = body['hasMore'];
      evaluations.assignAll(
        List<EvaluationModel>.from(
          (body['items'] as List).map((jsonData) {
            return EvaluationModel.fromJson(jsonData);
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
      getLearningAttitudeLov();
      getLevelOfSeriousnessLov();
    });
  }

  Future<void> loadEvaluationDetails(
    String batchId,
    String evaluationId,
  ) async {
    // if (evaluationDetail.value != null &&
    //     evaluationDetail.value!.evaluationId == evaluationId &&
    //     evaluationDetail.value!.hwrBatchId == batchId) {
    //   return;
    // }
    final user = authController.user!;
    try {
      isDetailLoading.value = true;
      var res = await _http.getRequest(
        "/evaluation_details/${user.instituteId}/$batchId/${user.userType}/${user.id}/$evaluationId",
        null,
      );

      var body = jsonDecode(res.body);
      final items = body['items'];
      if (items != null && items.isNotEmpty) {
        evaluationDetail.value = EvaluationModel.fromJson(items[0]);
      } else {
        evaluationDetail.value = null;
      }
    } catch (e) {
      printError(info: e.toString());
    } finally {
      isDetailLoading.value = false;
    }
  }

  Future<Map<String, dynamic>> createEvaluation(
    Map<String, dynamic> bodyData,
  ) async {
    final user = authController.user!;

    var reqBody = {
      "user_id": user.id,
      "user_type": user.userType,
      "p_co": user.instituteId,
      'entered_by': 'APP',
      ...bodyData,
    };
    try {
      var res = await _http.postRequestEncoded(
        "/create_evaluation",
        null,
        reqBody,
      );

      var resBody = jsonDecode(res.body);

      await loadInitialEvaluations(bodyData['hwr_batch_id']);

      return resBody;
    } catch (e) {
      return {'status': 'ERROR', 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> updateEvaluation(
    Map<String, dynamic> bodyData,
  ) async {
    final user = authController.user!;

    var reqBody = {
      "user_id": user.id,
      "user_type": user.userType,
      "p_co": user.instituteId,
      'entered_by': 'APP',
      ...bodyData,
    };
    try {
      var res = await _http.postRequestEncoded(
        "/update_evaluation",
        null,
        reqBody,
      );

      var resBody = jsonDecode(res.body);

      await loadEvaluationDetails(
        bodyData['hwr_batch_id'],
        bodyData['evaluation_id'],
      );

      await loadInitialEvaluations(bodyData['hwr_batch_id']);
      return resBody;
    } catch (e) {
      return {'status': 'ERROR', 'message': e.toString()};
    }
  }

  Future<Map<String, dynamic>> deleteEvaluation(
    String batchId,
    String evaluationId,
  ) async {
    isLoading.value = true;
    try {
      var user = authController.user!;
      var res = await _http.postRequestEncoded('/delete_evaluation', null, {
        "p_co": user.instituteId,
        "user_id": user.id,
        "user_type": user.userType.toString(),
        "evaluation_id": evaluationId,
      });

      var body = jsonDecode(res.body);
      await loadInitialEvaluations(batchId);

      isLoading.value = false;
      return body as Map<String, dynamic>;
    } catch (e) {
      printError(info: e.toString());
      isLoading.value = false;
      return {"status": "ERROR", "message": e.toString()};
    }
  }

  Future<void> getLearningAttitudeLov() async {
    final user = authController.user!;
    try {
      var res = await _http.getRequest(
        "/learning_attitude_lov/${user.instituteId}",
      );
      var body = jsonDecode(res.body);
      learningAttitudeLov.assignAll(
        (body['items'] as List)
            .map((item) => Map<String, dynamic>.from(item))
            .toList(),
      );
    } catch (e) {
      printError(info: e.toString());
    }
  }

  Future<void> getLevelOfSeriousnessLov() async {
    final user = authController.user!;
    try {
      var res = await _http.getRequest(
        "/level_of_seriousness_lov/${user.instituteId}",
      );
      var body = jsonDecode(res.body);
      levelOfSeriousnessLov.assignAll(
        (body['items'] as List)
            .map((item) => Map<String, dynamic>.from(item))
            .toList(),
      );
    } catch (e) {
      printError(info: e.toString());
    }
  }
}
