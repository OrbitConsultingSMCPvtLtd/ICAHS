import 'dart:convert';

import 'package:get/get.dart';
import 'package:icahs_hwr/controllers/auth_controller.dart';
import 'package:icahs_hwr/models/batch_model.dart';
import 'package:icahs_hwr/service/http_service.dart';

class BatchController extends GetxController {
  BatchController(this._http, this.authController);

  final HttpService _http;
  final AuthController authController;
  final RxList<BatchModel> batches = <BatchModel>[].obs;
  final Rxn<BatchModel> batchDetail = Rxn<BatchModel>();

  RxBool isLoading = false.obs;
  RxBool isDetailLoading = false.obs;

  bool hasMore = false;
  int offset = 0;

  int get activeBatchesCount {
    return batches.where((test) => test.status == 'Y').length;
  }

  int get inactiveBatchesCount {
    return batches.where((test) => test.status == 'N').length;
  }

  List<BatchModel> get activeBatches {
    return batches.where((test) => test.status == 'Y').toList();
  }

  List<BatchModel> get inactiveBatches {
    return batches.where((test) => test.status == 'N').toList();
  }

  Future<void> loadInitialBatches() async {
    isLoading.value = true;
    try {
      var user = authController.user!;
      offset = 0;

      var res = await _http.getRequest(
        '/batches/${user.instituteId}/${user.userType}/${user.id}',
        null,
      );

      var body = jsonDecode(res.body);
      hasMore = body['hasMore'];

      batches.assignAll(
        List<BatchModel>.from(
          (body['items'] as List).map((jsonData) {
            return BatchModel.fromJson(jsonData);
          }),
        ),
      );
    } catch (e) {
      printError(info: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreBatches() async {
    if (!hasMore) return;

    try {
      var user = authController.user!;
      offset += 25;

      var res = await _http.getRequest(
        '/batches/${user.instituteId}/${user.userType}/${user.id}',
        {'offset': offset.toString()},
      );
      var body = jsonDecode(res.body);
      hasMore = body['hasMore'];

      batches.addAll(
        List<BatchModel>.from(
          (body['items'] as List).map((jsonData) {
            return BatchModel.fromJson(jsonData);
          }),
        ),
      );
      return;
    } catch (e) {
       printError(info: e.toString());
      return;
    }
  }

  Future<void> getBatchDetails(String id) async {
    final user = authController.user!;
    try {
      isDetailLoading.value = true;
      var res = await _http.getRequest(
        "/batch_details/${user.instituteId}/$id/${user.userType}/${user.id}",
        null,
      );

      var body = jsonDecode(res.body);
      batchDetail.value = BatchModel.fromJson(body['items'][0]);
    } catch (e) {
      printError(info: e.toString());
    } finally {
      isDetailLoading.value = false;
    }
  }
}
