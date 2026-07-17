import 'package:get/get.dart';
import 'package:icahs_hwr/controllers/attendance_controller.dart';
import 'package:icahs_hwr/controllers/auth_controller.dart';
import 'package:icahs_hwr/controllers/batch_controller.dart';
import 'package:icahs_hwr/controllers/dashboard_controller.dart';
import 'package:icahs_hwr/controllers/evaluation_controller.dart';
import 'package:icahs_hwr/controllers/report_controller.dart';
import 'package:icahs_hwr/controllers/student_controller.dart';
import 'package:icahs_hwr/service/http_service.dart';

class DependancyInjection {
  static void init() {
    final HttpService http = HttpService();

    Get.lazyPut(() => AuthController(http));
    Get.lazyPut(() => DashboardController(http)); 
    Get.lazyPut(() => BatchController(http)); 
    Get.lazyPut(() => StudentController(http)); 
    Get.lazyPut(() => AttendanceController(http)); 
    Get.lazyPut(() => ReportController(http)); 
    Get.lazyPut(() => EvaluationController(http)); 
  }
}
