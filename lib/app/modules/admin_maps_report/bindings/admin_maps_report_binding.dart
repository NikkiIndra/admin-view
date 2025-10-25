import 'package:get/get.dart';

import '../controllers/admin_maps_report_controller.dart';

class AdminMapsReportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminMapsReportController>(
      () => AdminMapsReportController(),
    );
  }
}
