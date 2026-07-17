import 'package:get/get.dart';
import 'package:icahs_hwr/controllers/attendance_controller.dart';
import 'package:icahs_hwr/controllers/auth_controller.dart';
import 'package:icahs_hwr/controllers/batch_controller.dart';
import 'package:icahs_hwr/controllers/dashboard_controller.dart';
import 'package:icahs_hwr/controllers/evaluation_controller.dart';
import 'package:icahs_hwr/controllers/navigation_controller.dart';
import 'package:icahs_hwr/controllers/report_controller.dart';
import 'package:icahs_hwr/controllers/student_controller.dart';
import 'package:icahs_hwr/service/http_service.dart';

class DependancyInjection {
  static void init() {
    final HttpService http = HttpService();

    var authController = Get.put(AuthController(http));
    Get.lazyPut(() => NavigationController());
    Get.lazyPut(() => DashboardController(http, authController)); 
    Get.lazyPut(() => BatchController(http, authController)); 
    Get.lazyPut(() => StudentController(http, authController)); 
    Get.lazyPut(() => AttendanceController(http, authController)); 
    Get.lazyPut(() => ReportController(http, authController)); 
    Get.lazyPut(() => EvaluationController(http, authController)); 
  }
}
