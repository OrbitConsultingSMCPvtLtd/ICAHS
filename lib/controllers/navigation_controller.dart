import 'package:get/get.dart';

class NavigationController extends GetxController {
  RxInt selectedIndex = 0.obs;

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  void goToBatches() {
    selectedIndex.value = 1;
  }

  void reset() {
    selectedIndex.value = 0;
  }
}
