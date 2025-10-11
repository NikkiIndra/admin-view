import 'package:get/get.dart';

import '../controllers/tren_report_location_controller.dart';

class TrenReportLocationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrenReportLocationController>(
      () => TrenReportLocationController(),
    );
  }
}
