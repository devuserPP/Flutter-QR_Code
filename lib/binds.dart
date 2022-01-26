import 'package:get/get.dart';

import 'core/controllers/app_controller.dart';

class Binds extends Bindings {
  @override
  void dependencies() {
    // Get.put(Controller());
    Get.put(AppController());
  }
}
