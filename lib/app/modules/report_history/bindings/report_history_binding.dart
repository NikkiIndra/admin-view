import 'package:get/get.dart';

import '../controllers/report_history_controller.dart';

class ReportHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReportHistoryController>(
      () => ReportHistoryController(),
    );
  }
}
