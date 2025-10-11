import 'package:get/get.dart';
import 'package:multi_admin/app/modules/tren_report_location/controllers/tren_report_location_controller.dart';

import '../../modules/report_history/controllers/report_history_controller.dart';

class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TrenReportLocationController>(
      () => TrenReportLocationController(),
      fenix: true, // Tambahkan ini
    );
    Get.lazyPut<ReportHistoryController>(
      () => ReportHistoryController(),
      fenix: true, // Tambahkan ini
    );
  }
}
