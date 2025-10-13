import 'package:get/get.dart';
import 'package:multi_admin/app/modules/admin_view/controllers/admin_view_controller.dart';
import 'package:multi_admin/app/modules/create_news/controllers/create_news_controller.dart';
import 'package:multi_admin/app/modules/navbar/controllers/navbar_controller.dart';
import 'package:multi_admin/app/modules/news_uploads/controllers/news_uploads_controller.dart';
import 'package:multi_admin/app/modules/settings/controllers/settings_controller.dart';
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
    Get.lazyPut<AdminController>(
      () => AdminController(),
      fenix: true, // Tambahkan ini
    );
    Get.lazyPut<CreateNewsController>(
      () => CreateNewsController(),
      fenix: true, // Tambahkan ini
    );
    Get.lazyPut<SettingsController>(
      () => SettingsController(),
      fenix: true, // Tambahkan ini
    );
    Get.lazyPut<NewsUploadsController>(
      () => NewsUploadsController(),
      fenix: true, // Tambahkan ini
    );
    Get.lazyPut<NavbarController>(
      () => NavbarController(),
      fenix: true, // Tambahkan ini
    );
  }
}
